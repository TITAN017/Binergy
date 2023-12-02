// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:latlong2/latlong.dart';

class Bin {
  final String id;
  final LatLng pos;
  final String location;
  final double state;
  Bin({
    required this.id,
    required this.pos,
    required this.state,
    required this.location,
  });

  Bin copyWith({
    String? id,
    LatLng? pos,
    double? state,
    String? location,
  }) {
    return Bin(
        id: id ?? this.id,
        pos: pos ?? this.pos,
        state: state ?? this.state,
        location: location ?? this.location);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pos': [pos.latitude, pos.longitude],
      'state': state,
      'location': location
    };
  }

  factory Bin.fromMap(Map<String, dynamic> map) {
    return Bin(
        id: map['id'].toString(),
        pos: LatLng(map['pos'][0], map['pos'][1]),
        state: map['state'].toDouble(),
        location: map['location']);
  }

  @override
  String toString() {
    return id;
  }
}
