// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Film _$FilmFromJson(Map<String, dynamic> json) => Film(
  id: (json['id'] as num?)?.toInt(),
  tmdbId: (json['tmdbId'] as num?)?.toInt(),
  naslov: json['naslov'] as String?,
  opis: json['opis'] as String?,
  godinaIzlaska: (json['godinaIzlaska'] as num?)?.toInt(),
  reziser: json['reziser'] as String?,
  trajanje: (json['trajanje'] as num?)?.toInt(),
  posterPath: json['posterPath'] as String?,
  backdropPath: json['backdropPath'] as String?,
  prosjecnaOcjena: (json['prosjecnaOcjena'] as num?)?.toDouble(),
  brojRecenzija: (json['brojRecenzija'] as num?)?.toInt(),
  brojLajkova: (json['brojLajkova'] as num?)?.toInt(),
);

Map<String, dynamic> _$FilmToJson(Film instance) => <String, dynamic>{
  'id': instance.id,
  'tmdbId': instance.tmdbId,
  'naslov': instance.naslov,
  'opis': instance.opis,
  'godinaIzlaska': instance.godinaIzlaska,
  'reziser': instance.reziser,
  'trajanje': instance.trajanje,
  'posterPath': instance.posterPath,
  'backdropPath': instance.backdropPath,
  'prosjecnaOcjena': instance.prosjecnaOcjena,
  'brojRecenzija': instance.brojRecenzija,
  'brojLajkova': instance.brojLajkova,
};
