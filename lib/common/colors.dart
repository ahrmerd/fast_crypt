import 'dart:math';

import 'package:flutter/material.dart';

const red = Color(0xffe63946);
const navyBlue = Color(0xff1d3557);
const lightBlue = Color(0xff457b9d);
const cream = Color(0xfff1faee);
const dark = Colors.black;
const light = Colors.white;
const primaryColor = Color(0xFF2196F3);
const primaryDarkColor = Color(0xFF0D47A1);
const primaryLightColor = Color(0xFF90CAF9);

class MyColors {
  static final _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  static Color get getRandom => _colors[Random().nextInt(_colors.length)];
}
