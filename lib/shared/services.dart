import 'package:binergy/static/project_constants.dart';

class Services {
  static Map<String, String> getRouteMap(List routeLocs) {
    return {
      'waypoints':
          '${routeLocs[0].latitude},${routeLocs[0].longitude}|${routeLocs[1].latitude},${routeLocs[1].longitude}',
      'apiKey': ProjectConstants.apiKey
    };
  }
}
