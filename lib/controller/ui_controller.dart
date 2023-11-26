// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:binergy/controller/repo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:binergy/controller/auth.dart';

class UserState {
  final String user;
  final bool loading;
  UserState({
    required this.user,
    required this.loading,
  });

  UserState copyWith({
    String? user,
    bool? loading,
  }) {
    return UserState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'loading': loading,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      user: map['user'] as String,
      loading: map['loading'] as bool,
    );
  }

  @override
  String toString() {
    return 'user: $user\nloading: $loading';
  }
}

final userController =
    StateNotifierProvider<UserProvider, UserState>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserState> {
  UserProvider() : super(UserState(user: 'NULL', loading: false));

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
}
