import 'package:e_chat_app/core/di/injection_container.dart';
import 'package:e_chat_app/core/helper/app_config.dart';
import 'package:e_chat_app/e_chat_app.dart';
import 'package:flutter/material.dart';
import 'package:e_chat_app/core/routing/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await AppConfig.initialize();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  
  // Initialize DI (required before the app accesses DI)
  await setupAppInstances();
  runApp(EChatApp(appRouter: AppRouter()));
}