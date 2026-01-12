// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzija _$RecenzijaFromJson(Map<String, dynamic> json) => Recenzija(
      id: json['id'] as int?,
      korisnikId: json['korisnikId'] as int?,
      filmId: json['filmId'] as int?,
      ocjena: json['ocjena'] as int?,
      naslov: json['naslov'] as String?,
      sadrzaj: json['sadrzaj'] as String?,
      brojLajkova: json['brojLajkova'] as int?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      datumIzmjene: json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      film: json['film'] == null
          ? null
          : Film.fromJson(json['film'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecenzijaToJson(Recenzija instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'filmId': instance.filmId,
      'ocjena': instance.ocjena,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'brojLajkova': instance.brojLajkova,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
      'korisnik': instance.korisnik,
      'film': instance.film,
    };
