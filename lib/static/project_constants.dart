import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProjectConstants {
  static const String apiKey = 'd49c9757b5fb4cc79841eb5356a01109';
  static const String endpoint = 'https://api.geoapify.com/v1/routing';
  static const String autoEndpoint =
      'https://api.geoapify.com/v1/geocode/autocomplete';
  static final logger = Logger();

  static List<Color> floatingIconColor = [
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  static List<String> floatingIconMsg = [
    'Almost Empty...',
    'Almost Full...',
    'Filling Fast...'
  ];
}
