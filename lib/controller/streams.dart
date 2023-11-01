import 'package:binergy/controller/repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStreamProvider =
    StreamProvider((ref) => ref.read(authProivder).authStateChanges());
