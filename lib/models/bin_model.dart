// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:latlong2/latlong.dart';

class Bin {
  final String id;
  final LatLng pos;
  final double state;
  Bin({
    required this.id,
    required this.pos,
    required this.state,
  });

  Bin copyWith({
    String? id,
    LatLng? pos,
    double? state,
  }) {
    return Bin(
      id: id ?? this.id,
      pos: pos ?? this.pos,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pos': [pos.latitude, pos.longitude],
      'state': state,
    };
  }

  factory Bin.fromMap(Map<String, dynamic> map) {
    return Bin(
      id: map['id'].toString(),
      pos: LatLng(map['pos'][0], map['pos'][1]),
      state: map['state'].toDouble(),
    );
  }
}
