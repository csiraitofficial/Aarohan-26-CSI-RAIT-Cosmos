import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Real-time speech-to-text service using on-device recognition.
/// Designed for disabled students who need voice input — text appears
/// live as they speak, no backend round-trip required.
class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;

  /// Initialize the speech recognizer. Call once before first use.
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onError: (error) {
        print('[SpeechService] Error: ${error.errorMsg}');
        _isListening = false;
      },
      onStatus: (status) {
        print('[SpeechService] Status: $status');
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
        }
      },
    );
    return _isInitialized;
  }

  /// Start listening with real-time partial results.
  ///
  /// [onResult] is called repeatedly with the latest recognized text
  /// (both partial and final results), so the UI can update live.
  Future<bool> startListening({
    required void Function(String text, bool isFinal) onResult,
    String localeId = 'en_US',
  }) async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return false;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    _isListening = true;
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

    return true;
  }

  /// Stop listening and return whatever was recognized so far.
  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }

  /// Check if speech recognition is available on this device.
  Future<bool> get isAvailable async {
    if (!_isInitialized) await initialize();
    return _isInitialized;
  }

  void dispose() {
    _speech.stop();
    _speech.cancel();
  }
}
