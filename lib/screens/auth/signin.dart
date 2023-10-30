// ignore_for_file: prefer_const_constructors

import 'package:binergy/screens/auth/utils/button.dart';
import 'package:binergy/screens/auth/utils/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  ConsumerState<Signin> createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  String validate(String? text) {
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Email Address',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            CustomField(
              hintText: 'Ex: abcd@gmail.com',
              controller: emailController,
              validate: validate,
              flag: false,
            ),
            SizedBox(height: 25),
            Text(
              'Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            CustomField(
              hintText: 'Password',
              controller: passwordController,
              validate: validate,
              flag: true,
            ),
            SizedBox(height: 25),
            Text(
              'Re-enter Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            CustomField(
              hintText: 'Re-enter Password',
              controller: rePasswordController,
              validate: validate,
              flag: true,
            ),
            SizedBox(height: 25),
            Button(text: 'Sign In'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
