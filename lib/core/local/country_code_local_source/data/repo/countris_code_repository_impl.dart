import 'package:e_chat_app/core/local/country_code_local_source/data/local_countries_data_source.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';

class CountriesCodeRepositoryImpl implements CountriesCodeRepository {
  
  final LocalCountriesDataSource _localCountriesDataSource;

  const CountriesCodeRepositoryImpl(this._localCountriesDataSource);
  
  @override
  Future<List<CountryCode>> getCountriesCodes() async {
    final list = await _localCountriesDataSource.getCountriesCodes();
    return list.map((country) => country.toCountryCode()).toList();
  }

  @override
  Future<CountryCode?> getCountryByCode({required String code}) async {
     final country = await _localCountriesDataSource.getCountryByCode(code);
     return (country != null) ? country.toCountryCode() : null;
  }

  @override
  Future<CountryCode?> getCountryByDialCode({required String dialCode}) async {
    final country = await _localCountriesDataSource.getCountryByDialCode(dialCode);
     return (country != null) ? country.toCountryCode() : null;
  }

}