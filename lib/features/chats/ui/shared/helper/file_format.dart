/// "24 MB", "1.5 GB" — one decimal, dropped when it is zero.
String formatFileSize(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB'];
  var size = bytes.toDouble();
  var unit = 0;
  while (size >= 1024 && unit < units.length - 1) {
    size /= 1024;
    unit++;
  }
  final rounded = size.toStringAsFixed(1);
  final label = rounded.endsWith('.0')
      ? rounded.substring(0, rounded.length - 2)
      : rounded;
  return '$label ${units[unit]}';
}

/// "pdf" for "War and Peace.pdf"; empty when the name has no extension.
String fileExtension(String name) {
  final dot = _extensionDot(name);
  return dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
}

/// "War and Peace" for "War and Peace.pdf".
String fileNameWithoutExtension(String name) {
  final dot = _extensionDot(name);
  return dot == -1 ? name : name.substring(0, dot);
}

// A leading or trailing dot (".env", "notes.") is not an extension.
int _extensionDot(String name) {
  final dot = name.lastIndexOf('.');
  return dot <= 0 || dot == name.length - 1 ? -1 : dot;
}
