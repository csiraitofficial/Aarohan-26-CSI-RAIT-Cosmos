import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile/l10n/app_localizations.dart';
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
    setState(() {
      _messages.add(_ChatMessage(role: _Role.assistant, content: text));
    });
    _scrollToBottom();
    // Auto-read if TTS is enabled - split long text for better performance
    if (_ttsEnabled) {
      _speakFullText(text);
    }
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ ${l.speechNotAvailable}')));
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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(role: _Role.user, content: text));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final reply = await _ollama.sendMessage(text);

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

    return Column(
      children: [
        // ── Connection banner ──────────────────────────────────────
        _buildConnectionBanner(colorScheme, l),

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
          child: ListView.builder(
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

              return Align(
                alignment: isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 14 : 18,
                    vertical: isSmall ? 10 : 12,
                  ),
                  constraints: BoxConstraints(maxWidth: size.width * 0.78),
                  decoration: BoxDecoration(
                    color: isUser
                        ? colorScheme.primaryContainer
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    msg.content,
                    style: TextStyle(fontSize: isSmall ? 15 : 16, height: 1.4),
                  ),
                ),
              );
            },
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
