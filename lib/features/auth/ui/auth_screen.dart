import 'package:e_chat_app/features/auth/login/ui/login_screen.dart';
import 'package:e_chat_app/features/auth/register/ui/register_screen.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  final AuthTab initialTab;

  const AuthScreen({super.key, this.initialTab = AuthTab.login});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthFlowCubit>().setInitialTab(widget.initialTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthFlowCubit, AuthFlowState>(
      buildWhen: (previous, current) =>
          previous.currentTab != current.currentTab,
      builder: (context, state) {
        return IndexedStack(
          index: state.currentTab.index,
          children: const [
            LoginScreen(),
            RegisterScreen(),
          ],
        );
      },
    );
  }
}
