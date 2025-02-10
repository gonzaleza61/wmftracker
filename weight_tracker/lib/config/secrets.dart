import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secrets {
  static String get openAIKey => dotenv.env['OPENAI_API_KEY'] ?? '';
}
