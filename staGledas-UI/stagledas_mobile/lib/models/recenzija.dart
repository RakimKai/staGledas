import 'package:json_annotation/json_annotation.dart';

part 'recenzija.g.dart';

@JsonSerializable()
class Recenzija {
  int? id;
  int? korisnikId;
  String? username;
  String? korisnikSlika;
  int? filmId;
  String? filmNaslov;
  String? filmPosterPath;
  String? sadrzaj;
  double? ocjena;
  bool? imaSpoiler;
  DateTime? datumKreiranja;

  Recenzija({
    this.id,
    this.korisnikId,
    this.username,
    this.korisnikSlika,
    this.filmId,
    this.filmNaslov,
    this.filmPosterPath,
    this.sadrzaj,
    this.ocjena,
    this.imaSpoiler,
    this.datumKreiranja,
  });

  String get displayName => username ?? 'Korisnik';

  factory Recenzija.fromJson(Map<String, dynamic> json) =>
      _$RecenzijaFromJson(json);

  Map<String, dynamic> toJson() => _$RecenzijaToJson(this);
}
