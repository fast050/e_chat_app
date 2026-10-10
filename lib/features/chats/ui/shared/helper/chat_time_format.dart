/// "10:25" — the time shown inside a message bubble.
String formatMessageTime(DateTime at) =>
    '${_twoDigits(at.hour)}:${_twoDigits(at.minute)}';

/// "10:25" for today, "22:20  09/05" (two spaces) for any other day.
String formatChatTime(DateTime at, {required DateTime now}) {
  final time = formatMessageTime(at);
  final isToday =
      at.year == now.year && at.month == now.month && at.day == now.day;
  if (isToday) return time;
  return '$time  ${_twoDigits(at.day)}/${_twoDigits(at.month)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
