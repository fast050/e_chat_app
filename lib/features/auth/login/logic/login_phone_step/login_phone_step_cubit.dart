import 'package:e_chat_app/features/auth/login/logic/login_phone_step/login_phone_step_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPhoneStepCubit extends Cubit<LoginPhoneStepState> {
  LoginPhoneStepCubit() : super(LoginPhoneStepState.initialState());
  
   void onUpdatePhoneNumberValidation(bool isValid){
     emit(state.copyWith(isPhoneNumberValid: isValid));
   }

}
