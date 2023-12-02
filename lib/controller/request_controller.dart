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

      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }
}
