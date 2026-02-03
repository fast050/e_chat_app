class RegisterUserInformationState {
  final String userName;
  final String? userImageURL;
  final String? errorMessage;
  final int snackBarEventId;


  const RegisterUserInformationState({
    required this.userName,
    required this.userImageURL,
    this.errorMessage,
    required this.snackBarEventId,
  });

  const RegisterUserInformationState.initialState()
      : userName = "",
        userImageURL = null,
        errorMessage = null,
        snackBarEventId = 0;

  RegisterUserInformationState copyWith(
      {String? userName,
      String? userImageURL,
      String? errorMessage,
      int? snackBarEventId,
      }) {
    return RegisterUserInformationState(
      userName: userName ?? this.userName,
      userImageURL: userImageURL ?? this.userImageURL,
      errorMessage: errorMessage ?? this.errorMessage,
      snackBarEventId: snackBarEventId ?? this.snackBarEventId
    );
  }
}

enum RegisterUserInformationError {
  emptyUserName,
  userNameTooShort,
  missingImage,
}

extension RegisterUserInformationErrorX on RegisterUserInformationError {
  String get message {
    switch (this) {
      case RegisterUserInformationError.emptyUserName:
        return "User name cant be empty";
      case RegisterUserInformationError.userNameTooShort:
        return 'User name must be at least 3 characters';
      case RegisterUserInformationError.missingImage:
        return 'Please select a profile image';
    }
  }
}
