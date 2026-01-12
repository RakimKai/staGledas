import 'package:json_annotation/json_annotation.dart';
import 'korisnik.dart';

part 'klub_lajkovi.g.dart';

@JsonSerializable()
class KlubLajkovi {
  int? id;
  int? objavaId;
  int? korisnikId;
  DateTime? datumLajka;
  Korisnik? korisnik;

  KlubLajkovi({
    this.id,
    this.objavaId,
    this.korisnikId,
    this.datumLajka,
    this.korisnik,
  });

  factory KlubLajkovi.fromJson(Map<String, dynamic> json) =>
      _$KlubLajkoviFromJson(json);

  Map<String, dynamic> toJson() => _$KlubLajkoviToJson(this);
}
