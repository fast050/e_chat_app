import 'dart:convert';
import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

class LocalCountriesDataSource {
  List<CountryCodeModel> _cachedList = [];

  LocalCountriesDataSource();

  Future<List<CountryCodeModel>> getCountriesCodes() async {
    if (_cachedList.isNotEmpty) {
      return _cachedList;
    }

    final String response =
        await rootBundle.loadString('assets/countries.json');
    final data = await jsonDecode(response) as List<dynamic>;

    _cachedList = data.map((country) {
      return CountryCodeModel.fromJson(country as Map<String, dynamic>);
    }).toList();

    return _cachedList;
  }

  Future<CountryCodeModel?> getCountryByCode(String code) async {
    final list = await getCountriesCodes();

    try {
      return list.firstWhere(
        (country) => country.code.toLowerCase() == code.toLowerCase(),
      );
    } on StateError {
      return null;
    }
  }

  Future<CountryCodeModel?> getCountryByDialCode(String dialCode) async {
    final list = await getCountriesCodes();

    try {
      return list.firstWhere(
        (country) => country.dialCode.toLowerCase() == dialCode.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}

class CountryCodeModel {
  final String name;
  final String code;
  final String flag;
  @JsonKey(name: "dial_code")
  final String dialCode;

  CountryCodeModel(
      {required this.name,
      required this.code,
      required this.flag,
      required this.dialCode});

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) =>
      CountryCodeModel(
        name: json['name'] as String,
        code: json['code'] as String,
        flag: json['flag'] as String,
        dialCode: json['dial_code'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'flag': flag,
        'dial_code': dialCode,
      };

  CountryCode toCountryCode() {
    return CountryCode(
      name: name,
      code: code,
      flag: flag,
      dialCode: dialCode,
    );
  }

  @override
  String toString(){
    return "[name: $name, code: $code, flag: $flag, dialCode: $dialCode]\n";
  }
}
