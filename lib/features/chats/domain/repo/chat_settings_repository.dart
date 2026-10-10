import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';

abstract interface class ChatSettingsRepository {
  /// Default settings when nothing was saved for [chatId] yet.
  Future<ChatSettings> fetchSettings(String chatId);
  Future<void> saveSettings(ChatSettings settings);
}
