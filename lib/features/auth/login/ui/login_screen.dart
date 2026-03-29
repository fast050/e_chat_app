import 'package:e_chat_app/features/auth/login/ui/login_otp_step_view.dart';
import 'package:e_chat_app/features/auth/login/ui/login_phone_step_view.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/auth_animated_background.dart';
import 'package:e_chat_app/features/auth/shared/widgets/animated_background/stack_background_with_shape_auth.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthFlowCubit, AuthFlowState>(
      buildWhen: (previous, current) =>
          previous.loginStepView != current.loginStepView,
      builder: (context, state) {
        final currentView = state.loginStepView;
        return PopScope(
          canPop: currentView == LoginStepView.phone,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && currentView == LoginStepView.otp) {
              context.read<AuthFlowCubit>().backToLoginPhone();
            }
          },
          child: Scaffold(
            body: StackBackgroundWithShapeAuth(
              shouldAnimate: true,
              curveSidePosition: CurveSidePosition.start,
              child: SingleChildScrollView(
                child: currentView == LoginStepView.phone
                    ? const LoginPhoneStepView()
                    : const LoginOTPStepView(),
              ),
            ),
          ),
        );
      },
    );
  }
}
