// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:binergy/controller/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserState {
  final String? user;
  final bool loading;
  final bool state;
  UserState({
    this.user,
    required this.loading,
    required this.state,
  });

  UserState copyWith({
    String? user,
    bool? loading,
    bool? state,
  }) {
    return UserState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'loading': loading,
      'state': state,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      user: map['user'] as String,
      loading: map['loading'] as bool,
      state: map['state'] as bool,
    );
  }
}

final userController =
    StateNotifierProvider<UserProvider, UserState>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserState> {
  UserProvider() : super(UserState(loading: false, state: false));

  Future signIn(BuildContext context, WidgetRef ref) async {
    state = state.copyWith(loading: true);
    final res = await ref.read(googleProvider.notifier).signIn(ref);

    if (res != null && context.mounted) {
      state = state.copyWith(user: res.user!.uid);
      context.go('/home');
    }
    state = state.copyWith(loading: false);
  }

  Future logout(WidgetRef ref) async {
    state = state.copyWith(loading: true);
    final res = await ref.read(googleProvider.notifier).logout(ref);
    state = state.copyWith(user: res, loading: false);
  }
}
