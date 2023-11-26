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

  Future<UserCredential?> signIn(WidgetRef ref) async {
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

      logger.d('DEBUG: Success Sign In/logger In');
      return userCred;
    } catch (e) {
      logger.d(e.toString());
      return null;
    }
  }

  Future<String> logout(WidgetRef ref) async {
    try {
      await googleSignIn.disconnect();
      ref.read(authProivder).signOut();

      logger.d('DEBUG: Signed Out');
      return 'NULL';
    } catch (e) {
      logger.d('DEBUG: ${e.toString()}');
      return ref.read(authProivder).currentUser!.uid;
    }
  }
}
