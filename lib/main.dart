import 'package:e_chat_app/core/di/injection_container.dart';
import 'package:e_chat_app/e_chat_app.dart';
import 'package:flutter/material.dart';
import 'package:e_chat_app/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI (required before the app accesses DI)
  await setupAppInstances();
  runApp(EChatApp(appRouter: AppRouter()));
}