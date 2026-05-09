import 'dart:convert';

class SqlEvaluation {
  final bool isValid;
  final String? syntaxError;
  final String? logicError;
  final String? suggestions;
  final String? optimizedQuery;

  SqlEvaluation({
    required this.isValid,
    this.syntaxError,
    this.logicError,
    this.suggestions,
    this.optimizedQuery,
  });

  factory SqlEvaluation.fromJson(Map<String, dynamic> json) {
    return SqlEvaluation(
      isValid: json['is_valid'] ?? false,
      syntaxError: json['syntax_error'],
      logicError: json['logic_error'],
      suggestions: json['suggestions'],
      optimizedQuery: json['optimized_query'],
    );
  }

  factory SqlEvaluation.fromRawJson(String str) {
    // Sometime Gemini returns wrapped in ```json
    String cleanStr = str.trim();
    if (cleanStr.startsWith('```json')) {
      cleanStr = cleanStr.substring(7);
    }
    if (cleanStr.startsWith('```')) {
      cleanStr = cleanStr.substring(3);
    }
    if (cleanStr.endsWith('```')) {
      cleanStr = cleanStr.substring(0, cleanStr.length - 3);
    }
    return SqlEvaluation.fromJson(json.decode(cleanStr));
  }
}
