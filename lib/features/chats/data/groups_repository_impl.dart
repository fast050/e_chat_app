import 'package:e_chat_app/features/chats/domain/repo/groups_repository.dart';

// Accepts every group until the Supabase groups tables exist.
class GroupsRepositoryImpl implements GroupsRepository {
  @override
  Future<void> createGroup({
    required String name,
    required List<String> memberIds,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
