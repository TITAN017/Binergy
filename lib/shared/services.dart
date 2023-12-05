import 'package:binergy/static/project_constants.dart';

class Services {
  static Map<String, String> getRouteMap(List routeLocs) {
    return {
      'waypoints':
          '${routeLocs[0].latitude},${routeLocs[0].longitude}|${routeLocs[1].latitude},${routeLocs[1].longitude}',
      'apiKey': ProjectConstants.apiKey
    };
  }

  static Map<String, dynamic> getBin(List data) {
    return {
      'id': data[0],
      'pos': [data[1].latitude, data[1].longitude],
      'location': 'Null',
      'state': 0
    };
  }
}
