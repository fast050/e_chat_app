import 'package:e_chat_app/features/splash/ui/loading_done.dart';
import 'package:e_chat_app/features/splash/ui/loading_start.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoadingStartScreenFinish = false;

  void changeScreen() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoadingStartScreenFinish = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingStartScreenFinish) {
      return LoadingDone();
    }

    return LoadingStart();
  }
}
