// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

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

class AuthState extends StateNotifier<AuthModel> {
  final googleSignIn = GoogleSignIn();
  AuthState() : super(AuthModel(loading: false, state: false));

  Future<bool> signIn(WidgetRef ref) async {
    log('DEBUG : Google Sign In');
    try {
      state = state.copyWith(loading: true);

      GoogleSignInAccount user;

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        log('DEBUG: No user selected');
        state = state.copyWith(loading: false);
        return false;
      }
      user = googleUser;

      final googleAuth = await user.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await ref.read(authProivder).signInWithCredential(cred);

      state = state.copyWith(uid: userCred.user!.uid, state: true);
      log('DEBUG: Success Sign In/Log In');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  Future logout(WidgetRef ref) async {
    try {
      state = state.copyWith(loading: true);

      await googleSignIn.disconnect();
      ref.read(authProivder).signOut();

      state = state.copyWith(uid: null, state: false);
      log('DEBUG: Signed Out');
    } catch (e) {
      log('DEBUG: ${e.toString()}');
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
