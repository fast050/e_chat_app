class CountryCode {
  final String name;
  final String code;
  final String flag;
  final String dialCode;

  CountryCode(
      {required this.name,
      required this.code,
      required this.flag,
      required this.dialCode});

   @override
  String toString() {
    return "{name :$name, code:$code, flag:$flag, dialCode:$dialCode }";
  }
      
}
