import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:e_chat_app/features/chats/domain/repo/chat_settings_repository.dart';

// In-memory until the Supabase chat settings table exists.
class ChatSettingsRepositoryImpl implements ChatSettingsRepository {
  final _settingsByChat = <String, ChatSettings>{};

  @override
  Future<ChatSettings> fetchSettings(String chatId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _settingsByChat[chatId] ?? ChatSettings(chatId: chatId);
  }

  @override
  Future<void> saveSettings(ChatSettings settings) async {
    _settingsByChat[settings.chatId] = settings;
  }
}
