import 'package:flutter/cupertino.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  final CustomColors colors = CustomColors();
  
  late TextStyle bodyNormal =
      GoogleFonts.lato().copyWith(fontSize: 20, color: colors.blackColor);

  late TextStyle bodySmall =
      GoogleFonts.lato().copyWith(fontSize: 14, color: colors.captionColor);

  late TextStyle titleLarge = GoogleFonts.lato().copyWith(
      fontSize: 30, color: colors.blackColor, fontWeight: FontWeight.bold);
}
