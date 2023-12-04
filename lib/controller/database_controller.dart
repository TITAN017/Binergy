// ignore_for_file: body_might_complete_normally_nullable

import 'package:binergy/controller/auth.dart';
import 'package:binergy/controller/repo.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/models/bin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final dbController = StateNotifierProvider<DatabaseProvider, bool>(
    (ref) => DatabaseProvider(repo: ref.watch(repoProvider)));

class DatabaseProvider extends StateNotifier<bool> {
  final FirebaseFirestore repo;
  final Logger logger = Logger();
  DatabaseProvider({required this.repo}) : super(false);

  Future addUser(Map<String, dynamic> map) async {
    try {
      state = true;
      final res = await repo.collection('Users').doc(map['id'] as String).get();
      if (res.exists) {
        return;
      } else {
        repo.collection('Users').doc(map['id'] as String).set(map);
      }
    } catch (e) {
      logger.e(e.toString());
    } finally {
      state = false;
    }
  }

  Future addBin(Map<String, dynamic> map) async {
    try {
      logger.d('adding bin');
      state = true;
      final res = await repo.collection('Bins').add(map);
      repo.collection('Bins').doc(res.id).update({'id': res.id});
      logger.d('added bin done');
    } catch (e) {
      logger.e(e);
    } finally {
      state = false;
    }
  }
}

final userProivder = StreamProvider<Map<String, dynamic>>(
  (ref) {
    final user = ref.watch(userController.select((value) => value.user));
    final repo = ref.watch(repoProvider);
    if (user == 'NULL') {
      return Stream.value({});
    } else {
      return repo
          .collection('Users')
          .doc('user')
          .snapshots()
          .map((event) => event.data()!);
    }
  },
);

final binProivder = StreamProvider<List<Bin>>((ref) {
  final repo = ref.watch(repoProvider);
  logger.d('initializing stream...');
  return repo.collection('Bins').snapshots().map((event) {
    final qdocs = event.docs;
    final bins = qdocs.map((e) => Bin.fromMap(e.data())).toList();
    logger.d('Bin Provider updated');
    return bins;
  });
});
