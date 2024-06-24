import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appStyle(double? size, Color? color, FontWeight? fontWeight) {
  return GoogleFonts.roboto(
    color: color ?? Colors.black,
    fontSize: size ?? 16.0,
    fontWeight: fontWeight ?? FontWeight.normal,
  );
}
