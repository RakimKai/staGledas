import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_admin/models/korisnik.dart';
import 'package:stagledas_admin/models/film.dart';

part 'recenzija.g.dart';

@JsonSerializable()
class Recenzija {
  int? id;
  int? korisnikId;
  int? filmId;
  int? ocjena;
  String? naslov;
  String? sadrzaj;
  int? brojLajkova;
  DateTime? datumKreiranja;
  DateTime? datumIzmjene;
  Korisnik? korisnik;
  Film? film;

  Recenzija({
    this.id,
    this.korisnikId,
    this.filmId,
    this.ocjena,
    this.naslov,
    this.sadrzaj,
    this.brojLajkova,
    this.datumKreiranja,
    this.datumIzmjene,
    this.korisnik,
    this.film,
  });

  factory Recenzija.fromJson(Map<String, dynamic> json) => _$RecenzijaFromJson(json);
  Map<String, dynamic> toJson() => _$RecenzijaToJson(this);
}
