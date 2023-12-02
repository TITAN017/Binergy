import 'package:binergy/models/bin_model.dart';
import 'package:binergy/static/project_constants.dart';

class Services {
  static Map<String, String> getRouteMap(List<Bin> bins, String mode) {
    return {
      'waypoints':
          '${bins[0].pos.latitude},${bins[0].pos.longitude}|${bins[1].pos.latitude},${bins[1].pos.longitude}',
      'mode': mode,
      'apiKey': ProjectConstants.apiKey
    };
  }
}
