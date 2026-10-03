import 'package:e_chat_app/features/chats/domain/repo/friends_repository.dart';
import 'package:e_chat_app/features/chats/domain/repo/groups_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFriendsRepository extends Mock implements FriendsRepository {}

class MockGroupsRepository extends Mock implements GroupsRepository {}
