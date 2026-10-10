import 'package:e_chat_app/core/helper/ui_error.dart';
import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/domain/repo/chat_settings_repository.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatSettingsCubit extends Cubit<ChatSettingsState> {
  final ChatSettingsRepository _repository;

  ChatSettingsCubit(this._repository)
      : super(const ChatSettingsState.initialState());

  // Screens call this again after a pushed screen may have changed the
  // settings, so it never goes back to loading and keeps what is shown if the
  // refresh fails.
  Future<void> load(String chatId) async {
    try {
      final settings = await _repository.fetchSettings(chatId);
      if (isClosed) return;
      emit(state.copyWith(
        status: ChatSettingsStatus.success,
        settings: settings,
      ));
    } on AuthException catch (e) {
      _emitLoadError(e.message);
    } on PostgrestException catch (e) {
      _emitLoadError(e.message);
    } catch (_) {
      _emitLoadError(_genericMessage);
    }
  }

  Future<void> update(ChatSettings settings) async {
    if (state.status != ChatSettingsStatus.success) return;

    final previous = state.settings;
    // Shown right away so switches don't lag behind the tap.
    emit(state.copyWith(settings: settings));
    try {
      await _repository.saveSettings(settings);
    } on AuthException catch (e) {
      _revert(previous, e.message);
    } on PostgrestException catch (e) {
      _revert(previous, e.message);
    } catch (_) {
      _revert(previous, _genericMessage);
    }
  }

  static const _genericMessage = 'Something went wrong. Please try again.';

  void _emitLoadError(String message) {
    if (isClosed) return;
    emit(state.copyWith(
      status: state.status == ChatSettingsStatus.loading
          ? ChatSettingsStatus.failure
          : null,
      error: UiError(message),
    ));
  }

  void _revert(ChatSettings previous, String message) {
    if (isClosed) return;
    emit(state.copyWith(settings: previous, error: UiError(message)));
  }
}
