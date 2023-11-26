// ignore_for_file: prefer_const_constructors

import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/screens/auth/login.dart';
import 'package:binergy/screens/auth/signin.dart';
import 'package:binergy/screens/auth/utils/material_button.dart';
import 'package:binergy/screens/auth/utils/rep_animation.dart';
import 'package:binergy/shared/or_divider.dart';
import 'package:binergy/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  bool flag = true;

  void toggle() {
    flag = !flag;
    showSnackBar(
        context, flag ? 'Switched to Log in!' : 'Switched to Sign in!');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: ref.watch(userController
                .select((value) => value.loading || value.user != 'NULL'))
            ? null
            : AppBar(
                elevation: 10,
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      await ref.read(userController.notifier).logout(ref);
                    },
                    icon: Icon(Icons.info_outline),
                    color: Colors.greenAccent,
                  ),
                ],
                title: Text(
                  flag ? 'Log in' : 'Sign in',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.black,
              ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: ref.watch(userController
                  .select((value) => value.loading || value.user != 'NULL'))
              ? Center(
                  child: CircularProgressIndicator(color: Colors.greenAccent),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      RepAnimation(name: './lib/assets/1.json'),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 750),
                        child: flag ? const Login() : const Signin(),
                      ),
                      SizedBox(height: 10),
                      Text(
                        flag
                            ? 'Don\'t have an account?'
                            : 'Already have an account?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: toggle,
                        child: Text(
                          flag ? 'Sign In' : 'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      OrDivider(),
                      SizedBox(height: 15),
                      //? Google button
                      CustomMaterialButton(
                        onTap: () async {
                          await ref
                              .read(userController.notifier)
                              .signIn(context, ref);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Image.asset(
                            './lib/assets/google.png',
                            height: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
