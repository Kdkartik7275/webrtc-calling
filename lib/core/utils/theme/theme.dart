import 'package:flutter/material.dart';
import 'package:webrtc_chat/core/utils/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      // appBarTheme: TAppBarTheme.lightAppBarTheme,
      // inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,

      // elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      // drawerTheme: const DrawerThemeData(
      //   backgroundColor: AppColors.primary,
      //   elevation: 0,
      // )

      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: AppColors.white));
}
