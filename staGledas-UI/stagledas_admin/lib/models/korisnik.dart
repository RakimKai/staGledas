import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_admin/models/uloga.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? id;
  String? ime;
  String? prezime;
  String? email;
  String? korisnickoIme;
  String? telefon;
  String? slika;
  bool? status;
  bool? isPremium;
  DateTime? datumKreiranja;
  DateTime? datumIzmjene;
  List<Uloga>? uloge;

  Korisnik({
    this.id,
    this.ime,
    this.prezime,
    this.email,
    this.korisnickoIme,
    this.telefon,
    this.slika,
    this.status,
    this.isPremium,
    this.datumKreiranja,
    this.datumIzmjene,
    this.uloge,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) => _$KorisnikFromJson(json);
  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
