import 'package:json_annotation/json_annotation.dart';
import 'korisnik.dart';

part 'klub_komentari.g.dart';

@JsonSerializable()
class KlubKomentari {
  int? id;
  int? objavaId;
  int? korisnikId;
  String? sadrzaj;
  DateTime? datumKreiranja;
  int? parentKomentarId;
  Korisnik? korisnik;

  KlubKomentari({
    this.id,
    this.objavaId,
    this.korisnikId,
    this.sadrzaj,
    this.datumKreiranja,
    this.parentKomentarId,
    this.korisnik,
  });

  String get displayName => korisnik?.korisnickoIme ?? 'Korisnik';
  bool get isReply => parentKomentarId != null;

  factory KlubKomentari.fromJson(Map<String, dynamic> json) =>
      _$KlubKomentariFromJson(json);

  Map<String, dynamic> toJson() => _$KlubKomentariToJson(this);
}
