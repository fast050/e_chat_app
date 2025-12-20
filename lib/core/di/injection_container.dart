import 'package:e_chat_app/core/local/country_code_local_source/data/local_countries_data_source.dart';
import 'package:e_chat_app/core/local/country_code_local_source/data/repo/countris_code_repository_impl.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';
import 'package:e_chat_app/features/login/logic/country_code/country_code_cubit.dart';
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
}
