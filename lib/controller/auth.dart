// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:logger/logger.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:binergy/controller/repo.dart';

class AuthModel {
  final String? uid;
  final bool loading;
  final bool state;
  AuthModel({
    this.uid,
    required this.loading,
    required this.state,
  });

  AuthModel copyWith({
    String? uid,
    bool? loading,
    bool? state,
  }) {
    return AuthModel(
      uid: uid ?? this.uid,
      loading: loading ?? this.loading,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'loading': loading,
      'state': state,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      loading: map['loading'] as bool,
      state: map['state'] as bool,
    );
  }
}

final googleProvider =
    StateNotifierProvider<AuthState, AuthModel>((ref) => AuthState());
final logger = Logger();

class AuthState extends StateNotifier<AuthModel> {
  final googleSignIn = GoogleSignIn();
  AuthState() : super(AuthModel(loading: false, state: false));

  Future<List?> signIn(WidgetRef ref) async {
    logger.d('DEBUG : Google Sign In');
    try {
      GoogleSignInAccount user;

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        logger.d('DEBUG: No user selected');

        return null;
      }
      user = googleUser;

      final googleAuth = await user.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await ref.read(authProivder).signInWithCredential(cred);

      //? Update repo
      logger.d('DEBUG : Updating user repo');
      final userRepo = await ref
          .read(repoProvider)
          .collection('Users')
          .doc(userCred.user!.uid)
          .get();
      if (!userRepo.exists) {
        await ref
            .read(repoProvider)
            .collection('Users')
            .doc(userCred.user!.uid)
            .set(
                {'id': userCred.user!.uid, 'name': userCred.user!.displayName});
      }

      logger.d('DEBUG: Success Sign In/logger In');
      return [userCred, userCred.user!.displayName];
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<String> logout(WidgetRef ref) async {
    try {
      try {
        await googleSignIn.disconnect();
      } catch (e) {
        logger.d(e.toString());
      }
      ref.read(authProivder).signOut();

      logger.d('DEBUG: Signed Out');
      return 'NULL';
    } catch (e) {
      logger.e('DEBUG: ${e.toString()}');
      return ref.read(authProivder).currentUser!.uid;
    }
  }

  Future<List?> logInWithPassword(
      WidgetRef ref, String email, String password) async {
    logger.d('DEBUG : Google Sign In With Password');
    try {
      final auth = ref.read(authProivder);

      final userCred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final userRepo = await ref
          .read(repoProvider)
          .collection('Users')
          .doc(userCred.user!.uid)
          .get();
      logger.d('DEBUG: Success Log In With Password');
      return [userCred, userRepo['username']];
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  Future<List?> signInWithPassword(
      WidgetRef ref, String username, String email, String password) async {
    logger.d('DEBUG : Google Sign In With Password');
    try {
      final auth = ref.read(authProivder);

      final userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //? Updating userRepo
      logger.d('DEBUG : Updating user repo');
      final userRepo = await ref
          .read(repoProvider)
          .collection('Users')
          .doc(userCred.user!.uid)
          .get();
      if (!userRepo.exists) {
        await ref
            .read(repoProvider)
            .collection('Users')
            .doc(userCred.user!.uid)
            .set({'username': username, 'id': userCred.user!.uid});
      }

      logger.d('DEBUG: Success Sign In With Password');
      return [userCred, username];
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
