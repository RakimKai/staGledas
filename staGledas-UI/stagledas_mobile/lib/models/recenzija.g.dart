// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzija _$RecenzijaFromJson(Map<String, dynamic> json) => Recenzija(
  id: (json['id'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  username: json['username'] as String?,
  korisnikSlika: json['korisnikSlika'] as String?,
  filmId: (json['filmId'] as num?)?.toInt(),
  filmNaslov: json['filmNaslov'] as String?,
  filmPosterPath: json['filmPosterPath'] as String?,
  sadrzaj: json['sadrzaj'] as String?,
  ocjena: (json['ocjena'] as num?)?.toDouble(),
  imaSpoiler: json['imaSpoiler'] as bool?,
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
);

Map<String, dynamic> _$RecenzijaToJson(Recenzija instance) => <String, dynamic>{
  'id': instance.id,
  'korisnikId': instance.korisnikId,
  'username': instance.username,
  'korisnikSlika': instance.korisnikSlika,
  'filmId': instance.filmId,
  'filmNaslov': instance.filmNaslov,
  'filmPosterPath': instance.filmPosterPath,
  'sadrzaj': instance.sadrzaj,
  'ocjena': instance.ocjena,
  'imaSpoiler': instance.imaSpoiler,
  'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
};
