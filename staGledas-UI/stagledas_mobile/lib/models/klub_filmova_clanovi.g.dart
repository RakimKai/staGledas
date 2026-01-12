// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klub_filmova_clanovi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlubFilmovaClanovi _$KlubFilmovaClanoviFromJson(Map<String, dynamic> json) =>
    KlubFilmovaClanovi(
      id: (json['id'] as num?)?.toInt(),
      klubId: (json['klubId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      uloga: json['uloga'] as String?,
      datumPridruzivanja: json['datumPridruzivanja'] == null
          ? null
          : DateTime.parse(json['datumPridruzivanja'] as String),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KlubFilmovaClanoviToJson(KlubFilmovaClanovi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'klubId': instance.klubId,
      'korisnikId': instance.korisnikId,
      'uloga': instance.uloga,
      'datumPridruzivanja': instance.datumPridruzivanja?.toIso8601String(),
      'korisnik': instance.korisnik,
    };
