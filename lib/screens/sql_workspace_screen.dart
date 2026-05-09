import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/sql_workspace_provider.dart';

class SqlWorkspaceScreen extends StatelessWidget {
  const SqlWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL Syntax Trainer', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _LeftPanel(),
          ),
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
          Expanded(
            flex: 3,
            child: _RightPanel(),
          ),
        ],
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SqlWorkspaceProvider>();
    final scenario = provider.currentScenario;
    final isGenerating = provider.isGeneratingScenario;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Control Panel
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              const Text('Difficulty:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: provider.selectedLevel,
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: isGenerating ? null : (val) {
                  if (val != null) provider.updateLevel(val);
                },
                underline: const SizedBox(),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: isGenerating ? null : () => provider.generateNewScenario(),
                icon: isGenerating 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.autorenew, size: 18),
                label: Text(isGenerating ? 'Generating...' : 'Generate AI Scenario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Scenario Content
        Expanded(
          child: isGenerating 
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("AI sedang merakit skenario database unik...", style: TextStyle(color: Colors.grey)),
                ],
              ))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scenario.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(scenario.context, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    const Text('Database Schema:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Text(
                        scenario.schema,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Instruction:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        scenario.instruction,
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          flex: 3,
          child: _SqlEditor(),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.grey),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[50],
            child: const _FeedbackPanel(),
          ),
        ),
      ],
    );
  }
}

class _SqlEditor extends StatefulWidget {
  const _SqlEditor();

  @override
  State<_SqlEditor> createState() => _SqlEditorState();
}

class _SqlEditorState extends State<_SqlEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<SqlWorkspaceProvider>().updateQuery(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('SQL Editor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Consumer<SqlWorkspaceProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Row(
                      children: [
                        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        SizedBox(width: 8),
                        Text('AI is evaluating...', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
              decoration: InputDecoration(
                hintText: 'SELECT * FROM ...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SqlWorkspaceProvider>();
    final evaluation = provider.lastEvaluation;

    if (provider.currentQuery.isEmpty) {
      return const Center(child: Text('Tuliskan query di editor untuk mendapatkan evaluasi AI.', style: TextStyle(color: Colors.grey)));
    }

    if (provider.isLoading && evaluation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (evaluation == null) {
      return const Center(child: Text('Menunggu evaluasi...', style: TextStyle(color: Colors.grey)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                evaluation.isValid ? Icons.check_circle : Icons.error,
                color: evaluation.isValid ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                evaluation.isValid ? 'Query Valid!' : 'Query Memiliki Isu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: evaluation.isValid ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (evaluation.syntaxError != null)
            _FeedbackItem(title: 'Syntax Error', content: evaluation.syntaxError!, color: Colors.red[100]!, textColor: Colors.red[900]!),
          if (evaluation.logicError != null)
            _FeedbackItem(title: 'Logic Error', content: evaluation.logicError!, color: Colors.orange[100]!, textColor: Colors.orange[900]!),
          if (evaluation.suggestions != null)
            _FeedbackItem(title: 'Suggestions (Hint)', content: evaluation.suggestions!, color: Colors.blue[50]!, textColor: Colors.blue[900]!),
          if (evaluation.optimizedQuery != null)
            _FeedbackItem(
              title: 'Optimized Query (Solution)', 
              content: evaluation.optimizedQuery!, 
              color: Colors.green[50]!, 
              textColor: Colors.green[900]!,
              isCode: true,
            ),
        ],
      ),
    );
  }
}

class _FeedbackItem extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final Color textColor;
  final bool isCode;

  const _FeedbackItem({
    required this.title,
    required this.content,
    required this.color,
    required this.textColor,
    this.isCode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                if (isCode)
                  IconButton(
                    icon: Icon(Icons.copy, color: textColor, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Query disalin ke clipboard!')),
                      );
                    },
                    tooltip: 'Copy Query',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              content, 
              style: TextStyle(
                color: textColor,
                fontFamily: isCode ? 'monospace' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
