// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/screens/home/drawer.dart';
import 'package:binergy/shared/snackbar.dart';
import 'package:binergy/static/project_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final mapController = MapController();
  @override
  Widget build(BuildContext context) {
    final pos = ref.watch(userController.select((value) => value.pos));
    final routes = ref.watch(dataController.select((value) => value.routes));
    return WillPopScope(
      onWillPop: () async {
        await ref.read(userController.notifier).logout(ref);
        if (context.mounted) {
          context.go('/');
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          drawer: CustomDrawer(),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: '1',
                onPressed: () async {
                  showSnackBar(context, 'Fetching Current Location');
                  await ref.read(userController.notifier).currentLocation();
                  if (context.mounted) {
                    showSnackBar(context, 'Updating Location');
                    mapController.move(
                        LatLng(pos!.latitude, pos.longitude), 15);
                  }
                },
                backgroundColor: Colors.greenAccent,
                child: Icon(
                  Icons.gps_fixed_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: '2',
                onPressed: () async {
                  await ref
                      .read(userController.notifier)
                      .logoutWrapper(context, ref);
                  if (context.mounted) {
                    context.go('/');
                  }
                },
                backgroundColor: Colors.greenAccent,
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: '3',
                onPressed: () async {
                  final Map<String, String> map = {
                    'waypoints': '77.5946%2C12.9716%7C75.2071%2C12.7687',
                    'mode': 'drive',
                    'apiKey': ProjectConstants.apiKey
                  };
                  final data = await ref
                      .read(userController.notifier)
                      .getRoute(ref, map);
                  ref.read(dataController.notifier).addRoutes(data);
                },
                backgroundColor: Colors.greenAccent,
                child: Icon(
                  Icons.roundabout_left_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: pos != null
                    ? LatLng(pos.latitude, pos.longitude)
                    : LatLng(12.9716, 77.5946),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pos != null
                          ? LatLng(pos.latitude, pos.longitude)
                          : LatLng(12.9716, 77.5946),
                      width: 80,
                      height: 80,
                      child: Icon(
                        IconData(
                          0xe3ab,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      strokeWidth: 2,
                      points: routes.map((e) {
                        return LatLng(e[1], e[0]);
                      }).toList(),
                      color: Colors.black,
                      borderColor: Colors.greenAccent,
                      borderStrokeWidth: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
