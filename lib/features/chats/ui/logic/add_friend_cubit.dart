import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/repo/friends_repository.dart';
import 'package:e_chat_app/features/chats/ui/logic/add_friend_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFriendCubit extends Cubit<AddFriendState> {
  final FriendsRepository _repository;

  AddFriendCubit(this._repository) : super(const AddFriendState.initialState());

  Future<void> search({
    required String dialCode,
    required String number,
  }) async {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      emit(state.copyWith(
        status: AddFriendStatus.initial,
        dialCode: dialCode,
        number: '',
        results: const [],
      ));
      return;
    }

    emit(state.copyWith(
      status: AddFriendStatus.loading,
      dialCode: dialCode,
      number: digits,
    ));
    try {
      final results = await _repository.searchByPhone('$dialCode$digits');
      // A newer keystroke replaced this query while it was in flight.
      if (_isStale(dialCode, digits)) return;
      emit(state.copyWith(status: AddFriendStatus.success, results: results));
    } on AuthException catch (e) {
      _emitSearchFailure(dialCode, digits, e.message);
    } on PostgrestException catch (e) {
      _emitSearchFailure(dialCode, digits, e.message);
    } catch (_) {
      _emitSearchFailure(dialCode, digits, _genericMessage);
    }
  }

  Future<void> addFriend(String userId) async {
    try {
      await _repository.addFriend(userId);
      if (isClosed) return;
      emit(state.copyWith(addedIds: {...state.addedIds, userId}));
    } on AuthException catch (e) {
      _emitError(e.message);
    } on PostgrestException catch (e) {
      _emitError(e.message);
    } catch (_) {
      _emitError(_genericMessage);
    }
  }

  static const _genericMessage = 'Something went wrong. Please try again.';

  bool _isStale(String dialCode, String digits) =>
      isClosed || state.dialCode != dialCode || state.number != digits;

  void _emitSearchFailure(String dialCode, String digits, String message) {
    if (_isStale(dialCode, digits)) return;
    emit(state.copyWith(
      status: AddFriendStatus.failure,
      results: const [],
      error: UiError(message),
    ));
  }

  void _emitError(String message) {
    if (isClosed) return;
    emit(state.copyWith(error: UiError(message)));
  }
}
