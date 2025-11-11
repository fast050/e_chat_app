import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class ChatBorderWithText extends StatelessWidget {
  const ChatBorderWithText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
   final textTheme = Theme.of(context).extension<AppTextTheme>()!; 

    return Container(
      height: 268,
      width: 268,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/chat_round.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Stay Connected", style: textTheme.font22Black),
            Text("Stay Chatting", style: textTheme.font22Black),
          ]),
    );
  }
}