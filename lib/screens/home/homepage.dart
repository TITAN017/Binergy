// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/database_controller.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/models/bin_model.dart';
import 'package:binergy/screens/home/drawer.dart';
import 'package:binergy/screens/home/utils/floating_icon.dart';
import 'package:binergy/shared/dummy.dart';
import 'package:binergy/shared/snackbar.dart';
import 'package:binergy/static/project_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late AnimatedMapController mapController;
  @override
  void initState() {
    mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  Map<String, dynamic> dummyBin = {
    'id': '1',
    'pos': [12.902502, 77.591832],
    'state': 90,
    'location': 'JP Nagar 5th Phase'
  };
  @override
  Widget build(BuildContext context) {
    final pos = ref.watch(userController.select((value) => value.pos));
    final routes = ref.watch(dataController.select((value) => value.routes));
    final bins = ref.watch(binProivder);
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

                    mapController.animateTo(
                        dest: LatLng(ref.read(userController).pos!.latitude,
                            ref.read(userController).pos!.longitude),
                        zoom: 15);
                  }
                },
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.gps_fixed_outlined,
                  color: Colors.greenAccent,
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
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.greenAccent,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: '3',
                onPressed: () async {
                  await ref.read(userController.notifier).getRoute(ref);

                  //ref.read(dbController.notifier).addBin(Dummy.dummyBin);
                },
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.roundabout_left_outlined,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          body: FlutterMap(
            mapController: mapController.mapController,
            options: MapOptions(
              initialCenter: LatLng(12.9716, 77.5946),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                subdomains: const ['a', 'b', 'c'],
              ),
              CurrentLocationLayer(
                followOnLocationUpdate: FollowOnLocationUpdate.never,
                turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                style: LocationMarkerStyle(
                  marker: const DefaultLocationMarker(
                    child: FittedBox(
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  markerSize: const Size(20, 20),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  ...bins.when(data: (data) {
                    return data
                        .map(
                          (e) => Marker(
                            point: e.pos,
                            width: 150,
                            height: 300,
                            child: LocationCard(bin: e),
                          ),
                        )
                        .toList();
                  }, error: (_, __) {
                    ProjectConstants.logger.e(_);
                    ProjectConstants.logger.e(__);
                    return [];
                  }, loading: () {
                    ProjectConstants.logger.d('Bins : Loading');
                    return [];
                  }),
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
    );
  }
}
