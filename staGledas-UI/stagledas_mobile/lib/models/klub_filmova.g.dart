// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klub_filmova.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlubFilmova _$KlubFilmovaFromJson(Map<String, dynamic> json) => KlubFilmova(
  id: (json['id'] as num?)?.toInt(),
  naziv: json['naziv'] as String?,
  opis: json['opis'] as String?,
  slika: json['slika'] as String?,
  vlasnikId: (json['vlasnikId'] as num?)?.toInt(),
  isPrivate: json['isPrivate'] as bool?,
  maxClanova: (json['maxClanova'] as num?)?.toInt(),
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
  brojClanova: (json['brojClanova'] as num?)?.toInt(),
  vlasnik: json['vlasnik'] == null
      ? null
      : Korisnik.fromJson(json['vlasnik'] as Map<String, dynamic>),
  clanovi: (json['clanovi'] as List<dynamic>?)
      ?.map((e) => KlubFilmovaClanovi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KlubFilmovaToJson(KlubFilmova instance) =>
    <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'slika': instance.slika,
      'vlasnikId': instance.vlasnikId,
      'isPrivate': instance.isPrivate,
      'maxClanova': instance.maxClanova,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'brojClanova': instance.brojClanova,
      'vlasnik': instance.vlasnik,
      'clanovi': instance.clanovi,
    };
