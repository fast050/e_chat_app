import 'package:e_chat_app/core/local/country_code_local_source/data/local_countries_data_source.dart';
import 'package:e_chat_app/core/local/country_code_local_source/data/repo/countris_code_repository_impl.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';
import 'package:e_chat_app/features/auth/data/auth_repository_impl.dart';
import 'package:e_chat_app/features/auth/data/user_repository_impl.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/auth/domain/repo/user_repository.dart';
import 'package:e_chat_app/features/auth/register/logic/register_user_information_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_otp_step/auth_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/shared/logic/auth_phone_step/auth_phone_step_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupAppInstances() async {
  getIt.registerLazySingleton<LocalCountriesDataSource>(
      () => LocalCountriesDataSource());

  getIt.registerLazySingleton<CountriesCodeRepository>(
      () => CountriesCodeRepositoryImpl(getIt<LocalCountriesDataSource>()));

  getIt.registerFactory<CountryCodeCubit>(
    () => CountryCodeCubit(getIt<CountriesCodeRepository>()),
  );

  getIt.registerFactory<AuthPhoneStepCubit>(
    () => AuthPhoneStepCubit(),
  );

  getIt.registerFactory<AuthOTPStepCubit>(
    () => AuthOTPStepCubit(),
  );

  //Auth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuth>()),
  );

  getIt.registerFactory<OTPInputCubit>(
    () => OTPInputCubit(getIt<AuthRepository>()),
  );

  //User
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<FirebaseAuth>()),
  );

  getIt.registerFactory<RegisterUserInformationCubit>(
    () => RegisterUserInformationCubit(getIt<UserRepository>()),
  );
}
