import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/auth/login/ui/login_screen.dart';
import 'package:e_chat_app/features/auth/register/ui/register_screen.dart';
import 'package:flutter/material.dart';

enum AuthTab { login, register }

class AuthScreen extends StatefulWidget {
  final AuthTab initialTab;

  const AuthScreen({super.key, this.initialTab = AuthTab.login});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthTab _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  void _showLogin() => setState(() => _currentTab = AuthTab.login);

  void _showRegister() => setState(() => _currentTab = AuthTab.register);

  void goToHome() => context.pushReplacementNamed(Routes.home);

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentTab.index,
      children: [
        LoginScreen(
          onRegisterNavigate: _showRegister,
          onNavigateScreen: goToHome,
        ),
        RegisterScreen(
          onLoginNavigate: _showLogin,
          onNavigationScreen: goToHome,
        ),
      ],
    );
  }
}
