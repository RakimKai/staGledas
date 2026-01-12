import 'package:json_annotation/json_annotation.dart';
import 'korisnik.dart';

part 'klub_filmova_clanovi.g.dart';

@JsonSerializable()
class KlubFilmovaClanovi {
  int? id;
  int? klubId;
  int? korisnikId;
  String? uloga;
  DateTime? datumPridruzivanja;
  Korisnik? korisnik;

  KlubFilmovaClanovi({
    this.id,
    this.klubId,
    this.korisnikId,
    this.uloga,
    this.datumPridruzivanja,
    this.korisnik,
  });

  bool get isOwner => uloga == 'owner';
  bool get isMember => uloga == 'member';

  factory KlubFilmovaClanovi.fromJson(Map<String, dynamic> json) =>
      _$KlubFilmovaClanoviFromJson(json);

  Map<String, dynamic> toJson() => _$KlubFilmovaClanoviToJson(this);
}
