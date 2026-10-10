import 'package:e_chat_app/features/chats/domain/entities/chat_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson reads all fields', () {
    final settings = ChatSettings.fromJson({
      'chat_id': 'c1',
      'is_muted': true,
      'is_protected': true,
      'is_pin_enabled': true,
      'is_face_enabled': true,
      'is_fingerprint_enabled': true,
      'is_hidden': true,
      'is_history_hidden': true,
      'bubble_color': 0xFF1565C0,
      'background_image_path': '/pictures/sky.jpg',
    });

    expect(settings.chatId, 'c1');
    expect(settings.isMuted, isTrue);
    expect(settings.isProtected, isTrue);
    expect(settings.isPinEnabled, isTrue);
    expect(settings.isFaceEnabled, isTrue);
    expect(settings.isFingerprintEnabled, isTrue);
    expect(settings.isHidden, isTrue);
    expect(settings.isHistoryHidden, isTrue);
    expect(settings.bubbleColor, 0xFF1565C0);
    expect(settings.backgroundImagePath, '/pictures/sky.jpg');
  });

  test('fromJson turns everything off when only the chat id is present', () {
    final settings = ChatSettings.fromJson({'chat_id': 'c1'});

    expect(settings.isMuted, isFalse);
    expect(settings.isProtected, isFalse);
    expect(settings.isPinEnabled, isFalse);
    expect(settings.isFaceEnabled, isFalse);
    expect(settings.isFingerprintEnabled, isFalse);
    expect(settings.isHidden, isFalse);
    expect(settings.isHistoryHidden, isFalse);
    expect(settings.bubbleColor, isNull);
    expect(settings.backgroundImagePath, isNull);
  });

  test('toJson leaves out a missing color and background', () {
    const settings = ChatSettings(chatId: 'c1', isMuted: true);

    expect(settings.toJson(), {
      'chat_id': 'c1',
      'is_muted': true,
      'is_protected': false,
      'is_pin_enabled': false,
      'is_face_enabled': false,
      'is_fingerprint_enabled': false,
      'is_hidden': false,
      'is_history_hidden': false,
    });
  });

  test('toJson writes the color and background when set', () {
    const settings = ChatSettings(
      chatId: 'c1',
      bubbleColor: 0xFF1565C0,
      backgroundImagePath: '/pictures/sky.jpg',
    );

    expect(settings.toJson()['bubble_color'], 0xFF1565C0);
    expect(settings.toJson()['background_image_path'], '/pictures/sky.jpg');
  });

  test('copyWith changes only the given fields', () {
    const settings = ChatSettings(
      chatId: 'c1',
      isMuted: true,
      backgroundImagePath: '/pictures/sky.jpg',
    );

    final updated = settings.copyWith(isProtected: true, bubbleColor: 7);

    expect(updated.chatId, 'c1');
    expect(updated.isMuted, isTrue);
    expect(updated.isProtected, isTrue);
    expect(updated.bubbleColor, 7);
    expect(updated.backgroundImagePath, '/pictures/sky.jpg');
  });

  test('copyWith removes the background only with clearBackgroundImage', () {
    const settings = ChatSettings(
      chatId: 'c1',
      backgroundImagePath: '/pictures/sky.jpg',
    );

    expect(
      settings.copyWith(clearBackgroundImage: true).backgroundImagePath,
      isNull,
    );
  });
}
