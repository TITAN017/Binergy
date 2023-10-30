// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) validate;
  final bool flag;
  final String hintText;
  const CustomField(
      {super.key,
      required this.controller,
      required this.validate,
      required this.flag,
      required this.hintText});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  late bool state;
  @override
  void initState() {
    super.initState();
    state = widget.flag;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: state,
      controller: widget.controller,
      validator: widget.validate,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: widget.flag
            ? IconButton(
                icon: Icon(state ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    state = !state;
                  });
                },
              )
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[850]),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
