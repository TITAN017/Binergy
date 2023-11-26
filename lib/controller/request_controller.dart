import 'dart:convert';

import 'package:binergy/static/project_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final requestController =
    StateNotifierProvider<RequestProvider, bool>((ref) => RequestProvider());

class RequestProvider extends StateNotifier<bool> {
  RequestProvider() : super(false);

  final dio = Dio();
  final logger = Logger();

  Future getRoute(Map<String, String> map) async {
    try {
      final url =
          '${ProjectConstants.endpoint}?waypoints=${map['waypoints']}&mode=${map['mode']}&apiKey=${map['apiKey']}';
      final dummy =
          'https://api.geoapify.com/v1/routing?waypoints=12.9767936,77.590082|12.7632858,75.2018421&mode=drive&apiKey=d49c9757b5fb4cc79841eb5356a01109';
      final response = await dio.get(dummy);
      return response.data;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
