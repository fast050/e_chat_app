import 'package:e_chat_app/core/di/injection_container.dart';
import 'package:e_chat_app/e_chat_app.dart';
import 'package:e_chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_chat_app/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase first (lightweight)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(EChatApp(appRouter: AppRouter()));
 
  // Initialize DI (now non-blocking thanks to async initialization in Cubits)
  await setupAppInstances();
}