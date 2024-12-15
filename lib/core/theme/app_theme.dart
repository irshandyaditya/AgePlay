import 'package:age_play/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.greyColor]) => OutlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 1,
    ),
    
    borderRadius: BorderRadius.circular(12),
  );

  static final ourTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.lightBackgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.darkBorderColor),
      errorBorder: _border(AppPallete.errorColor),
      floatingLabelStyle: TextStyle(
        color: AppPallete.darkBorderColor, // Warna label teks saat fokus
        fontWeight: FontWeight.bold,
      ),
      labelStyle: TextStyle(
        color: AppPallete.greyColor, // Warna label teks saat tidak fokus
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppPallete.errorColor, // Warna kursor
      selectionHandleColor: AppPallete.errorColor, // Warna pegangan seleksi
    ),
  );
}