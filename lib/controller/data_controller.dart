// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppData {
  final List routes;
  AppData({
    required this.routes,
  });

  AppData copyWith({
    List? routes,
  }) {
    return AppData(
      routes: routes ?? this.routes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'routes': routes,
    };
  }

  factory AppData.fromMap(Map<String, dynamic> map) {
    return AppData(
      routes: List.from(
        (map['routes'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppData.fromJson(String source) =>
      AppData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppData(routes: $routes)';

  @override
  bool operator ==(covariant AppData other) {
    if (identical(this, other)) return true;

    return listEquals(other.routes, routes);
  }

  @override
  int get hashCode => routes.hashCode;
}

final dataController =
    StateNotifierProvider<DataProvider, AppData>((ref) => DataProvider());

class DataProvider extends StateNotifier<AppData> {
  DataProvider() : super(AppData(routes: []));

  void addRoutes(Map<String, dynamic> data) {
    state = state.copyWith(
        routes: data['features'][0]['geometry']['coordinates'][0]);
  }
}
