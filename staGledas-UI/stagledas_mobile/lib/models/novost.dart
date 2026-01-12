import 'package:json_annotation/json_annotation.dart';

part 'novost.g.dart';

@JsonSerializable()
class Novost {
  int? id;
  String? naslov;
  String? sadrzaj;
  String? slika;
  int? autorId;
  String? autorIme;
  DateTime? datumKreiranja;
  int? brojPregleda;

  Novost({
    this.id,
    this.naslov,
    this.sadrzaj,
    this.slika,
    this.autorId,
    this.autorIme,
    this.datumKreiranja,
    this.brojPregleda,
  });

  factory Novost.fromJson(Map<String, dynamic> json) => _$NovostFromJson(json);

  Map<String, dynamic> toJson() => _$NovostToJson(this);
}
