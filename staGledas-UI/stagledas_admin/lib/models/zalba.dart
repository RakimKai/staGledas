import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_admin/models/korisnik.dart';
import 'package:stagledas_admin/models/recenzija.dart';

part 'zalba.g.dart';

@JsonSerializable()
class Zalba {
  int? id;
  int? korisnikId;
  int? recenzijaId;
  String? razlog;
  String? status;
  String? odgovor;
  DateTime? datumKreiranja;
  DateTime? datumObrade;
  Korisnik? korisnik;
  Recenzija? recenzija;

  Zalba({
    this.id,
    this.korisnikId,
    this.recenzijaId,
    this.razlog,
    this.status,
    this.odgovor,
    this.datumKreiranja,
    this.datumObrade,
    this.korisnik,
    this.recenzija,
  });

  factory Zalba.fromJson(Map<String, dynamic> json) => _$ZalbaFromJson(json);
  Map<String, dynamic> toJson() => _$ZalbaToJson(this);
}
