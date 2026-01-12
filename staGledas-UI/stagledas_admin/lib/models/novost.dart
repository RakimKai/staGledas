import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_admin/models/korisnik.dart';

part 'novost.g.dart';

@JsonSerializable()
class Novost {
  int? id;
  String? naslov;
  String? sadrzaj;
  String? slika;
  int? autorId;
  int? brojPregleda;
  DateTime? datumKreiranja;
  DateTime? datumIzmjene;
  Korisnik? autor;

  Novost({
    this.id,
    this.naslov,
    this.sadrzaj,
    this.slika,
    this.autorId,
    this.brojPregleda,
    this.datumKreiranja,
    this.datumIzmjene,
    this.autor,
  });

  factory Novost.fromJson(Map<String, dynamic> json) => _$NovostFromJson(json);
  Map<String, dynamic> toJson() => _$NovostToJson(this);
}
