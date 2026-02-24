import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthStatusCubit extends Cubit<AuthStatus> {
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _sub;

  AuthStatusCubit(this._auth) : super(AuthStatus.unknown) {
    _init();
  }

  void _init() {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthStatus.authenticated);
    } else {
      emit(AuthStatus.unauthenticated);
    }

    // Keep state in sync with auth changes
    _sub = _auth.authStateChanges().listen((u) {
      if (u != null) {
        emit(AuthStatus.authenticated);
      } else {
        emit(AuthStatus.unauthenticated);
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
