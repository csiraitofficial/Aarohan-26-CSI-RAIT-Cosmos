import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Real-time speech-to-text service using on-device recognition.
/// Designed for disabled students who need voice input — text appears
/// live as they speak, no backend round-trip required.
class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;

  /// Callback fired when listening stops on its own (timeout, pause, error).
  /// The UI should use this to reset its recording state.
  void Function()? _onStopped;

  /// Human-readable reason for the last failure (shown in UI).
  String? lastError;

  /// Initialize the speech recognizer. Call once before first use.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speech.initialize(
        onError: (error) {
          print('[SpeechService] Error: ${error.errorMsg}');
          lastError = error.errorMsg;
          _isListening = false;
          _onStopped?.call();
        },
        onStatus: (status) {
          print('[SpeechService] Status: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            _onStopped?.call();
          }
        },
      );
    } catch (e) {
      print('[SpeechService] Initialize exception: $e');
      lastError = 'Speech init failed: $e';
      _isInitialized = false;
    }

    if (!_isInitialized) {
      lastError ??= 'Speech recognition not available on this device.';
    }
    return _isInitialized;
  }

  /// Start listening with real-time partial results.
  ///
  /// [onResult] is called repeatedly with the latest recognized text
  /// (both partial and final results), so the UI can update live.
  ///
  /// [onStopped] is called when listening stops on its own (timeout, error,
  /// or user pause) so the UI can reset its recording indicator.
  Future<bool> startListening({
    required void Function(String text, bool isFinal) onResult,
    void Function()? onStopped,
    String localeId = 'en_US',
  }) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return false;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    _onStopped = onStopped;
    _isListening = true;

    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        localeId: localeId,
        listenFor: const Duration(seconds: 120),
        pauseFor: const Duration(seconds: 5),
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          partialResults: true,
          cancelOnError: false,
        ),
      );
    } catch (e) {
      print('[SpeechService] Listen exception: $e');
      lastError = 'Failed to start listening: $e';
      _isListening = false;
      return false;
    }

    return true;
  }

  /// Stop listening and return whatever was recognized so far.
  Future<void> stopListening() async {
    _isListening = false;
    _onStopped = null;
    await _speech.stop();
  }

  /// Check if speech recognition is available on this device.
  Future<bool> get isAvailable async {
    if (!_isInitialized) await initialize();
    return _isInitialized;
  }

  /// Reset the service so it can be re-initialized on next use.
  /// Call this when navigating away from the speech screen.
  void dispose() {
    _speech.stop();
    _speech.cancel();
    _isListening = false;
    _isInitialized = false;
    _onStopped = null;
    _speech = stt.SpeechToText();
  }
}
