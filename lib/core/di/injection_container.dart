import 'package:e_chat_app/core/local/country_code_local_source/data/local_countries_data_source.dart';
import 'package:e_chat_app/core/local/country_code_local_source/data/repo/countris_code_repository_impl.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';
import 'package:e_chat_app/features/auth/data/auth_repository_impl.dart';
import 'package:e_chat_app/features/auth/domain/repo/auth_repository.dart';
import 'package:e_chat_app/features/auth/widgets/otp_input/logic/otp_input_cubit.dart';
import 'package:e_chat_app/features/auth/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/auth/login/logic/login_otp_step/login_otp_step_cubit.dart';
import 'package:e_chat_app/features/auth/login/logic/login_phone_step/login_phone_step_cubit.dart';
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

  getIt.registerFactory<LoginPhoneStepCubit>(
    () => LoginPhoneStepCubit(),
  );

  getIt.registerFactory<LoginOTPStepCubit>(
    () => LoginOTPStepCubit(),
  );

  //Auth
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuth>()),
  );
  getIt.registerFactory<OTPInputCubit>(
    () => OTPInputCubit(getIt<AuthRepository>()),
  );
}
