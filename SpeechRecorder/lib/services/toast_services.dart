import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showToast(String text,
    {bool shortToast = true,
      fromBottom = true,
      Color color = const Color(0xff4BB543),
      Color textColor = Colors.white}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: textColor,
      fontSize: 16.0);
}
