class ChatSettings {
  final String chatId;
  final bool isMuted;
  final bool isProtected;
  final bool isPinEnabled;
  final bool isFaceEnabled;
  final bool isFingerprintEnabled;
  final bool isHidden;
  final bool isHistoryHidden;
  // ARGB value of the bubble color; null keeps the theme color.
  final int? bubbleColor;
  final String? backgroundImagePath;

  const ChatSettings({
    required this.chatId,
    this.isMuted = false,
    this.isProtected = false,
    this.isPinEnabled = false,
    this.isFaceEnabled = false,
    this.isFingerprintEnabled = false,
    this.isHidden = false,
    this.isHistoryHidden = false,
    this.bubbleColor,
    this.backgroundImagePath,
  });

  factory ChatSettings.fromJson(Map<String, dynamic> json) => ChatSettings(
        chatId: json['chat_id'] as String,
        isMuted: json['is_muted'] as bool? ?? false,
        isProtected: json['is_protected'] as bool? ?? false,
        isPinEnabled: json['is_pin_enabled'] as bool? ?? false,
        isFaceEnabled: json['is_face_enabled'] as bool? ?? false,
        isFingerprintEnabled: json['is_fingerprint_enabled'] as bool? ?? false,
        isHidden: json['is_hidden'] as bool? ?? false,
        isHistoryHidden: json['is_history_hidden'] as bool? ?? false,
        bubbleColor: json['bubble_color'] as int?,
        backgroundImagePath: json['background_image_path'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'is_muted': isMuted,
        'is_protected': isProtected,
        'is_pin_enabled': isPinEnabled,
        'is_face_enabled': isFaceEnabled,
        'is_fingerprint_enabled': isFingerprintEnabled,
        'is_hidden': isHidden,
        'is_history_hidden': isHistoryHidden,
        if (bubbleColor != null) 'bubble_color': bubbleColor,
        if (backgroundImagePath != null)
          'background_image_path': backgroundImagePath,
      };

  ChatSettings copyWith({
    bool? isMuted,
    bool? isProtected,
    bool? isPinEnabled,
    bool? isFaceEnabled,
    bool? isFingerprintEnabled,
    bool? isHidden,
    bool? isHistoryHidden,
    int? bubbleColor,
    String? backgroundImagePath,
    // A null backgroundImagePath means "keep", so removing needs a flag.
    bool clearBackgroundImage = false,
  }) =>
      ChatSettings(
        chatId: chatId,
        isMuted: isMuted ?? this.isMuted,
        isProtected: isProtected ?? this.isProtected,
        isPinEnabled: isPinEnabled ?? this.isPinEnabled,
        isFaceEnabled: isFaceEnabled ?? this.isFaceEnabled,
        isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
        isHidden: isHidden ?? this.isHidden,
        isHistoryHidden: isHistoryHidden ?? this.isHistoryHidden,
        bubbleColor: bubbleColor ?? this.bubbleColor,
        backgroundImagePath: clearBackgroundImage
            ? null
            : backgroundImagePath ?? this.backgroundImagePath,
      );
}
