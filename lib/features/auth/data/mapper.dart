import 'package:firebase_auth/firebase_auth.dart' as Firebase_User;
import 'package:e_chat_app/features/auth/domain/entities/user.dart';

User fromFirebaseUserToUser(Firebase_User.User fUser) {
  return User(
      id: fUser.uid,
      name: fUser.displayName ?? "",
      imageURL: fUser.photoURL,
      phoneNumber: fUser.phoneNumber,
      email: fUser.email);
}
