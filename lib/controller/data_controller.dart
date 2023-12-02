// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:binergy/models/bin_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AppData {
  final List routes;
  final List bins;
  AppData({required this.routes, required this.bins});

  AppData copyWith({List? routes, List? bins}) {
    return AppData(routes: routes ?? this.routes, bins: bins ?? this.bins);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'routes': routes,
      'bins': bins,
    };
  }

  factory AppData.fromMap(Map<String, dynamic> map) {
    return AppData(
      routes: List.from(
        (map['routes'] as List),
      ),
      bins: List.from(
        (map['bins'] as List),
      ),
    );
  }
}

final dataController =
    StateNotifierProvider<DataProvider, AppData>((ref) => DataProvider());

class DataProvider extends StateNotifier<AppData> {
  DataProvider() : super(AppData(routes: [], bins: []));

  final logger = Logger();

  void addRoutes(Map<String, dynamic> data) {
    logger.d(data);
    state = state.copyWith(
        routes: data['features'][0]['geometry']['coordinates'][0]);
  }

  void addBins(Bin bin) {
    if (state.bins.length == 2) {
      logger.e('More than 2 bins selected');
      return;
    }
    List<Bin> list = [...state.bins];
    list.add(bin);
    state = state.copyWith(bins: list);
    logger.d('DEBUG : Added bin : ${bin.id}');
  }

  void removeBin(Bin bin) {
    if (state.bins.contains(bin)) {
      state = state.copyWith(bins: state.bins..remove(bin));
      logger.d('DEBUG : Removed bin : ${bin.id}');
      return;
    }
    logger.e("${bin.id} Bin doesnt exist");
  }
}
