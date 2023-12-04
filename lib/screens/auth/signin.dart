// ignore_for_file: prefer_const_constructors

import 'package:binergy/controller/ui_controller.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  List<GlobalObjectKey<FormState>> keys =
      List.generate(5, (index) => GlobalObjectKey<FormState>(index));

  String? validate(String? text, String type) {
    switch (type) {
      case 'Username':
        return text!.isNotEmpty ? null : 'Username cannot be empty';
      case 'Email':
        final regex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        return regex.hasMatch(text!) ? null : 'Invalid Email';
      case 'Password':
        return text!.isNotEmpty && (text == passwordController.text)
            ? null
            : 'Invalid Password';
      default:
        return 'Invalid Input';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: keys[4],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Username',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            CustomField(
              tkey: keys[0],
              hintText: 'Ex: Titan',
              controller: nameController,
              validate: (text) => validate(text, 'Username'),
              flag: false,
            ),
            SizedBox(height: 25),
            Text(
              'Email Address',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            CustomField(
              tkey: keys[1],
              hintText: 'Ex: abcd@gmail.com',
              controller: emailController,
              validate: (text) => validate(text, 'Email'),
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
              tkey: keys[2],
              hintText: 'Password',
              controller: passwordController,
              validate: (text) => validate(text, 'Password'),
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
              tkey: keys[3],
              hintText: 'Re-enter Password',
              controller: rePasswordController,
              validate: (text) => validate(text, 'Password'),
              flag: true,
            ),
            SizedBox(height: 25),
            Button(
              text: 'Sign-Up',
              callback: () {
                final res = keys[4].currentState!.validate();
                if (res) {
                  final username = nameController.text;
                  final email = emailController.text;
                  final password = rePasswordController.text;
                  ref.read(userController.notifier).signInWithPassword(
                      context, ref, username, email, password);
                }
              },
            ),
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
    rePasswordController.dispose();
    super.dispose();
  }
}
