import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  try {
    final model = GenerativeModel(model: "gemini-1.5-pro", apiKey: "AIzaSyFakeKey1234567890abcdefghijklmnopqrstuv");
    final response = await model.generateContent([Content.text("Hello")]);
    print(response.text);
  } catch (e) {
    print("ACTUAL ERROR: " + e.toString());
  }
}
