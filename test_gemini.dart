import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  final apiKey = 'AIzaSyDdVFvlXCrnnsgUWiz0xCA7eVp94BaK0Qk';
  
  try {
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

    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      systemInstruction: Content.system("You are a helpful assistant."),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: responseSchema,
      ),
    );

    final response = await model.generateContent([Content.text("Hello")]);
    print(response.text);
  } catch (e) {
    print("ERROR: \$e");
  }
}
