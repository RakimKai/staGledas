// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Film _$FilmFromJson(Map<String, dynamic> json) => Film(
      id: json['id'] as int?,
      tmdbId: json['tmdbId'] as int?,
      naslov: json['naslov'] as String?,
      opis: json['opis'] as String?,
      godinaIzdanja: json['godinaIzdanja'] as int?,
      trajanje: json['trajanje'] as int?,
      reziser: json['reziser'] as String?,
      posterPath: json['posterPath'] as String?,
      prosjecnaOcjena: (json['prosjecnaOcjena'] as num?)?.toDouble(),
      brojOcjena: json['brojOcjena'] as int?,
      brojPregleda: json['brojPregleda'] as int?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      datumIzmjene: json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
    );

Map<String, dynamic> _$FilmToJson(Film instance) => <String, dynamic>{
      'id': instance.id,
      'tmdbId': instance.tmdbId,
      'naslov': instance.naslov,
      'opis': instance.opis,
      'godinaIzdanja': instance.godinaIzdanja,
      'trajanje': instance.trajanje,
      'reziser': instance.reziser,
      'posterPath': instance.posterPath,
      'prosjecnaOcjena': instance.prosjecnaOcjena,
      'brojOcjena': instance.brojOcjena,
      'brojPregleda': instance.brojPregleda,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
    };
