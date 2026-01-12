import 'package:json_annotation/json_annotation.dart';

part 'zalba.g.dart';

@JsonSerializable()
class Zalba {
  int? id;
  int? recenzijaId;
  int? korisnikId;
  String? razlog;
  String? opis;
  String? status;
  DateTime? datumKreiranja;

  Zalba({
    this.id,
    this.recenzijaId,
    this.korisnikId,
    this.razlog,
    this.opis,
    this.status,
    this.datumKreiranja,
  });

  factory Zalba.fromJson(Map<String, dynamic> json) => _$ZalbaFromJson(json);
  Map<String, dynamic> toJson() => _$ZalbaToJson(this);
}
