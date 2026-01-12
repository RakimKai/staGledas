import 'package:json_annotation/json_annotation.dart';

part 'uloga.g.dart';

@JsonSerializable()
class Uloga {
  int? id;
  String? naziv;
  String? opis;

  Uloga({this.id, this.naziv, this.opis});

  factory Uloga.fromJson(Map<String, dynamic> json) => _$UlogaFromJson(json);
  Map<String, dynamic> toJson() => _$UlogaToJson(this);
}
