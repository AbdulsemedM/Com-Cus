import 'package:commercepal/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDecorations {
  static InputDecoration getAppInputDecoration({
    IconData? sIconData,
    IconData? pIconData,
    String? hintText,
    String? lableText,
    required bool myBorder,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.greyColor,
      // focusedBorder: InputBorder.none,
      enabledBorder: myBorder
          ? const OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2.0, color: AppColors.colorPrimaryDark))
          : InputBorder.none,
      focusedBorder: myBorder
          ? const OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2.0, color: AppColors.colorPrimaryDark))
          : InputBorder.none,
      hintText: hintText,
      labelText: lableText,
      labelStyle: GoogleFonts.roboto(
          color: AppColors.colorPrimaryDark,
          fontSize: 16,
          fontWeight: FontWeight.w400),
      prefixIconColor: AppColors.iconColor,
      suffixIconColor: AppColors.iconColor,
      prefixIcon: pIconData != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(pIconData),
            )
          : null,
      suffixIcon: sIconData != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(sIconData),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    );
  }
}
