import 'dart:convert';

class DatabaseScenario {
  final String title;
  final String context;
  final String schema;
  final String instruction;

  const DatabaseScenario({
    required this.title,
    required this.context,
    required this.schema,
    required this.instruction,
  });

  static const defaultScenario = DatabaseScenario(
    title: 'Peer Tutoring Platform',
    context: 'Sistem peer tutoring dengan multi-role data integrity.',
    schema: '''
- Users (id, nama, role) -> role bisa 'tutor' atau 'student'
- Sessions (session_id, tutor_id, student_id, session_date) -> tutor_id dan student_id adalah FK ke Users.id
''',
    instruction: "Tuliskan query SQL menggunakan JOIN untuk menampilkan nama tutor, nama mahasiswa (student), dan tanggal sesi untuk semua sesi yang terjadi setelah '2026-05-01'.",
  );

  factory DatabaseScenario.fromJson(Map<String, dynamic> json) {
    return DatabaseScenario(
      title: json['title'] as String? ?? 'Custom Scenario',
      context: json['context'] as String? ?? '',
      schema: json['schema'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
    );
  }

  factory DatabaseScenario.fromRawJson(String str) {
    try {
      // Membersihkan markdown text jika terbungkus ```json ... ```
      String cleanStr = str.trim();
      if (cleanStr.startsWith('```json')) {
        cleanStr = cleanStr.substring(7);
      }
      if (cleanStr.endsWith('```')) {
        cleanStr = cleanStr.substring(0, cleanStr.length - 3);
      }
      return DatabaseScenario.fromJson(json.decode(cleanStr));
    } catch (e) {
      throw FormatException('Gagal mem-parsing scenario JSON: $e\nData: $str');
    }
  }
}
