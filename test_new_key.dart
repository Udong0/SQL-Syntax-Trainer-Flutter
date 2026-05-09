import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  try {
    // Mencoba dengan gemini-1.5-flash terlebih dahulu karena paling cepat
    final model = GenerativeModel(model: "gemini-flash-latest", apiKey: "AIzaSyAA0YIp8i6l8hhvW-goODWfx-uh1jEOI6E");
    final response = await model.generateContent([Content.text("Explain how AI works in a few words")]);
    print(response.text);
  } catch (e) {
    print("ACTUAL ERROR: " + e.toString());
  }
}
