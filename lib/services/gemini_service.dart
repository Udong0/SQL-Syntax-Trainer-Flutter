import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/sql_evaluation.dart';
import '../models/database_scenario.dart';

class GeminiService {
  GenerativeModel? _model;

  GeminiService();

  void _initModelIfNeeded() {
    if (_model != null) return;

    // Mengambil API Key dari .env
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'API_KEY_ANDA_DISINI') {
      throw Exception(
          "API Key tidak ditemukan atau belum diubah di file .env. Pastikan Anda sudah mengisi GEMINI_API_KEY dengan benar.");
    }
    // Definisi JSON Schema untuk response yang ketat
    final responseSchema = Schema.object(
      properties: {
        'is_valid': Schema.boolean(),
        'syntax_error': Schema.string(nullable: true),
        'logic_error': Schema.string(nullable: true),
        'suggestions': Schema.string(nullable: true),
        'optimized_query': Schema.string(),
      },
      requiredProperties: ['is_valid', 'optimized_query'],
    );

    // System Instruction untuk membentuk evaluator
    final systemInstruction = Content.system(
        "Kamu adalah seorang Database Administrator dan instruktur SQL yang galak tapi suportif. "
        "Tugasmu adalah mengevaluasi input SQL dari pengguna berdasarkan skema database yang diberikan. "
        "Cek syntax error. Jika syntax benar, cek apakah logikanya sesuai dengan instruksi. "
        "Berikan saran jika query bisa dioptimasi (misal: mengingatkan soal penggunaan alias tabel atau tipe JOIN yang lebih tepat). "
        "Selalu balas dalam format JSON.");

    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: responseSchema,
      ),
    );
  }

  Future<SqlEvaluation> evaluateSQL(
      String userQuery, String schemaContext) async {
    try {
      _initModelIfNeeded();
      final prompt = '''
$schemaContext

USER QUERY:
$userQuery
''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception("Empty response from AI");
      }

      return SqlEvaluation.fromRawJson(text);
    } catch (e) {
      // Return a fallback error state
      return SqlEvaluation(
        isValid: false,
        syntaxError: 'Gagal terhubung ke AI Evaluator: \${e.toString()}',
      );
    }
  }

  Future<DatabaseScenario> generateScenario(String difficultyLevel) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'API_KEY_ANDA_DISINI') {
      throw Exception("API Key tidak ditemukan.");
    }

    final schema = Schema.object(
      properties: {
        'title': Schema.string(),
        'context': Schema.string(),
        'schema': Schema.string(),
        'instruction': Schema.string(),
      },
      requiredProperties: ['title', 'context', 'schema', 'instruction'],
    );

    String difficultyInstruction = "";
    if (difficultyLevel == 'Beginner') {
      difficultyInstruction = "Gunakan maksimal 2 tabel, fokus pada SELECT, WHERE, dan JOIN dasar.";
    } else if (difficultyLevel == 'Intermediate') {
      difficultyInstruction = "Gunakan 3-4 tabel, fokus pada JOIN kompleks, GROUP BY, HAVING, dan agregasi.";
    } else {
      difficultyInstruction = "Fokus pada Subqueries, CTE (WITH), Window Functions, atau logika kondisional (CASE WHEN).";
    }

    final model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: apiKey,
      systemInstruction: Content.system(
          "Kamu adalah ahli pembuat soal SQL. Buat sebuah skenario database baru yang belum pernah ada. "
          "Tingkat kesulitan: $difficultyLevel. "
          "$difficultyInstruction "
          "Bentuk jawaban selalu dalam format JSON murni. "
          "Field 'schema' harus berisi bullet points daftar tabel dan kolomnya (sertakan relasi FK/PK). "
          "Field 'instruction' harus berisi satu buah soal query SQL yang harus dipecahkan siswa."
      ),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    try {
      // Tambahkan instruksi acak (random seed) agar tidak menghasilkan skenario yang sama terus menerus
      final prompt = "Buat satu skenario database acak dengan tema yang benar-benar berbeda dari sebelumnya. Tingkat kesulitan: $difficultyLevel. Pastikan sesuai dengan kriteria tingkat kesulitan tersebut.";
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception("Empty response from AI");
      }
      return DatabaseScenario.fromRawJson(text);
    } catch (e) {
      throw Exception("Gagal membuat skenario: $e");
    }
  }
}
