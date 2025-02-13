import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_functions/cloud_functions.dart';

class ChatGPTService {
  final String _apiKey;
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  ChatGPTService(this._apiKey);

  Future<String> generateResponse(String prompt) async {
    final trimmedPrompt = prompt.trim();
    if (trimmedPrompt.isEmpty) {
      throw Exception('Please enter a question or prompt');
    }

    if (kIsWeb) {
      try {
        print(
            'Web: Attempting to call Cloud Function with prompt: "$trimmedPrompt"');
        final functions = FirebaseFunctions.instance;
        final result =
            await functions.httpsCallable('generateAIResponse').call({
          'prompt': trimmedPrompt,
        });

        print('Web: Cloud Function response received: ${result.data}');

        if (result.data == null || result.data['response'] == null) {
          throw Exception('Empty response from AI service');
        }

        return result.data['response'] as String;
      } catch (e) {
        print('Web API error details: $e');
        throw Exception('Failed to connect to AI service: $e');
      }
    } else {
      // Mobile implementation using direct API call
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
              {'role': 'user', 'content': trimmedPrompt}
            ],
          }),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 &&
            data['choices']?[0]?['message']?['content'] != null) {
          return data['choices'][0]['message']['content'];
        }
        throw Exception(
            'Failed to generate response. Status: ${response.statusCode}');
      } catch (e) {
        print('Mobile API error: $e');
        throw Exception('Failed to communicate with AI service: $e');
      }
    }
  }
}
