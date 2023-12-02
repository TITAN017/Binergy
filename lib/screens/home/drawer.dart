// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:binergy/controller/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerWidget {
  final String name;
  const CustomDrawer({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.black,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Welcome To Binergy!,\n\n$name',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            splashColor: Colors.greenAccent,
            enableFeedback: true,
            enabled: true,
            title: Text(
              'Hello',
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: IconButton(
              onPressed: () async {
                ref.read(userController.notifier).logoutWrapper(context, ref);
              },
              color: Colors.grey[850],
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.greenAccent,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
