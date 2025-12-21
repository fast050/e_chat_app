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
  font16Medium: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: AppFontWeight.medium,
  ),
  font16Bold: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: AppFontWeight.bold,
  ),
  font18Regular: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: AppFontWeight.regular,
  ),
  font18SemiBold: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: AppFontWeight.medium,
  ),
  font20Regular: GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: AppFontWeight.regular,
  ),
  font22Black: GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: AppFontWeight.black,
  ),
  font24Regular: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: AppFontWeight.regular,
  ),
  font26Bold: GoogleFonts.roboto(
    fontSize: 26,
    fontWeight: AppFontWeight.bold,
  ),
  font32Medium: GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: AppFontWeight.medium,
  ),
  font35Bold: GoogleFonts.roboto(
    fontSize: 35,
    fontWeight: AppFontWeight.bold,
  ),
  font40Black: GoogleFonts.roboto(
    fontSize: 40,
    fontWeight: AppFontWeight.black,
  ),
);
