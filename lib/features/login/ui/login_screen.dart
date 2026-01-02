import 'package:e_chat_app/features/login/ui/login_otp_step_view.dart';
import 'package:e_chat_app/features/login/ui/login_phone_step_view.dart';
import 'package:e_chat_app/features/login/ui/widget/stack_background_with_shape_login.dart';
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
  String phoneNumber = " ";
  LoginStepView currentView = LoginStepView.phone;
  void goToOTP() => setState(() {
        currentView = LoginStepView.otp;
      });
  void backToPhone() => setState(() {
        currentView = LoginStepView.phone;
      });
  void setPhoneNumber(String phone) => {phoneNumber = phone};

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentView == LoginStepView.phone,
      child: Scaffold(
        body: StackBackgroundWithShapeLogin(
          shouldAnimate: true,
          child: SingleChildScrollView(
            child: currentView == LoginStepView.phone
                ? LoginPhoneStepView(
                  onStepViewNavigate: goToOTP,
                  onSubmitPhone: setPhoneNumber,
                )
                : LoginOTPStepView(
                  
                ),
          ),
        ),
      ),
    );
  }
}
