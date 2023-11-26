// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:binergy/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TextButton(
          onPressed: () {
            ref.read(googleProvider.notifier).logout(ref);
          },
          child: Text(
            'HomePage',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
