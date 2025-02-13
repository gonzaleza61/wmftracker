import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_config.dart';

class Secrets {
  static String get openAIKey {
    if (kIsWeb) {
      // For web, we don't need the API key as we're using Cloud Functions
      return 'using-cloud-functions';
    }

    final key = dotenv.env['OPENAI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('OpenAI API key not found in .env file');
    }
    return key;
  }
}
