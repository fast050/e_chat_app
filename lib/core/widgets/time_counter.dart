import 'dart:async';

import 'package:flutter/widgets.dart';

class TimeCounter extends StatefulWidget {
  final Duration duration;
  final TextStyle style;
  final void Function() onCountFinish;

  const TimeCounter({
    super.key,
    required this.duration,
    required this.style,
    required this.onCountFinish,
  });

  @override
  State<TimeCounter> createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  late ValueNotifier<Duration> durationNotifier;

  Timer? timer;

  int get currentTimeInSeconds => durationNotifier.value.inSeconds;

  bool isTimerFinish(int second) => second <= 0;

  void startTime() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => decreaseTimer(),
    );
  }

  @override
  void initState() {
    super.initState();
    durationNotifier = ValueNotifier<Duration>(widget.duration);
    startTime();
  }

  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  void subtractOneSecond() {
    durationNotifier.value = Duration(seconds: currentTimeInSeconds - 1);
  }

  void decreaseTimer() {
    final seconds = currentTimeInSeconds;

    if (isTimerFinish(seconds)) {
      timer?.cancel();
      widget.onCountFinish();
      return;
    }

    subtractOneSecond();
  }

  String formatTime(Duration duration) {
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, "0");
    return "$min : $sec";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: durationNotifier,
      builder: (_, duration, __) {
        return Text(
          formatTime(duration),
          style: widget.style,
        );
      },
    );
  }
}
