// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:binergy/controller/auth.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        await ref.read(userController.notifier).logout(ref);
        if (context.mounted) {
          context.go('/');
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: TextButton(
            onPressed: () {
              ref.read(googleProvider.notifier).logout(ref);
            },
            child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(51.5, 51.5),
                  initialZoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
