import 'package:flutter/foundation.dart';

/// Debug-only request/response logging for backend calls (Supabase, etc).
/// Never pass raw phone numbers, emails, OTP codes, or tokens — mask them
/// first with [maskEmail]/[maskPhone], or omit them entirely.
void logApiCall(
  String method, {
  Map<String, Object?>? request,
  Object? response,
  Object? error,
}) {
  if (!kDebugMode) return;

  final buffer = StringBuffer('[api] $method');
  if (request != null) buffer.write(' request=$request');
  if (error != null) {
    buffer.write(' FAILED error=$error');
  } else if (response != null) {
    buffer.write(' response=$response');
  }
  debugPrint(buffer.toString());
}

/// "khalid@example.com" -> "k***@example.com"
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 1) return '*' * email.length;
  return '${email[0]}***${email.substring(at)}';
}

/// "+971509433350" -> "*********3350"
String maskPhone(String phone) {
  if (phone.length <= 4) return '*' * phone.length;
  final visible = phone.substring(phone.length - 4);
  return '${'*' * (phone.length - 4)}$visible';
}
