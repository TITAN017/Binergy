import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProivder = Provider((ref) => FirebaseAuth.instance);

final repoProvider = Provider((ref) => FirebaseFirestore.instance);
