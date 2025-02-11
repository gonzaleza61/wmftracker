import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatGPTService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  final String _apiKey;

  ChatGPTService(this._apiKey);

  Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a knowledgeable fitness trainer. Provide concise, accurate advice about workouts, nutrition, and fitness goals.',
            },
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data['choices'][0]['message']['content'];
      }
      throw Exception(
          'Failed to generate response. Status: ${response.statusCode}');
    } catch (e) {
      print('Error in ChatGPT service: $e');
      throw Exception('Failed to communicate with AI service: $e');
    }
  }
}
