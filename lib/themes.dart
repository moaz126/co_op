import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui';

import 'package:co_op/constants/constants.dart';
import 'package:sizer/sizer.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(

      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),
      indicatorColor:
          isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      buttonColor:
          isDarkTheme ? const Color(0xff3B3B3B) : const Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.white : Colors.black,
      highlightColor:
          isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 15,
          color: isDarkTheme ? Colors.white : const Color(0xFF272F4B),
        ),
        backgroundColor: isDarkTheme ? primaryColor : Colors.grey[50],
        foregroundColor: isDarkTheme ? Colors.white : const Color(0xFF272F4B),
        elevation: 0.0,
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.bebasNeue(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          letterSpacing: -1.5,
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        headline2: GoogleFonts.bebasNeue(
          fontSize: 34,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        headline3: GoogleFonts.bebasNeue(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: isDarkTheme ? Colors.white : Colors.black),
        headline4: GoogleFonts.openSans(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headline5:
            GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.openSans(
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.openSans(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.openSans(
            fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText1: GoogleFonts.manrope(

            fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        button: GoogleFonts.manrope(
            fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.25),
        caption: GoogleFonts.manrope(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.manrope(
            fontSize: 8, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );
  }
}
