// ignore_for_file: prefer_const_constructors

import 'package:binergy/screens/auth/utils/button.dart';
import 'package:binergy/screens/auth/utils/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            Button(text: 'Login'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
