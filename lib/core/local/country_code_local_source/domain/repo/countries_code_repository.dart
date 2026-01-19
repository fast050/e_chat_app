import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';

abstract interface class CountriesCodeRepository {
  Future<List<CountryCode>> getCountriesCodes(); 
  Future<CountryCode?> getCountryByCode({required String code}); 
  Future<CountryCode?> getCountryByDialCode({required String dialCode}); 
} 