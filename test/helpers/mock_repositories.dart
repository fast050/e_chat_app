import 'package:e_chat_app/features/chats/domain/repo/attachments_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/chat_settings_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/friends_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/groups_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/messages_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFriendsRepository extends Mock implements FriendsRepository {}

class MockGroupsRepository extends Mock implements GroupsRepository {}

class MockMessagesRepository extends Mock implements MessagesRepository {}

class MockChatSettingsRepository extends Mock
    implements ChatSettingsRepository {}

class MockAttachmentsRepository extends Mock implements AttachmentsRepository {}
