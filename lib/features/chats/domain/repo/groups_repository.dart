import 'package:e_chat_app/features/chats/domain/entities/group.dart';

abstract interface class GroupsRepository {
  Future<void> createGroup({
    required String name,
    required List<String> memberIds,
  });
  Future<List<Group>> fetchGroups();
  Future<void> addMember({required String groupId, required String userId});
}
