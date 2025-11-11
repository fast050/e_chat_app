import 'package:e_chat_app/core/theme/app_text_theme.dart';
import 'package:e_chat_app/core/theme/font_weight.dart';
import 'package:google_fonts/google_fonts.dart';

/*
  medium : w500
  semiBold : w600
  bold : w700
  black : w900
*/
final appTextThemeValue = AppTextTheme(
  font26Bold: GoogleFonts.roboto(
    fontSize: 26,
    fontWeight: AppFontWeight.bold,
  ),
  font22Black: GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: AppFontWeight.black,
  ),
  font18SemiBold: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: AppFontWeight.medium,
  ),
  font18Regular: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: AppFontWeight.regular,
  ),
  font16Medium: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: AppFontWeight.medium,
  ),
  font40Black: GoogleFonts.roboto(
    fontSize: 40,
    fontWeight: AppFontWeight.black,
  ),
);
