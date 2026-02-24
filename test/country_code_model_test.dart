import 'package:flutter_test/flutter_test.dart';
import 'package:e_chat_app/core/local/country_code_local_source/data/local_countries_data_source.dart';

void main() {
  test('CountryCodeModel fromJson and toJson', () {
    final json = {
      'name': 'United Arab Emirates',
      'code': 'AE',
      'flag': '🇦🇪',
      'dial_code': '+971',
    };

    final model = CountryCodeModel.fromJson(json);

    expect(model.name, 'United Arab Emirates');
    expect(model.code, 'AE');
    expect(model.flag, '🇦🇪');
    expect(model.dialCode, '+971');

    expect(model.toJson(), json);
  });

  test('toCountryCode creates CountryCode entity', () {
    final model = CountryCodeModel(
      name: 'UAE',
      code: 'AE',
      flag: '🇦🇪',
      dialCode: '+971',
    );

    final entity = model.toCountryCode();
    expect(entity.name, 'UAE');
    expect(entity.code, 'AE');
    expect(entity.flag, '🇦🇪');
    expect(entity.dialCode, '+971');
  });

  test('toString contains fields', () {
    final model = CountryCodeModel(
      name: 'UAE',
      code: 'AE',
      flag: '🇦🇪',
      dialCode: '+971',
    );

    final s = model.toString();
    expect(s, contains('name: UAE'));
    expect(s, contains('code: AE'));
    expect(s, contains('flag: 🇦🇪'));
    expect(s, contains('dialCode: +971'));
  });
}
