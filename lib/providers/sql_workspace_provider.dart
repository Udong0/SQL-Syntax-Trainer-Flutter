import 'dart:async';
import 'package:flutter/material.dart';
import '../models/database_scenario.dart';
import '../models/sql_evaluation.dart';
import '../services/gemini_service.dart';

class SqlWorkspaceProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  
  // State
  DatabaseScenario _currentScenario = DatabaseScenario.defaultScenario;
  String _currentQuery = "";
  bool _isLoading = false;
  bool _isGeneratingScenario = false;
  String _selectedLevel = 'Beginner';
  SqlEvaluation? _lastEvaluation;

  // Getters
  DatabaseScenario get currentScenario => _currentScenario;
  String get currentQuery => _currentQuery;
  bool get isLoading => _isLoading;
  bool get isGeneratingScenario => _isGeneratingScenario;
  String get selectedLevel => _selectedLevel;
  SqlEvaluation? get lastEvaluation => _lastEvaluation;

  // Setters
  void updateLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  Future<void> generateNewScenario() async {
    _isGeneratingScenario = true;
    _lastEvaluation = null;
    _currentQuery = "";
    notifyListeners();

    try {
      final newScenario = await _geminiService.generateScenario(_selectedLevel);
      _currentScenario = newScenario;
    } catch (e) {
      debugPrint("Failed to generate scenario: $e");
      // keep old scenario on error
    } finally {
      _isGeneratingScenario = false;
      notifyListeners();
    }
  }

  void updateQuery(String newQuery) {
    _currentQuery = newQuery;
    notifyListeners();
  }

  Future<void> evaluateQuery() async {
    if (_currentQuery.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    final schemaContext = '''
SCENARIO: ${_currentScenario.title}
CONTEXT: ${_currentScenario.context}
SCHEMA:
${_currentScenario.schema}
INSTRUCTION: ${_currentScenario.instruction}
''';

    final result = await _geminiService.evaluateSQL(_currentQuery, schemaContext);
    
    _lastEvaluation = result;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
