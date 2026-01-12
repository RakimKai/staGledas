import 'package:json_annotation/json_annotation.dart';
import 'korisnik.dart';
import 'klub_filmova.dart';

part 'klub_objave.g.dart';

@JsonSerializable()
class KlubObjave {
  int? id;
  int? klubId;
  int? korisnikId;
  String? sadrzaj;
  DateTime? datumKreiranja;
  DateTime? datumIzmjene;
  bool? isDeleted;
  DateTime? datumBrisanja;
  int? brojKomentara;
  int? brojLajkova;
  KlubFilmova? klub;
  Korisnik? korisnik;

  KlubObjave({
    this.id,
    this.klubId,
    this.korisnikId,
    this.sadrzaj,
    this.datumKreiranja,
    this.datumIzmjene,
    this.isDeleted,
    this.datumBrisanja,
    this.brojKomentara,
    this.brojLajkova,
    this.klub,
    this.korisnik,
  });

  String get displayName => korisnik?.korisnickoIme ?? 'Korisnik';
  bool get wasEdited => datumIzmjene != null;

  factory KlubObjave.fromJson(Map<String, dynamic> json) =>
      _$KlubObjaveFromJson(json);

  Map<String, dynamic> toJson() => _$KlubObjaveToJson(this);
}
