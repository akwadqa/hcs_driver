import 'package:flutter/material.dart';

extension ConvertToMaterial on Color {
  toMaterialColor() {
    Map<int, Color> values = const {
      50: Color.fromRGBO(136, 14, 79, .1),
      100: Color.fromRGBO(136, 14, 79, .2),
      200: Color.fromRGBO(136, 14, 79, .3),
      300: Color.fromRGBO(136, 14, 79, .4),
      400: Color.fromRGBO(136, 14, 79, .5),
      500: Color.fromRGBO(136, 14, 79, .6),
      600: Color.fromRGBO(136, 14, 79, .7),
      700: Color.fromRGBO(136, 14, 79, .8),
      800: Color.fromRGBO(136, 14, 79, .9),
      900: Color.fromRGBO(136, 14, 79, 1),
    };
    return MaterialColor(toARGB32() , values); //toARGB32() was value
  }
}

extension AssetsPath on String {
  
  String get imageAssetPath => 'assets/images/$this';
 
}

extension BoolConditions on bool? {
  bool get isNullOrFalse => this == null || this == false;
}
