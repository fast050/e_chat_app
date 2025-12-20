import 'package:e_chat_app/features/login/ui/login_phone_step_view.dart';
import 'package:e_chat_app/features/login/ui/widget/stack_background_with_shape_login.dart';
import 'package:flutter/material.dart';
// import 'package:country_flags_pro/country_flags_pro.dart';
// import 'package:flag/flag.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StackBackgroundWithShapeLogin(
        shouldAnimate: true,
        child: SingleChildScrollView(
          child: LoginPhoneStepView(),
        ),
      ),
    );
  }
}
