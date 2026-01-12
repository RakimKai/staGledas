import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? id;
  String? ime;
  String? prezime;
  String? korisnickoIme;
  String? email;
  String? slika;
  DateTime? datumKreiranja;
  bool? isPremium;

  Korisnik({
    this.id,
    this.ime,
    this.prezime,
    this.korisnickoIme,
    this.email,
    this.slika,
    this.datumKreiranja,
    this.isPremium,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);

  String get fullName => '${ime ?? ''} ${prezime ?? ''}'.trim();
}
