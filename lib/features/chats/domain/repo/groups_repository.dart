abstract interface class GroupsRepository {
  Future<void> createGroup({
    required String name,
    required List<String> memberIds,
  });
}
