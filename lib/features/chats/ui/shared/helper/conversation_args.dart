/// Route arguments for `Routes.conversation`: what the header shows before any
/// message has loaded.
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
