import 'package:flutter/material.dart';
import '../services/chatgpt_service.dart';
import '../config/secrets.dart';

class AITrainerScreen extends StatefulWidget {
  @override
  _AITrainerScreenState createState() => _AITrainerScreenState();
}

class _AITrainerScreenState extends State<AITrainerScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  final ChatGPTService _chatGPT = ChatGPTService(Secrets.openAIKey);

  Future<void> _getResponse() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _chatGPT.generateResponse(_promptController.text);
      setState(() {
        _response = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
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
