import 'package:e_chat_app/core/theme/colors.dart';
import 'package:e_chat_app/core/theme/gradients.dart';
import 'package:e_chat_app/features/login/ui/widget/login_animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackBackgroundWithShapeLogin extends StatefulWidget {
  final Widget child;
  final bool shouldAnimate;

  const StackBackgroundWithShapeLogin(
      {super.key, required this.child, required this.shouldAnimate});

  @override
  State<StackBackgroundWithShapeLogin> createState() =>
      _StackBackgroundWithShapeLoginState();
}

class _StackBackgroundWithShapeLoginState
    extends State<StackBackgroundWithShapeLogin> with WidgetsBindingObserver {
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial value after first layout frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateKeyboardState();
    });
  }

  @override
  void didChangeMetrics() {
    // Called when keyboard opens/closes (window insets change)
    _updateKeyboardState();
  }

  void _updateKeyboardState() {
    if (!mounted) return;

    final view = View.of(context);

    // physical pixels -> logical pixels
    final bottomInset = view.viewInsets.bottom / view.devicePixelRatio;
    final newValue = bottomInset > 0;
    if (newValue != _isKeyboardOpen) {
      setState(() {
        _isKeyboardOpen = newValue;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shapeHeight = size.height * .46 + MediaQuery.of(context).padding.top;

    //handle background color for both Theme Mode, Light, Dark
    final mode = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = mode == Brightness.dark;

    return Stack(
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(
            begin: 0.0,
            end: widget.shouldAnimate ? (_isKeyboardOpen ? 1.0 : 0.0) : 0.0,
          ),
          duration: Duration(milliseconds: 300),
          curve: Curves.bounceOut,
          builder: (context, value, _) {
            return CustomPaint(
              painter: LoginBackgroundAnimate(
                topShapeGradient:
                    !isDarkMode ? AppGradients.lightBlueGradient : null,
                topShapeColor: isDarkMode ? AppColors.blue900 : null,
                bottomShapeColor: Theme.of(context).colorScheme.secondary,
                offsetBetweenTopBottom: 70.h,
                animatedValue: value,
              ),
              child: SizedBox(
                height: shapeHeight,
                width: double.infinity,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}
