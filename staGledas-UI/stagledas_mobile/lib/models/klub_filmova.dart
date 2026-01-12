import 'package:json_annotation/json_annotation.dart';
import 'korisnik.dart';
import 'klub_filmova_clanovi.dart';

part 'klub_filmova.g.dart';

@JsonSerializable()
class KlubFilmova {
  int? id;
  String? naziv;
  String? opis;
  String? slika;
  int? vlasnikId;
  bool? isPrivate;
  int? maxClanova;
  DateTime? datumKreiranja;
  int? brojClanova;
  Korisnik? vlasnik;
  List<KlubFilmovaClanovi>? clanovi;

  KlubFilmova({
    this.id,
    this.naziv,
    this.opis,
    this.slika,
    this.vlasnikId,
    this.isPrivate,
    this.maxClanova,
    this.datumKreiranja,
    this.brojClanova,
    this.vlasnik,
    this.clanovi,
  });

  factory KlubFilmova.fromJson(Map<String, dynamic> json) =>
      _$KlubFilmovaFromJson(json);

  Map<String, dynamic> toJson() => _$KlubFilmovaToJson(this);
}
