import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../../services/disability_provider.dart';
import '../../services/ollama_service.dart';
import '../../services/speech_service.dart';

class OfflineAiScreen extends StatefulWidget {
  const OfflineAiScreen({super.key});

  @override
  State<OfflineAiScreen> createState() => _OfflineAiScreenState();
}

class _OfflineAiScreenState extends State<OfflineAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final OllamaService _ollama = OllamaService();
  final FlutterTts _tts = FlutterTts();
  final SpeechService _speech = SpeechService();
  final List<_ChatMessage> _messages = [];

  bool _isLoading = false;
  bool _isConnected = false;
  bool _isCheckingConnection = true;
  bool _ttsEnabled = true;
  bool _isSummarizing = false;
  bool _isRecording = false;
  int _questionStreak = 0;

  // ── ADHD Pomodoro timer ──
  Timer? _pomodoroTimer;
  int _pomodoroSeconds = 300; // 5 minutes
  bool _pomodoroRunning = false;
  int _pomodoroSessions = 0;

  // ── ADHD refocus buzz ──
  Timer? _refocusTimer;
  bool _refocusBuzzEnabled = true;

  // ── Autistic routine tracker ──
  int _autisticStep = 0; // 0=Read, 1=Ask, 2=Quiz

  // ── Dyslexia reading ruler ──
  bool _readingRulerOn = false;
  double _rulerPositionY = 200;

  // ── Deaf-Mute fingerspell ──
  final Set<int> _expandedSignBubbles = {};

  /// Periodic timer that keeps retrying while offline.
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _initTts();
    _checkConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l = AppLocalizations.of(context)!;
      _addBotMessage('👋 ${l.aiTutorWelcome}');
    });
  }

  /// Initialize text-to-speech settings
  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5); // Slower speech for clarity
    _tts.setCompletionHandler(() {
      // Can be used for callbacks when speech completes
    });
  }

  Future<void> _checkConnection() async {
    if (mounted) setState(() => _isCheckingConnection = true);
    final connected = await _ollama.checkConnection();
    if (mounted) {
      setState(() {
        _isConnected = connected;
        _isCheckingConnection = false;
      });
      // Start or stop the auto-retry timer based on connection state.
      if (connected) {
        _retryTimer?.cancel();
        _retryTimer = null;
      } else {
        _startRetryTimer();
      }
    }
  }

  /// Retry every 8 seconds while offline — stops once connected.
  void _startRetryTimer() {
    if (_retryTimer != null && _retryTimer!.isActive) return;
    _retryTimer = Timer.periodic(const Duration(seconds: 8), (_) async {
      if (!mounted) {
        _retryTimer?.cancel();
        return;
      }
      final connected = await _ollama.checkConnection();
      if (mounted) {
        setState(() {
          _isConnected = connected;
          _isCheckingConnection = false;
        });
        if (connected) {
          _retryTimer?.cancel();
          _retryTimer = null;
        }
      }
    });
  }

  void _addBotMessage(String text) {
    if (text.isEmpty) return;

    // Auto-read if TTS is enabled - split long text for better performance
    if (_ttsEnabled) {
      _speakFullText(text);
    }

    // Add empty message first and capture its index
    setState(() {
      _messages.add(const _ChatMessage(role: _Role.assistant, content: ''));
    });
    final messageIndex = _messages.length - 1;

    // Split into chunks (words + trailing whitespace) for a natural typing stream
    final chunks = <String>[];
    String currentChunk = '';
    for (int i = 0; i < text.length; i++) {
      currentChunk += text[i];
      if (text[i].trim().isEmpty) {
        chunks.add(currentChunk);
        currentChunk = '';
      }
    }
    if (currentChunk.isNotEmpty) chunks.add(currentChunk);

    int chunkIndex = 0;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || messageIndex >= _messages.length) {
        timer.cancel();
        return;
      }

      setState(() {
        _messages[messageIndex] = _ChatMessage(
          role: _Role.assistant,
          content: _messages[messageIndex].content + chunks[chunkIndex],
        );
      });
      _scrollToBottom();

      chunkIndex++;
      if (chunkIndex >= chunks.length) {
        timer.cancel();
      }
    });
  }

  /// Read text using TTS, splitting into chunks if necessary
  Future<void> _speakFullText(String text) async {
    // Remove markdown-style formatting for better speech
    String cleanText = text
        .replaceAll(RegExp(r'\*\*'), '')
        .replaceAll(RegExp(r'\*'), '')
        .replaceAll(RegExp(r'#+\s'), '')
        .replaceAll('📚', 'Textbook')
        .replaceAll('❌', 'Error')
        .replaceAll('✅', 'Success')
        .replaceAll('🎤', 'Microphone')
        .replaceAll('📄', 'Document')
        .replaceAll(
          RegExp(r'\n\n+'),
          '. ',
        ); // Replace multiple newlines with periods

    await _tts.speak(cleanText);
  }

  Future<void> _uploadMaterial() async {
    final l = AppLocalizations.of(context)!;
    if (!_isConnected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.connectToOllama)));
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
        lockParentWindow: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;
        final filename = file.name;

        if (bytes == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l.failedToReadFile)));
          return;
        }

        setState(() => _isSummarizing = true);
        _addBotMessage('📚 ${l.summarizingMaterial}');

        final summary = await _ollama.summarizeMaterial(bytes, filename);

        if (mounted) {
          setState(() => _isSummarizing = false);

          if (summary != null && summary.startsWith('ERROR:')) {
            final errorDetail = summary.substring(6);
            _addBotMessage('❌ ${l.failedToSummarize}: $errorDetail');
          } else if (summary != null && summary.isNotEmpty) {
            _addBotMessage('📄 **${l.summaryTitle(filename)}**\n\n$summary');
          } else {
            _addBotMessage('❌ ${l.failedToSummarizeMaterial}');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSummarizing = false);
        _addBotMessage('❌ ${l.errorUploadingFile}: $e');
      }
    }
  }

  void _fillQuickAction(String text) {
    _controller.text = text;
    // Advance autistic step to Quiz when quiz action is used
    final lowerText = text.toLowerCase();
    if ((lowerText.contains('quiz') || lowerText.contains('question')) &&
        _autisticStep < 2) {
      setState(() => _autisticStep = 2);
    }
  }

  /// Start real-time speech recognition — text appears live, auto-sends on finish
  Future<void> _startSpeechRecording() async {
    final started = await _speech.startListening(
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() {
          _controller.text = text;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
        });
        if (isFinal && text.trim().isNotEmpty) {
          setState(() => _isRecording = false);
          _sendMessage();
        }
      },
      onStopped: () {
        // Speech engine stopped on its own (timeout / pause / error).
        // Sync the UI so the mic button isn't stuck in "recording" state.
        if (!mounted) return;
        if (_isRecording) {
          setState(() => _isRecording = false);
          // Auto-send whatever was captured
          if (_controller.text.trim().isNotEmpty) {
            _sendMessage();
          }
        }
      },
    );
    if (!mounted) return;
    if (started) {
      setState(() => _isRecording = true);
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎤 ${l.listeningSpeak}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      final l = AppLocalizations.of(context)!;
      final detail = _speech.lastError ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '❌ ${l.speechNotAvailable}${detail.isNotEmpty ? '\n$detail' : ''}',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Stop real-time speech recognition and send immediately
  Future<void> _stopSpeechRecording() async {
    await _speech.stopListening();
    if (!mounted) return;
    setState(() => _isRecording = false);
    if (_controller.text.trim().isNotEmpty) {
      _sendMessage();
    }
  }

  // ── Pomodoro timer methods ──────────────────────────────────────────────────
  void _startPomodoro() {
    setState(() => _pomodoroRunning = true);
    _startRefocusTimer();
    _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_pomodoroSeconds > 0) {
          _pomodoroSeconds--;
        } else {
          _pomodoroTimer?.cancel();
          _pomodoroRunning = false;
          _pomodoroSessions++;
          _pomodoroSeconds = 300;
          _stopRefocusTimer();
          // Buzz phone on session complete — strong pattern
          Vibration.vibrate(pattern: [0, 300, 200, 300, 200, 500]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Great focus! Session $_pomodoroSessions complete. Take a break!',
              ),
              backgroundColor: Colors.purple.shade700,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    });
  }

  void _pausePomodoro() {
    _pomodoroTimer?.cancel();
    _stopRefocusTimer();
    setState(() => _pomodoroRunning = false);
  }

  void _resetPomodoro() {
    _pomodoroTimer?.cancel();
    _stopRefocusTimer();
    setState(() {
      _pomodoroRunning = false;
      _pomodoroSeconds = 300;
    });
  }

  String get _pomodoroDisplay {
    final m = (_pomodoroSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_pomodoroSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Refocus buzz — gentle vibration every 60s to keep ADHD focus ──────────
  void _startRefocusTimer() {
    _stopRefocusTimer();
    if (!_refocusBuzzEnabled) return;
    _refocusTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (!mounted || !_pomodoroRunning || !_refocusBuzzEnabled) return;
      // Gentle double-tap buzz
      Vibration.vibrate(pattern: [0, 100, 80, 100]);
    });
  }

  void _stopRefocusTimer() {
    _refocusTimer?.cancel();
    _refocusTimer = null;
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(role: _Role.user, content: text));
      _isLoading = true;
      _questionStreak++;
      if (_autisticStep < 1) _autisticStep = 1;
    });
    _controller.clear();
    _scrollToBottom();

    final disability = context.read<DisabilityProvider>().disability;
    final reply = await _ollama.sendMessage(text, disability: disability);

    if (mounted) {
      _addBotMessage(reply);
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 380;
    final colorScheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final currentDisability = context.watch<DisabilityProvider>().disability;

    return Column(
      children: [
        // ── Connection banner ──────────────────────────────────────
        _buildConnectionBanner(colorScheme, l),

        // ── Disability mode banner ─────────────────────────────────
        Consumer<DisabilityProvider>(
          builder: (context, dp, _) {
            if (dp.disability == DisabilityType.none) {
              return const SizedBox.shrink();
            }
            return _buildDisabilityBanner(dp.disability, colorScheme);
          },
        ),

        // ── Autistic routine tracker ────────────────────────────────
        Consumer<DisabilityProvider>(
          builder: (context, dp, _) {
            if (dp.disability != DisabilityType.autistic)
              return const SizedBox.shrink();
            return _buildAutisticRoutine();
          },
        ),

        // ── Toolbar: Upload + TTS ──────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: colorScheme.surface,
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isSummarizing ? null : _uploadMaterial,
                icon: const Icon(Icons.upload_file, size: 18),
                label: Text('📚 ${l.upload}'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Consumer<DisabilityProvider>(
                builder: (context, dp, _) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DisabilityType>(
                      value: dp.disability,
                      isDense: true,
                      icon: Icon(
                        Icons.accessibility_new,
                        size: 16,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSecondaryContainer,
                      ),
                      items: DisabilityType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(DisabilityProvider.labels[type]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) dp.setDisability(value);
                      },
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_ollama.currentMaterialTitle != null)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          _ollama.currentMaterialTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _ollama.clearMaterial();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.close, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              IconButton(
                onPressed: () {
                  setState(() => _ttsEnabled = !_ttsEnabled);
                  if (_ttsEnabled) {
                    _tts.speak(l.ttsEnabled);
                  }
                },
                icon: Icon(
                  _ttsEnabled ? Icons.volume_up : Icons.volume_off,
                  color: _ttsEnabled
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
                tooltip: _ttsEnabled ? l.ttsOn : l.ttsOff,
              ),
            ],
          ),
        ),

        // ── Messages ───────────────────────────────────────────────
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 10 : 14,
                  vertical: 12,
                ),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l.thinking,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final msg = _messages[index];
                  final isUser = msg.role == _Role.user;

                  return Consumer<DisabilityProvider>(
                    builder: (context, dp, _) {
                      final dt = dp.disability;
                      final isDyslexia = dt == DisabilityType.dyslexia;
                      final isAutistic = dt == DisabilityType.autistic;
                      final isAdhd = dt == DisabilityType.adhd;
                      final isDeafMute = dt == DisabilityType.deafMute;

                      // --- Bubble color per disability ---
                      Color bubbleColor;
                      if (isUser) {
                        bubbleColor = isAutistic
                            ? const Color(0xFFB2DFDB)
                            : colorScheme.primaryContainer;
                      } else {
                        if (isDyslexia) {
                          bubbleColor = const Color(0xFFFFF8E1);
                        } else if (isAutistic) {
                          bubbleColor = const Color(0xFFE0F2F1);
                        } else if (isAdhd) {
                          bubbleColor = const Color(0xFFF3E5F5);
                        } else if (isDeafMute) {
                          bubbleColor = const Color(0xFFE3F2FD);
                        } else {
                          bubbleColor = Colors.grey[200]!;
                        }
                      }

                      // --- Text style per disability ---
                      TextStyle msgStyle;
                      if (isDyslexia) {
                        msgStyle = TextStyle(
                          fontSize: isSmall ? 18 : 20,
                          height: 2.0,
                          letterSpacing: 1.5,
                          wordSpacing: 4.0,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2E2E2E),
                        );
                      } else if (isAutistic) {
                        msgStyle = TextStyle(
                          fontSize: isSmall ? 15 : 16,
                          height: 1.6,
                          letterSpacing: 0.3,
                          color: const Color(0xFF37474F),
                        );
                      } else if (isAdhd) {
                        msgStyle = TextStyle(
                          fontSize: isSmall ? 14 : 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4A148C),
                        );
                      } else {
                        msgStyle = TextStyle(
                          fontSize: isSmall ? 15 : 16,
                          height: 1.4,
                        );
                      }

                      final signExpanded = _expandedSignBubbles.contains(index);

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: isAutistic ? 10 : 6,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isDyslexia ? 20 : (isSmall ? 14 : 18),
                            vertical: isDyslexia ? 16 : (isSmall ? 10 : 12),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: size.width * 0.78,
                          ),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(
                              isAutistic ? 8 : 16,
                            ),
                            border: isAutistic
                                ? Border.all(
                                    color: const Color(0xFF80CBC4),
                                    width: 1,
                                  )
                                : isAdhd
                                ? Border.all(
                                    color: const Color(0xFFCE93D8),
                                    width: 1.5,
                                  )
                                : isDeafMute && !isUser
                                ? Border.all(
                                    color: const Color(0xFF90CAF9),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ADHD: FOCUS badge
                              if (isAdhd && !isUser)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7B1FA2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'FOCUS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              Text(msg.content, style: msgStyle),

                              // Dyslexia: per-bubble TTS button
                              if (isDyslexia && !isUser)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: GestureDetector(
                                    onTap: () => _speakFullText(msg.content),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.volume_up,
                                            size: 14,
                                            color: Colors.orange.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Read Aloud',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.orange.shade700,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              // Deaf-Mute: Fingerspell toggle
                              if (isDeafMute && !isUser) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (signExpanded) {
                                          _expandedSignBubbles.remove(index);
                                        } else {
                                          _expandedSignBubbles.add(index);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: signExpanded
                                            ? Colors.blue.shade600
                                            : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.sign_language,
                                            size: 14,
                                            color: signExpanded
                                                ? Colors.white
                                                : Colors.blue.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            signExpanded
                                                ? 'Hide Signs'
                                                : 'Fingerspell',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: signExpanded
                                                  ? Colors.white
                                                  : Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (signExpanded)
                                  _buildFingerspellRow(msg.content),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // ── Reading ruler overlay (Dyslexia) ──
              if (_readingRulerOn)
                Positioned(
                  top: _rulerPositionY,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _rulerPositionY = (_rulerPositionY + details.delta.dy)
                            .clamp(0.0, 500.0);
                      });
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        border: Border(
                          top: BorderSide(
                            color: Colors.orange.shade400,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.orange.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // ── Quick action buttons ───────────────────────────────────
        if (_isConnected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _quickActionChip(
                    l.explainSimply,
                    l.explainSimplyPrompt,
                    colorScheme,
                  ),
                  const SizedBox(width: 8),
                  _quickActionChip(l.quizMe, l.quizMePrompt, colorScheme),
                  const SizedBox(width: 8),
                  _quickActionChip(l.summarize, l.summarizePrompt, colorScheme),
                ],
              ),
            ),
          ),

        // ── Input area ─────────────────────────────────────────────
        Container(
          padding: EdgeInsets.all(isSmall ? 8 : 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              // Microphone button for speech input
              IconButton.filled(
                onPressed: (_isLoading || !_isConnected || _isSummarizing)
                    ? null
                    : (_isRecording
                          ? _stopSpeechRecording
                          : _startSpeechRecording),
                icon: Icon(_isRecording ? Icons.mic : Icons.mic_none),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(12),
                style: IconButton.styleFrom(
                  backgroundColor: _isRecording
                      ? Colors.red.shade400
                      : colorScheme.primary,
                ),
                tooltip: _isRecording ? l.stopRecording : l.startVoiceInput,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  keyboardType: currentDisability == DisabilityType.deafMute
                      ? TextInputType.none
                      : TextInputType.multiline,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: _isConnected
                        ? l.typeOrVoice
                        : l.tutorNotAvailable,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isSmall ? 12 : 14,
                    ),
                  ),
                  onTap: () {
                    if (currentDisability == DisabilityType.deafMute) {
                      // Force hide software keyboard
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    }
                  },
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (_) {
                    if (currentDisability == DisabilityType.deafMute) {
                      // Force it hidden again in case typing brings it up
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    }
                  },
                  enabled: _isConnected && !_isSummarizing && !_isRecording,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: (_isLoading || !_isConnected || _isSummarizing)
                    ? null
                    : _sendMessage,
                icon: const Icon(Icons.send),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickActionChip(
    String label,
    String action,
    ColorScheme colorScheme,
  ) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () => _fillQuickAction(action),
      backgroundColor: colorScheme.secondaryContainer,
      side: BorderSide(color: colorScheme.outline, width: 0.5),
    );
  }

  Widget _buildFingerspellRow(String text) {
    // Take the first sentence or first 30 chars for fingerspelling
    String sentence = text.split(RegExp(r'[.!?\n]')).first.trim();
    if (sentence.length > 40) sentence = sentence.substring(0, 40);
    final letters = sentence.toUpperCase().split('');

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 52,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: letters.length,
          itemBuilder: (context, i) {
            final ch = letters[i];
            if (ch == ' ') {
              return const SizedBox(width: 12);
            }
            return Container(
              width: 38,
              height: 48,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ch,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Icon(Icons.back_hand, size: 12, color: Colors.blue.shade300),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAutisticRoutine() {
    final icons = [Icons.menu_book, Icons.chat_bubble_outline, Icons.quiz];
    final labels = ['Read', 'Ask', 'Quiz'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: const Color(0xFFE0F2F1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(icons.length * 2 - 1, (i) {
          // Odd indices are connectors
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            return Container(
              width: 32,
              height: 3,
              color: _autisticStep > stepIdx
                  ? Colors.teal.shade600
                  : Colors.teal.shade100,
            );
          }
          final stepIdx = i ~/ 2;
          final isActive = _autisticStep >= stepIdx;
          final isCurrent = _autisticStep == stepIdx;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.teal.shade600 : Colors.teal.shade50,
                  border: isCurrent
                      ? Border.all(color: Colors.teal.shade800, width: 2.5)
                      : Border.all(color: Colors.teal.shade200, width: 1),
                ),
                child: Icon(
                  icons[stepIdx],
                  size: 20,
                  color: isActive ? Colors.white : Colors.teal.shade300,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[stepIdx],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? Colors.teal.shade800 : Colors.teal.shade300,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDisabilityBanner(DisabilityType dt, ColorScheme colorScheme) {
    switch (dt) {
      case DisabilityType.autistic:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          color: const Color(0xFFE0F2F1),
          child: Row(
            children: [
              Icon(Icons.spa, size: 16, color: Colors.teal.shade700),
              const SizedBox(width: 8),
              Text(
                'Calm Mode Active — Structured responses enabled',
                style: TextStyle(fontSize: 12, color: Colors.teal.shade800),
              ),
            ],
          ),
        );
      case DisabilityType.adhd:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: const Color(0xFFF3E5F5),
          child: Row(
            children: [
              Icon(Icons.bolt, size: 16, color: Colors.purple.shade700),
              const SizedBox(width: 6),
              Text(
                'Focus',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple.shade800,
                ),
              ),
              const SizedBox(width: 10),
              // Pomodoro timer
              GestureDetector(
                onTap: _pomodoroRunning ? _pausePomodoro : _startPomodoro,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _pomodoroRunning
                        ? Colors.purple.shade700
                        : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _pomodoroRunning ? Icons.pause : Icons.play_arrow,
                        size: 14,
                        color: _pomodoroRunning
                            ? Colors.white
                            : Colors.purple.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _pomodoroDisplay,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          color: _pomodoroRunning
                              ? Colors.white
                              : Colors.purple.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: _resetPomodoro,
                child: Icon(
                  Icons.refresh,
                  size: 16,
                  color: Colors.purple.shade400,
                ),
              ),
              const Spacer(),
              // Refocus buzz toggle
              GestureDetector(
                onTap: () {
                  setState(() => _refocusBuzzEnabled = !_refocusBuzzEnabled);
                  if (_refocusBuzzEnabled && _pomodoroRunning) {
                    _startRefocusTimer();
                  } else {
                    _stopRefocusTimer();
                  }
                  // Demo feedback: buzz once when enabling
                  if (_refocusBuzzEnabled) {
                    Vibration.vibrate(duration: 100);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _refocusBuzzEnabled
                        ? Colors.purple.shade600
                        : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.vibration,
                        size: 12,
                        color: _refocusBuzzEnabled
                            ? Colors.white
                            : Colors.purple.shade400,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Buzz',
                        style: TextStyle(
                          color: _refocusBuzzEnabled
                              ? Colors.white
                              : Colors.purple.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_pomodoroSessions > 0)
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'S$_pomodoroSessions',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_questionStreak Q${_questionStreak == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      case DisabilityType.dyslexia:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          color: const Color(0xFFFFF8E1),
          child: Row(
            children: [
              Icon(Icons.text_fields, size: 16, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dyslexia-Friendly Mode',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _readingRulerOn = !_readingRulerOn),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _readingRulerOn
                        ? Colors.orange.shade700
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.straighten,
                        size: 14,
                        color: _readingRulerOn
                            ? Colors.white
                            : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ruler',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _readingRulerOn
                              ? Colors.white
                              : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case DisabilityType.deafMute:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          color: const Color(0xFFE3F2FD),
          child: Row(
            children: [
              Icon(Icons.sign_language, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Visual Mode Active — Tap "Fingerspell" on responses',
                style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildConnectionBanner(ColorScheme colorScheme, AppLocalizations l) {
    if (_isCheckingConnection) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: Colors.orange.shade50,
        child: Row(
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l.checkingTutorConnection,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_isConnected) {
      return GestureDetector(
        onTap: _checkConnection,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                '${l.tutorConnected} • ${OllamaService.modelName}',
                style: TextStyle(fontSize: 13, color: Colors.green.shade800),
              ),
            ],
          ),
        ),
      );
    }

    // ── Offline — show error detail + auto-retry notice ──
    return GestureDetector(
      onTap: _checkConnection,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Colors.red.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.tutorOffline,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade800,
                    ),
                  ),
                ),
                Icon(Icons.refresh, size: 16, color: Colors.red.shade600),
              ],
            ),
            if (_ollama.lastError != null) ...[
              const SizedBox(height: 4),
              Text(
                _ollama.lastError!,
                style: TextStyle(fontSize: 11, color: Colors.red.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _pomodoroTimer?.cancel();
    _refocusTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    _tts.stop();
    _speech.dispose();
    super.dispose();
  }
}

// ── Private data types ────────────────────────────────────────────────────────

enum _Role { user, assistant }

class _ChatMessage {
  final _Role role;
  final String content;
  const _ChatMessage({required this.role, required this.content});
}
