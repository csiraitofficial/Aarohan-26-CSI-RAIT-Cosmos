import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SignLanguageScreen extends StatefulWidget {
  const SignLanguageScreen({super.key});

  @override
  State<SignLanguageScreen> createState() => _SignLanguageScreenState();
}

class _SignLanguageScreenState extends State<SignLanguageScreen>
    with SingleTickerProviderStateMixin {
  // ── Mock mode ──────────────────────────────────────────────────────────
  final bool _isMockMode = false; // start in mock mode by default
  Timer? _mockFlexTimer;
  Timer? _mockGestureTimer;
  final Random _rng = Random();

  // ── 5 finger flex values: Thumb, Index, Middle, Ring, Pinky ────────────
  List<double> _flexValues = [0, 0, 0, 0, 0];

  String _displayedIntent = "";
  String _latestSpeech = "";
  bool _isSpeechVisible = false;

  // Animation controller for the hand icon pulse
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    if (_isMockMode) {
      _startMockData();
    }
  }

  // ── Orchestrated Mock Animation Logic ──────────────────────────────────
  bool _isMocking = false;

  void _setFlex(List<double> targets) {
    if (!mounted) return;
    setState(() {
      _flexValues = List.generate(5, (i) {
        // Add some realistic jitter to the target values
        return (targets[i] + (_rng.nextDouble() * 100 - 50)).clamp(0.0, 1000.0);
      });
    });
  }

  Future<void> _runMockSequence() async {
    bool isFirstSequence = true;

    while (_isMocking && mounted) {
      if (!mounted) break;

      setState(() {
        _displayedIntent = "";
        _latestSpeech = "";
        _isSpeechVisible = false;
        _flexValues = [0, 0, 0, 0, 0];
      });

      // Initial wait before starting sequence
      await Future.delayed(const Duration(seconds: 2));
      if (!_isMocking || !mounted) break;

      if (isFirstSequence) {
        // --- SEQUENCE 1: "you like learn sign" ---
        _setFlex([60, 800, 60, 60, 60]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "you");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        _setFlex([800, 60, 800, 60, 60]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "you like");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        _setFlex([800, 800, 800, 800, 800]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "you like learn");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        _setFlex([800, 800, 60, 60, 60]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "you like learn sign");

        // Extended pause
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!_isMocking || !mounted) break;

        // Relax hand
        _setFlex([60, 60, 60, 60, 60]);
        await Future.delayed(const Duration(milliseconds: 800));
        if (!_isMocking || !mounted) break;

        setState(() {
          _latestSpeech = "";
          _isSpeechVisible = true;
        });

        const speechText = "Do you like learning sign language?";
        for (int i = 0; i < speechText.length; i++) {
          if (!_isMocking || !mounted) break;
          await Future.delayed(const Duration(milliseconds: 40));
          setState(() {
            _latestSpeech += speechText[i];
          });
        }
      } else {
        // --- SEQUENCE 2: "I always call my good friend" ---
        // "I" -> every little finger except thumb (Index, Middle, Ring, Pinky)
        _setFlex([60, 800, 800, 800, 800]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "I");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        // "always" -> index + partial other fingers
        _setFlex([60, 800, 300, 300, 300]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "I always");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        // "call" -> thumb and pinky
        _setFlex([800, 60, 60, 60, 800]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "I always call");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        // "my" -> all fingers flexed a little bit
        _setFlex([300, 300, 300, 300, 300]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "I always call my");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        // "good" -> move thumb
        _setFlex([800, 60, 60, 60, 60]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "I always call my good");
        await Future.delayed(const Duration(seconds: 1));
        if (!_isMocking || !mounted) break;

        // "friend" -> all fingers
        _setFlex([800, 800, 800, 800, 800]);
        await Future.delayed(const Duration(milliseconds: 700));
        setState(() => _displayedIntent = "I always call my good friend");

        // Extended pause
        await Future.delayed(const Duration(milliseconds: 1500));
        if (!_isMocking || !mounted) break;

        // Relax hand
        _setFlex([60, 60, 60, 60, 60]);
        await Future.delayed(const Duration(milliseconds: 800));
        if (!_isMocking || !mounted) break;

        // Typing effect
        setState(() {
          _latestSpeech = "";
          _isSpeechVisible = true;
        });

        const speechText = "I always call my good friend.";
        for (int i = 0; i < speechText.length; i++) {
          if (!_isMocking || !mounted) break;
          await Future.delayed(const Duration(milliseconds: 40));
          setState(() {
            _latestSpeech += speechText[i];
          });
        }
      }

      // Toggle sequence for next loop
      isFirstSequence = !isFirstSequence;

      // Keep the final result on screen for 6 seconds before looping the sequence
      await Future.delayed(const Duration(seconds: 6));
    }
  }

  void _startMockData() {
    _stopMockData();
    _isMocking = true;
    _runMockSequence();
  }

  void _stopMockData() {
    _isMocking = false;
    _mockFlexTimer?.cancel();
    _mockFlexTimer = null;
    _mockGestureTimer?.cancel();
    _mockGestureTimer = null;
  }

  @override
  void dispose() {
    _stopMockData();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Finger bar widget ──────────────────────────────────────────────────
  Widget _buildFlexBar(
    String label,
    double rawValue,
    IconData icon,
    Color color,
  ) {
    double maxExpected = 1000.0;
    double normalized = (rawValue.abs() / maxExpected).clamp(0.0, 1.0);

    if (rawValue.abs() <= 1.0 && rawValue != 0) {
      normalized = rawValue.abs();
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            rawValue.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 36,
            height: 140,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                width: 36,
                height: 140 * normalized,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.7), color],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fingerColors = [
      const Color(0xFFE91E63), // Thumb  – pink
      const Color(0xFF2196F3), // Index  – blue
      const Color(0xFF4CAF50), // Middle – green
      const Color(0xFFFF9800), // Ring   – orange
      const Color(0xFF9C27B0), // Pinky  – purple
    ];
    final fingerLabels = ['Thumb', 'Index', 'Middle', 'Ring', 'Pinky'];
    final l = AppLocalizations.of(context)!;
    final fingerIcons = [
      Icons.thumb_up_alt_outlined,
      Icons.back_hand_outlined,
      Icons.front_hand_outlined,
      Icons.ring_volume_outlined,
      Icons.pinch_outlined,
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + _pulseController.value * 0.15,
                        child: Icon(
                          Icons.sign_language,
                          size: 28,
                          color: theme.primaryColor,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l.signLanguageIot,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Status + Mode Toggle ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.green, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.pcHubConnected,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            l.receivingTransmissions,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Section: Flex Sensors ────────────────────────────────
              const Row(
                children: [
                  Icon(Icons.sensors, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Smart Glove — 5 Finger Flex',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── 5 Finger Bars ────────────────────────────────────────
              Container(
                height: 240,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(5, (i) {
                    return _buildFlexBar(
                      fingerLabels[i],
                      _flexValues[i],
                      fingerIcons[i],
                      fingerColors[i],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // ── Section: AI Output ───────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l.aiTranslation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Intent output card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primaryColor, theme.primaryColorDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sign_language, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          'Detected Gesture:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _displayedIntent.isEmpty
                          ? l.waiting
                          : _displayedIntent.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    if (_isSpeechVisible) ...[
                      const Divider(color: Colors.white30, height: 28),
                      Row(
                        children: [
                          const Icon(
                            Icons.record_voice_over,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.llmFluentSpeech,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _latestSpeech.isEmpty
                              ? l.waitingForOllama
                              : '"$_latestSpeech"',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                '🔗 ${l.liveModeConnected}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
