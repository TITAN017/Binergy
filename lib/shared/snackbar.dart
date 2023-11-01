// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.greenAccent,
    ),
  );
}
