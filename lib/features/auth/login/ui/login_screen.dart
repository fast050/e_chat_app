import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/auth/login/ui/login_otp_step_view.dart';
import 'package:e_chat_app/features/auth/login/ui/login_phone_step_view.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/auth_animated_background.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/stack_background_with_shape_auth.dart';
import 'package:flutter/material.dart';

/*
  to know which LoginStepView to Show we have two Flow in the Login LoginScreen
   - Phone Input 
   - OTP Input 
*/
enum LoginStepView { phone, otp }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginStepView currentView = LoginStepView.phone;
  void goToOTP() => setState(() {
        currentView = LoginStepView.otp;
      });
  void backToPhone() => setState(() {
        currentView = LoginStepView.phone;
      });

  void navigateToRegister() => context.pushNamed(Routes.register);    

  int keyOtp = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentView == LoginStepView.phone,
      // Handle system back when pop is blocked
      onPopInvoked: (didPop) {
        if (!didPop && currentView == LoginStepView.otp) {
          backToPhone(); // OTP → Phone
        }
      },
      child: Scaffold(
        body: StackBackgroundWithShapeAuth(
          shouldAnimate: true,
          curveSidePosition: CurveSidePosition.start,
          child: SingleChildScrollView(
              child: currentView == LoginStepView.phone
                  ? LoginPhoneStepView(
                      onStepViewNavigate: goToOTP,
                      onRegisterNavigate: navigateToRegister,
                    )
                  : LoginOTPStepView(
                      onBackNavigation: backToPhone, 
                      onRegisterNavigate: navigateToRegister,
                    )),
        ),
      ),
    );
  }
}
