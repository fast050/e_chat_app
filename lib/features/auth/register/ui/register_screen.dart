import 'package:e_chat_app/features/auth/register/ui/Register_otp_step_view.dart';
import 'package:e_chat_app/features/auth/register/ui/Register_phone_step_view.dart';
import 'package:e_chat_app/features/auth/register/ui/register_user_information_view.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/auth_animated_background.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/stack_background_with_shape_auth.dart';
import 'package:flutter/material.dart';

/*
  to know which RegisterStepView to Show we have two Flow in the Register RegisterScreen
   - Phone Input 
   - OTP Input 
*/
enum RegisterStepView { phone, otp, userInformation }

class RegisterScreen extends StatefulWidget {
  final Function() onLoginNavigate;
  final Function() onNavigationScreen;

  const RegisterScreen({super.key, 
  required this.onLoginNavigate, 
  required this.onNavigationScreen});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterStepView currentView = RegisterStepView.phone;

  void goToOTP() => setState(() => currentView = RegisterStepView.otp);

  void backToPhone() => setState(() => currentView = RegisterStepView.phone);

  void goToUserInfo() =>
      setState(() => currentView = RegisterStepView.userInformation);      

  Widget getCurrentView(RegisterStepView current) {
    switch (current) {
      case RegisterStepView.phone:
        return RegisterPhoneStepView(
          onStepViewNavigate: goToOTP,
          onLoginNavigate: widget.onLoginNavigate,
        );
      case RegisterStepView.otp:
        return RegisterOTPStepView(
          onBackNavigation: backToPhone,
          onLoginNavigate: widget.onLoginNavigate,
          onUserInfoNavigation: goToUserInfo,
        );
      case RegisterStepView.userInformation:
        return RegisterUserInformationView(
          onNavigateScreen: widget.onNavigationScreen,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentView == RegisterStepView.phone,
      // Handle system back when pop is blocked
      onPopInvoked: (didPop) {
        if (!didPop && currentView == RegisterStepView.otp) {
          backToPhone(); // OTP → Phone
        }
      },
      child: Scaffold(
        body: StackBackgroundWithShapeAuth(
          shouldAnimate: true,
          curveSidePosition: currentView == RegisterStepView.userInformation
              ? CurveSidePosition.center
              : CurveSidePosition.end,
          child: SingleChildScrollView(child: getCurrentView(currentView)),
        ),
      ),
    );
  }
}
