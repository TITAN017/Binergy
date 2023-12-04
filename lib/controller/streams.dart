import 'package:binergy/controller/repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(authProivder).authStateChanges().map((event) {
    if (event == null) {
      return {};
    } else {
      return {'name': event.displayName, 'id': event.uid};
    }
  });
});
