
import 'package:e_chat_app/features/auth/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<bool> updateName(String name);

  Future<bool> updateProfileImage(String imageURL);

  Future<bool> updateProfile(String name, String imageURL);

  User? get user;
}