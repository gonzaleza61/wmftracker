import 'package:flutter/material.dart';
import '../services/chatgpt_service.dart';
import '../config/secrets.dart';

class AITrainerScreen extends StatefulWidget {
  @override
  _AITrainerScreenState createState() => _AITrainerScreenState();
}

class _AITrainerScreenState extends State<AITrainerScreen> {
  final TextEditingController _promptController = TextEditingController();
  List<ChecklistItem> _checklistItems = [];
  bool _isLoading = false;
  final ChatGPTService _chatGPT = ChatGPTService(Secrets.openAIKey);

  Future<void> _getResponse() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Add error handling for missing API key
      if (Secrets.openAIKey.isEmpty) {
        throw Exception('OpenAI API key not configured');
      }

      final response = await _chatGPT.generateResponse(_promptController.text);
      if (response.isEmpty) {
        throw Exception('Empty response from AI service');
      }

      // Split response into checklist items
      final items =
          response.split('\n').where((line) => line.trim().isNotEmpty).toList();
      setState(() {
        _checklistItems =
            items.map((item) => ChecklistItem(text: item)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error connecting to AI service: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Trainer'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: 'Ask your fitness question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getResponse,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Get Answer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _checklistItems.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_checklistItems[index].text),
                    value: _checklistItems[index].isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _checklistItems[index].isChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.red,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChecklistItem {
  String text;
  bool isChecked;

  ChecklistItem({
    required this.text,
    this.isChecked = false,
  });
}
