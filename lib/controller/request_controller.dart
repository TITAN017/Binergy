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

  Future<List<Map<String, dynamic>>> getRoute(Map<String, String> map) async {
    try {
      List modes = ['drive', 'motorcycle', 'walk'];
      List<Map<String, dynamic>> allRoutes = [];
      final url =
          '${ProjectConstants.endpoint}?waypoints=${map['waypoints']}&mode=MODE&traffic=approximated&apiKey=${map['apiKey']}';

      for (int i = 0; i < 3; i++) {
        final rurl = url.replaceAll(RegExp(r'MODE'), modes[i]);
        final response = await dio.get(rurl);
        allRoutes.add(response.data as Map<String, dynamic>);
      }

      return allRoutes;
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getLocations(String text) async {
    try {
      final url =
          '${ProjectConstants.autoEndpoint}?text=$text&format=json&apiKey=${ProjectConstants.apiKey}';

      final response = await dio.get(url);
      return response.data;
    } catch (e) {
      logger.e(e.toString());
      return {};
    }
  }
}
