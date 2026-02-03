import 'package:e_chat_app/features/auth/domain/repo/user_repository.dart';
import 'package:e_chat_app/features/auth/register/logic/register_user_information_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterUserInformationCubit extends Cubit<RegisterUserInformationState> {
  final UserRepository userRepository;

  RegisterUserInformationCubit(this.userRepository)
      : super(RegisterUserInformationState.initialState());

  void onUpdateUserName(String userName) {
    emit(state.copyWith(userName: userName));
  }

  void onUpdateUserImage(String userImageURL) {
    emit(state.copyWith(userImageURL: userImageURL));
  }

  Future<bool> onSubmittedUserInformationData() async {
    final currentErrors = _validateUserInfo(
        userName: state.userName, userImageURL: state.userImageURL);

    if (currentErrors.isNotEmpty) {
      emit(
        state.copyWith(
          errorMessage: _pickPriorityError(currentErrors).message,
          snackBarEventId: state.snackBarEventId + 1,
        ),
      );
      return false;
    }
    // ToDo this should be replace with update profile if user can set his image and send it to server 
    final isUpdated =  await userRepository.updateName(state.userName); 

    if (!isUpdated) {
      emit(
        state.copyWith(
          errorMessage: "Issue With Server, try again",
          snackBarEventId: state.snackBarEventId + 1,
        ),
      );
      return false;
    }

    emit(state.copyWith(errorMessage: null));
    return true;
  }

  Set<RegisterUserInformationError> _validateUserInfo({
    required String userName,
    required String? userImageURL,
  }) {
    final errors = <RegisterUserInformationError>{};

    final name = userName.trim();

    if (name.isEmpty) {
      errors.add(RegisterUserInformationError.emptyUserName);
    }

    if (name.length < 3) {
      errors.add(RegisterUserInformationError.userNameTooShort);
    }

    // ToDo should uncomment when the user can set his image and send it to server
    // if (userImageURL == null || userImageURL.trim().isEmpty) {
    //   errors.add(RegisterUserInformationError.missingImage);
    // }

    return errors;
  }

  RegisterUserInformationError _pickPriorityError(
      Set<RegisterUserInformationError> errors) {
    const priority = [
      RegisterUserInformationError.emptyUserName,
      RegisterUserInformationError.userNameTooShort,
      //RegisterUserInformationError.missingImage, ToDo should uncomment when the user can set his image and send it to server
    ];

    for (final e in priority) {
      if (errors.contains(e)) return e;
    }
    return errors.first;
  }
}
