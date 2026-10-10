import 'package:e_chat_app/core/di/injection_container.dart';
import 'package:e_chat_app/core/routing/routes.dart';
import 'package:e_chat_app/features/auth/register/logic/register_user_information_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_email_step/auth_email_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_method/auth_method_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_phone_step/auth_phone_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/auth/ui/logic/auth_flow_cubit.dart';
import 'package:e_chat_app/features/auth/ui/auth_screen.dart';
import 'package:e_chat_app/features/chats/ui/add_friend/add_friend_screen.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/chats_screen.dart';
import 'package:e_chat_app/features/chats/ui/create_group/create_group_screen.dart';
import 'package:e_chat_app/features/chats/ui/add_friend/logic/add_friend_cubit.dart';
import 'package:e_chat_app/features/chats/ui/chats_list/logic/chats_cubit.dart';
import 'package:e_chat_app/features/chats/ui/create_group/logic/create_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/conversation/conversation_screen.dart';
import 'package:e_chat_app/features/chats/ui/conversation/logic/conversation_cubit.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/add_to_group_screen.dart';
import 'package:e_chat_app/features/chats/ui/add_to_group/logic/add_to_group_cubit.dart';
import 'package:e_chat_app/features/chats/ui/chat_media/chat_media_screen.dart';
import 'package:e_chat_app/features/chats/ui/protected_chat/protected_chat_screen.dart';
import 'package:e_chat_app/features/chats/ui/shared/helper/conversation_args.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_media_cubit.dart';
import 'package:e_chat_app/features/chats/ui/shared/logic/chat_settings_cubit.dart';
import 'package:e_chat_app/features/chats/ui/user_info/user_info_screen.dart';
import 'package:e_chat_app/features/onbording/ui/logic/onboarding_cubit.dart';
import 'package:e_chat_app/features/onbording/ui/onbording_screen.dart';
import 'package:e_chat_app/features/splash/logic/splash_done_cubit.dart';
import 'package:e_chat_app/features/splash/ui/splash_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashDone:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (context) => getIt<SplashDoneCubit>(),
              child: const SplashDoneScreen()),
        );
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<OnboardingCubit>(),
            child: const OnBoardingScreen(),
          ),
        );
      case Routes.auth:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<AuthFlowCubit>()),
              BlocProvider(create: (_) => getIt<CountryCodeCubit>()),
              BlocProvider(create: (_) => getIt<AuthPhoneStepCubit>()),
              BlocProvider(create: (_) => getIt<AuthMethodCubit>()),
              BlocProvider(create: (_) => getIt<AuthOTPStepCubit>()),
              BlocProvider(create: (_) => getIt<OTPInputCubit>()),
              BlocProvider(create: (_) => getIt<AuthEmailCubit>()),
              BlocProvider(
                create: (_) => getIt<RegisterUserInformationCubit>(),
              ),
            ],
            child: const AuthScreen(),
          ),
        );
      case Routes.chats:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChatsCubit>()..loadChats(),
            child: const ChatsScreen(),
          ),
        );
      case Routes.addFriend:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<AddFriendCubit>()),
              BlocProvider(create: (_) => getIt<CountryCodeCubit>()),
            ],
            child: const AddFriendScreen(),
          ),
        );
      case Routes.createGroup:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<CreateGroupCubit>()..loadFriends(),
            child: const CreateGroupScreen(),
          ),
        );
      case Routes.conversation:
        final args = settings.arguments as ConversationArgs;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<ConversationCubit>()..loadMessages(args.chatId),
              ),
              BlocProvider(
                create: (_) => getIt<ChatSettingsCubit>()..load(args.chatId),
              ),
            ],
            child: ConversationScreen(args: args),
          ),
        );
      case Routes.userInfo:
        final args = settings.arguments as ConversationArgs;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<ChatSettingsCubit>()..load(args.chatId),
              ),
              BlocProvider(
                create: (_) => getIt<ChatMediaCubit>()..load(args.chatId),
              ),
            ],
            child: UserInfoScreen(args: args),
          ),
        );
      case Routes.protectedChat:
        final args = settings.arguments as ConversationArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChatSettingsCubit>()..load(args.chatId),
            child: ProtectedChatScreen(args: args),
          ),
        );
      case Routes.chatMedia:
        final args = settings.arguments as ConversationArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ChatMediaCubit>()..load(args.chatId),
            child: ChatMediaScreen(args: args),
          ),
        );
      case Routes.addToGroup:
        final args = settings.arguments as ConversationArgs;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            // The sample chat ids double as the other user's id.
            create: (_) => getIt<AddToGroupCubit>()..loadGroups(args.chatId),
            child: AddToGroupScreen(args: args),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
