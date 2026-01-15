import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPInputCubit extends Cubit<OTPInputState> {

  OTPInputCubit() : super(OTPInputState.initialState());

  void onVoid({String phoneNumber = '+44 7123 123 456'}) async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
  }
}
