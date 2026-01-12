import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_mobile/models/korisnik.dart';

part 'poruka.g.dart';

@JsonSerializable()
class Poruka {
  int? id;
  int? posiljateljId;
  int? primateljId;
  String? sadrzaj;
  bool? procitano;
  DateTime? datumSlanja;
  DateTime? datumCitanja;
  Korisnik? posiljatelj;
  Korisnik? primatelj;

  Poruka({
    this.id,
    this.posiljateljId,
    this.primateljId,
    this.sadrzaj,
    this.procitano,
    this.datumSlanja,
    this.datumCitanja,
    this.posiljatelj,
    this.primatelj,
  });

  factory Poruka.fromJson(Map<String, dynamic> json) => _$PorukaFromJson(json);

  Map<String, dynamic> toJson() => _$PorukaToJson(this);
}
