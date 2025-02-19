import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/chatgpt_service.dart';
import '../config/secrets.dart';

class AITrainerScreen extends StatefulWidget {
  const AITrainerScreen({super.key});

  @override
  AITrainerScreenState createState() => AITrainerScreenState();
}

class AITrainerScreenState extends State<AITrainerScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  String _errorMessage = '';
  late final ChatGPTService _chatGPT;

  @override
  void initState() {
    super.initState();
    try {
      _chatGPT = ChatGPTService(Secrets.openAIKey);
    } catch (e) {
      _errorMessage = 'Failed to initialize AI service: $e';
    }
  }

  Future<void> _getResponse() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a question or prompt')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _chatGPT.generateResponse(prompt);
      if (!mounted) return;
      setState(() {
        _response = response;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            if (kIsWeb && _errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ask me anything about fitness...',
                border: OutlineInputBorder(),
                suffixIcon: _promptController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _promptController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _getResponse,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Get Answer'),
            ),
            SizedBox(height: 16),
            if (_response.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_response),
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
