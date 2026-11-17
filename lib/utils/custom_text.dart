import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;

  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 15,
    this.fontWeight,
    this.textStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        textStyle: textStyle,
      ),
    );
  }
}
