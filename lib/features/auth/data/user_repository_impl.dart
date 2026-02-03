import 'package:e_chat_app/features/auth/data/mapper.dart';
import 'package:e_chat_app/features/auth/domain/entities/user.dart';
import 'package:e_chat_app/features/auth/domain/repo/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_Auth;

class UserRepositoryImpl implements UserRepository {
  final firebase_Auth.FirebaseAuth _auth;

  const UserRepositoryImpl(this._auth);

  @override
  Future<bool> updateName(String name) async {
    if (_auth.currentUser == null) {
      return false;
    }

    try {
      await _auth.currentUser!.updateDisplayName(name);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProfile(String name, String imageURL) async {
    if (_auth.currentUser == null) {
      return false;
    }

    try {
      await _auth.currentUser!
          .updateProfile(displayName: name, photoURL: imageURL);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProfileImage(String imageURL) async {
    if (_auth.currentUser == null) {
      return false;
    }

    try {
      await _auth.currentUser!.updatePhotoURL(imageURL);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  User? get user {
      
     final fUser = _auth.currentUser; 

     if(fUser == null) {
       return null;
     }

     return fromFirebaseUserToUser(fUser);    
  } 
}
