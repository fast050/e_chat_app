import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late final String supabaseUrl;
  static late final String supabaseAnonKey;

  static Future<void> initialize() async{
    supabaseUrl = dotenv.env['SUPABASE_URL'] ??
        (throw Exception('SUPABASE_URL missing'));

    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ??
        (throw Exception('SUPABASE_ANON_KEY missing'));
  }
}