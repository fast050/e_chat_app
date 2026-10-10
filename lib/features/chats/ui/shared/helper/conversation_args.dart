/// Route arguments for `Routes.conversation` and the screens opened from it
/// (user info, media, protected chat, add to group): which chat, and what the
/// header shows before anything has loaded.
class ConversationArgs {
  final String chatId;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;

  const ConversationArgs({
    required this.chatId,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
  });
}
