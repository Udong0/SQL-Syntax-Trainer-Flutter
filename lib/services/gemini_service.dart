import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/sql_evaluation.dart';
import '../models/database_scenario.dart';

/// Service yang menggunakan Ollama (lokal) dengan model qwen2.5-coder:7b.
/// Jalankan Ollama terlebih dahulu: ollama serve
/// Pull model: ollama pull qwen2.5-coder:7b
class GeminiService {
  static const String _baseUrl = 'http://localhost:11434/v1/chat/completions';
  static const String _model = 'qwen2.5-coder:7b';

  GeminiService();

  String _getApiKey() {
    // Ollama tidak memerlukan API key
    return 'ollama';
  }

  /// Mengirim request ke Ollama API
  Future<String> _sendRequest({
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final apiKey = _getApiKey();

    final body = jsonEncode({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userPrompt},
      ],
      'temperature': 0.7,
      'response_format': {'type': 'json_object'},
    });

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Ollama error (${response.statusCode}): ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['choices'][0]['message']['content'] as String;
    return content;
  }

  Future<SqlEvaluation> evaluateSQL(
      String userQuery, String schemaContext) async {
    try {
      const systemPrompt =
          "Kamu adalah seorang Database Administrator dan instruktur SQL yang galak tapi suportif. "
          "Tugasmu adalah mengevaluasi input SQL dari pengguna berdasarkan skema database yang diberikan. "
          "Cek syntax error. Jika syntax benar, cek apakah logikanya sesuai dengan instruksi. "
          "Berikan saran jika query bisa dioptimasi (misal: mengingatkan soal penggunaan alias tabel atau tipe JOIN yang lebih tepat). "
          "Selalu balas dalam format JSON dengan field: "
          "is_valid (boolean), syntax_error (string atau null), logic_error (string atau null), "
          "suggestions (string atau null), optimized_query (string).";

      final userPrompt = '''
$schemaContext

USER QUERY:
$userQuery
''';

      final content = await _sendRequest(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
      );

      return SqlEvaluation.fromRawJson(content);
    } catch (e) {
      debugPrint('evaluateSQL error: $e');
      return SqlEvaluation(
        isValid: false,
        syntaxError: 'Gagal terhubung ke Ollama. Pastikan Ollama sudah berjalan (ollama serve): ${e.toString()}',
      );
    }
  }

  Future<DatabaseScenario> generateScenario(String difficultyLevel) async {
    String difficultyInstruction = "";
    if (difficultyLevel == 'Beginner') {
      difficultyInstruction =
          "Gunakan maksimal 2 tabel, fokus pada SELECT, WHERE, dan JOIN dasar.";
    } else if (difficultyLevel == 'Intermediate') {
      difficultyInstruction =
          "Gunakan 3-4 tabel, fokus pada JOIN kompleks, GROUP BY, HAVING, dan agregasi.";
    } else {
      difficultyInstruction =
          "Fokus pada Subqueries, CTE (WITH), Window Functions, atau logika kondisional (CASE WHEN).";
    }

    final systemPrompt =
        "Kamu adalah ahli pembuat soal SQL. Buat sebuah skenario database baru yang belum pernah ada. "
        "Tingkat kesulitan: $difficultyLevel. "
        "$difficultyInstruction "
        "Bentuk jawaban selalu dalam format JSON murni dengan field: "
        "title (string), context (string), schema (string berisi bullet points daftar tabel dan kolomnya sertakan relasi FK/PK), "
        "instruction (string berisi satu buah soal query SQL yang harus dipecahkan siswa).";

    final userPrompt =
        "Buat satu skenario database acak dengan tema yang benar-benar berbeda dari sebelumnya. "
        "Tingkat kesulitan: $difficultyLevel. Pastikan sesuai dengan kriteria tingkat kesulitan tersebut.";

    try {
      final content = await _sendRequest(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
      );
      return DatabaseScenario.fromRawJson(content);
    } catch (e) {
      throw Exception("Gagal membuat skenario: $e");
    }
  }
}
