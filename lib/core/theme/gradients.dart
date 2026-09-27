import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient lightBlueGradient = LinearGradient(
    colors: [
      Color(0xFF40C4FF),
      Color(0xFF03A9F4),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navActiveGradient = LinearGradient(
    colors: [
      Color(0xFF40C4FF),
      Color(0xFF23B7FA),
      Color(0xFF03A9F4),
    ],
    stops: [0, 0.427, 0.862],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft white sheen on the right edge of the chats header.
  static const LinearGradient headerSheenGradient = LinearGradient(
    colors: [
      Color(0x00FFFFFF),
      Color(0x33FFFFFF),
    ],
    stops: [0.815, 1],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
