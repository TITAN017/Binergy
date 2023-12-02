// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:binergy/models/bin_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class AppData {
  final List allRoutes;
  final List route;
  final List routeLocs;
  final LatLng tapPos;
  AppData(
      {required this.route,
      required this.routeLocs,
      required this.tapPos,
      required this.allRoutes});

  AppData copyWith(
      {List? route, List? routeLocs, LatLng? tapPos, List? allRoutes}) {
    return AppData(
        allRoutes: allRoutes ?? this.allRoutes,
        route: route ?? this.route,
        routeLocs: routeLocs ?? this.routeLocs,
        tapPos: tapPos ?? this.tapPos);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allRoutes': allRoutes,
      'route': route,
      'routeLocs': routeLocs,
      'tapPos': tapPos
    };
  }

  factory AppData.fromMap(Map<String, dynamic> map) {
    return AppData(
        allRoutes: List.from(
          (map['allRoutes'] as List),
        ),
        route: List.from(
          (map['route'] as List),
        ),
        routeLocs: List.from(
          (map['routeLocs'] as List),
        ),
        tapPos: LatLng(map['tapPos'][0], map['tapPos'][1]));
  }
}

final dataController =
    StateNotifierProvider<DataProvider, AppData>((ref) => DataProvider());

class DataProvider extends StateNotifier<AppData> {
  DataProvider()
      : super(
          AppData(
              route: [], routeLocs: [], tapPos: LatLng(0, 0), allRoutes: []),
        );

  final logger = Logger();

  void addRoutes(List<Map<String, dynamic>> data) {
    logger.e(data);
    state = state.copyWith(
        allRoutes: data
            .map((e) => [
                  e['features'][0]['geometry']['coordinates'][0],
                  e['features'][0]['properties']['time']
                ])
            .toList());
    state = state.copyWith(route: state.allRoutes[0][0]);
  }

  void updateRoute(int index) {
    logger.e(index);

    state = state.copyWith(route: state.allRoutes[index][0]);
  }

  void addrouteLocs(LatLng routeLoc) {
    if (state.routeLocs.length == 2) {
      logger.e('More than 2 Locations are selected');
      return;
    }
    List list = [...state.routeLocs];
    list.add(routeLoc);
    state = state.copyWith(routeLocs: list);
    logger.d('DEBUG : Added Loc : $routeLoc');
  }

  void removeBin(Bin bin) {
    if (state.routeLocs.contains(bin.pos)) {
      state = state.copyWith(routeLocs: state.routeLocs..remove(bin.pos));
      logger.d('DEBUG : Removed bin : ${bin.id}');
      return;
    }
    logger.e("${bin.id} Bin doesnt exist");
  }

  void updateTapPos(WidgetRef ref, LatLng tapPos) {
    state = state.copyWith(routeLocs: state.routeLocs..remove(state.tapPos));

    if (tapPos != const LatLng(0, 0)) {
      state = state.copyWith(
        routeLocs: state.routeLocs..add(tapPos),
      );
    }
    state = state.copyWith(tapPos: tapPos);
    logger.d('DEBUG : added RouteLoc updated');
    logger.d(state.routeLocs);
  }

  void clearRoutes() {
    state = state.copyWith(route: [], routeLocs: [], allRoutes: []);
  }
}
