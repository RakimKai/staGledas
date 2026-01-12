// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watchlist _$WatchlistFromJson(Map<String, dynamic> json) => Watchlist(
  id: (json['id'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  filmId: (json['filmId'] as num?)?.toInt(),
  datumDodavanja: json['datumDodavanja'] == null
      ? null
      : DateTime.parse(json['datumDodavanja'] as String),
  pogledano: json['pogledano'] as bool?,
  datumGledanja: json['datumGledanja'] == null
      ? null
      : DateTime.parse(json['datumGledanja'] as String),
  korisnik: json['korisnik'] == null
      ? null
      : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
  film: json['film'] == null
      ? null
      : Film.fromJson(json['film'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WatchlistToJson(Watchlist instance) => <String, dynamic>{
  'id': instance.id,
  'korisnikId': instance.korisnikId,
  'filmId': instance.filmId,
  'datumDodavanja': instance.datumDodavanja?.toIso8601String(),
  'pogledano': instance.pogledano,
  'datumGledanja': instance.datumGledanja?.toIso8601String(),
  'korisnik': instance.korisnik,
  'film': instance.film,
};
