import 'package:flutter/material.dart';

import 'colors.dart';

InputDecoration myInputDecoration({Icon? icon, required String label}) {
  return InputDecoration(
      prefixIcon: icon,
      hintText: label,
      label: Text(label),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryDarkColor)));
}
