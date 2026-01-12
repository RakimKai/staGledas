import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_mobile/models/korisnik.dart';

part 'pratitelji.g.dart';

@JsonSerializable()
class Pratitelji {
  int? id;
  int? korisnikId;
  int? pratiteljId;
  DateTime? datumPracenja;
  Korisnik? korisnik;
  Korisnik? pratitelj;

  Pratitelji({
    this.id,
    this.korisnikId,
    this.pratiteljId,
    this.datumPracenja,
    this.korisnik,
    this.pratitelj,
  });

  factory Pratitelji.fromJson(Map<String, dynamic> json) =>
      _$PratiteljiFromJson(json);

  Map<String, dynamic> toJson() => _$PratiteljiToJson(this);
}
