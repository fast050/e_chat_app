import 'package:e_chat_app/features/auth/domain/entities/user.dart';
import 'package:e_chat_app/features/auth/domain/repo/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // Firebase removed: basic stub implementation
  const UserRepositoryImpl();

  @override
  Future<bool> updateName(String name) async => false;

  @override
  Future<bool> updateProfile(String name, String imageURL) async => false;

  @override
  Future<bool> updateProfileImage(String imageURL) async => false;

  @override
  User? get user => null;
}
