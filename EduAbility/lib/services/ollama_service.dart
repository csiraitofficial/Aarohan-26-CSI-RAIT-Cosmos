import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/services/api_service.dart';

/// Service to communicate with Ollama LLM **through the Node.js backend proxy**.
/// The backend forwards requests to the local Ollama instance, so the app
/// works on physical devices via the dev tunnel — no direct network access needed.
class OllamaService {
  static const String modelName = 'llama3.2:3b';

  static const String _systemPrompt =
      'You are a patient, encouraging AI tutor helping specially-abled students learn. '
      'Use simple, clear language. Break explanations into small steps. '
      'Be warm and supportive. Never make the student feel rushed. '
      'Use bullet points for lists. Keep responses under 250 words.';

  /// Backend proxy base (same dev tunnel the rest of the app uses).
  String get _proxyBase => '${ApiService.baseUrl}/ollama';

  /// Human-readable reason for the last failed connection check.
  String? lastError;

  /// Currently loaded material filename (for context in chat).
  String? currentMaterialTitle;

  /// Summary of the currently loaded material.
  String? currentMaterialSummary;

  /// Check if Ollama is reachable (via backend proxy).
  /// Uses the lightweight /health endpoint first, falls back to /tags.
  Future<bool> checkConnection() async {
    try {
      // Try the lightweight health endpoint first
      final uri = Uri.parse('$_proxyBase/health');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        lastError = null;
        return true;
      }

      // Parse backend error for useful info
      try {
        final body = jsonDecode(response.body);
        lastError = body['hint'] ?? body['error'] ?? 'Status ${response.statusCode}';
      } catch (_) {
        lastError = 'Backend returned status ${response.statusCode}';
      }
      return false;
    } on http.ClientException catch (e) {
      lastError = 'Cannot reach backend server.\n${e.message}';
      return false;
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        lastError = 'Connection timed out — is the dev tunnel active?';
      } else {
        lastError = 'Network error: $e';
      }
      return false;
    }
  }

  /// Send a chat message to Ollama (via backend proxy) and return the response.
  Future<String> sendMessage(String userMessage) async {
    final uri = Uri.parse('$_proxyBase/generate');

    // Prepend material context if loaded
    String context = _systemPrompt;
    if (currentMaterialTitle != null && currentMaterialSummary != null) {
      context =
          '$_systemPrompt\n\n(Student is studying: $currentMaterialTitle)\nMaterial summary: $currentMaterialSummary';
    }

    final payload = {
      'model': modelName,
      'prompt': '$context\n\nStudent: $userMessage\nTutor:',
      'stream': false,
      'options': {
        'num_predict': 256,   // cap output tokens for speed
        'temperature': 0.7,
        'num_gpu': 99,        // offload all layers to GPU
      },
    };

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = (data['response'] ?? '').toString().trim();
        return text.isNotEmpty
            ? text
            : 'Sorry, I could not generate a response.';
      } else {
        return 'Ollama returned status ${response.statusCode}. '
            'Make sure the model "$modelName" is pulled.';
      }
    } catch (e) {
      return 'Could not reach Ollama. Make sure the backend and Ollama are running.\n\nError: $e';
    }
  }

  /// Upload and summarize an educational material file (PDF or TXT).
  /// Returns the summary text, or an error string prefixed with "ERROR:" on failure.
  Future<String?> summarizeMaterial(List<int> fileBytes, String filename) async {
    final uri = Uri.parse('$_proxyBase/summarize');

    try {
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'material',
          fileBytes,
          filename: filename,
        ),
      );

      final response = await request.send().timeout(const Duration(seconds: 120));
      final responseData = await response.stream.bytesToString();
      print('[OllamaService] Summarize response ${response.statusCode}: $responseData');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        final summary = data['summary'] ?? '';
        final title = data['title'] ?? filename;

        currentMaterialTitle = title;
        currentMaterialSummary = summary;
        return summary;
      } else {
        // Parse backend error for a useful message
        try {
          final data = jsonDecode(responseData);
          lastError = data['detail'] ?? data['error'] ?? 'Status ${response.statusCode}';
        } catch (_) {
          lastError = 'Backend returned status ${response.statusCode}';
        }
        print('[OllamaService] Summarize failed: $lastError');
        return 'ERROR:$lastError';
      }
    } catch (e) {
      lastError = 'Failed to summarize material: $e';
      print('[OllamaService] Summarize exception: $e');
      return 'ERROR:$lastError';
    }
  }

  /// Clear the currently loaded material context.
  void clearMaterial() {
    currentMaterialTitle = null;
    currentMaterialSummary = null;
  }
}
