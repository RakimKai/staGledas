import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_mobile/models/korisnik.dart';
import 'package:stagledas_mobile/models/klub_filmova.dart';

part 'obavijest.g.dart';

@JsonSerializable()
class Obavijest {
  int? id;
  String? tip;
  int? posiljateljId;
  int? primateljId;
  int? klubId;
  String? poruka;
  String? status;
  bool? procitano;
  DateTime? datumKreiranja;
  DateTime? datumObrade;
  Korisnik? posiljatelj;
  KlubFilmova? klub;

  Obavijest({
    this.id,
    this.tip,
    this.posiljateljId,
    this.primateljId,
    this.klubId,
    this.poruka,
    this.status,
    this.procitano,
    this.datumKreiranja,
    this.datumObrade,
    this.posiljatelj,
    this.klub,
  });

  factory Obavijest.fromJson(Map<String, dynamic> json) => _$ObavijestFromJson(json);
  Map<String, dynamic> toJson() => _$ObavijestToJson(this);
}
