// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/request_controller.dart';
import 'package:binergy/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'package:binergy/controller/auth.dart';
import 'package:binergy/controller/repo.dart';

class UserState {
  final String user;
  final bool loading;
  final Position? pos;
  final bool dev;
  UserState({
    required this.user,
    required this.loading,
    this.pos,
    required this.dev,
  });

  UserState copyWith({String? user, bool? loading, Position? pos, bool? dev}) {
    return UserState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      pos: pos ?? this.pos,
      dev: dev ?? this.dev,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'loading': loading,
      'pos': pos,
      'dev': dev
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
        user: map['user'] as String,
        loading: map['loading'] as bool,
        pos: map['pos'] != null
            ? Position.fromMap(map['pos'] as Map<String, dynamic>)
            : null,
        dev: map['dev'] as bool);
  }

  @override
  String toString() {
    return 'user: $user\nloading: $loading';
  }
}

final userController =
    StateNotifierProvider<UserProvider, UserState>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserState> {
  UserProvider() : super(UserState(user: 'NULL', loading: false, dev: false));

  Future signIn(BuildContext context, WidgetRef ref) async {
    state = state.copyWith(loading: true);
    final res = await ref.read(googleProvider.notifier).signIn(ref);
    if (res != null && context.mounted) {
      state = state.copyWith(user: res.user!.uid);
      logger.d('routing to /home');
      context.go('/home');
    }
    state = state.copyWith(loading: false);
  }

  Future logout(WidgetRef ref) async {
    if (ref.read(authProivder).currentUser == null) {
      logger.d('Invalid Logout');
      logger.e(state.toString());
      return;
    }
    state = state.copyWith(loading: true);
    final String res = await ref.read(googleProvider.notifier).logout(ref);
    state = state.copyWith(user: res, loading: false);
  }

  Future refresh() async {
    logger.d('Refreshing');
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      state = state.copyWith(loading: false);
    });
  }

  Future currentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.e('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        logger.e('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      logger.e(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    state = state.copyWith(pos: position);
    logger.d('lat/lng : ${position.latitude}/${position.longitude}');
  }

  Future logoutWrapper(BuildContext context, WidgetRef ref) async {
    final bool res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Center(
              child: Text(
                'Confirm Logout?',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        });
    if (res) {
      ref.read(userController.notifier).logout(ref);
    }
  }

  Future getRoute(WidgetRef ref, Map<String, String> map) async {
    logger.d('DEBUG: getRoute called');
    state = state.copyWith(loading: true);
    final data = await ref.read(requestController.notifier).getRoute(map);
    state = state.copyWith(loading: false);
    logger
        .d((data['features'][0]['geometry']['coordinates'][0] as List).length);
    return data;
  }

  void handleBinSelect(
      BuildContext context, WidgetRef ref, bool flag, String id) {
    if (flag) {
      ref.read(dataController.notifier).removeBin(id);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showSnackBar(context, 'Removed Bin: $id');
    } else {
      ref.read(dataController.notifier).addBins(id);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showSnackBar(context, 'Selected Bin: $id');
    }
  }
}
