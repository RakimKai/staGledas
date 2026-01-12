// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klub_objave.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlubObjave _$KlubObjaveFromJson(Map<String, dynamic> json) => KlubObjave(
  id: (json['id'] as num?)?.toInt(),
  klubId: (json['klubId'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  sadrzaj: json['sadrzaj'] as String?,
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
  datumIzmjene: json['datumIzmjene'] == null
      ? null
      : DateTime.parse(json['datumIzmjene'] as String),
  isDeleted: json['isDeleted'] as bool?,
  datumBrisanja: json['datumBrisanja'] == null
      ? null
      : DateTime.parse(json['datumBrisanja'] as String),
  brojKomentara: (json['brojKomentara'] as num?)?.toInt(),
  brojLajkova: (json['brojLajkova'] as num?)?.toInt(),
  klub: json['klub'] == null
      ? null
      : KlubFilmova.fromJson(json['klub'] as Map<String, dynamic>),
  korisnik: json['korisnik'] == null
      ? null
      : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
);

Map<String, dynamic> _$KlubObjaveToJson(KlubObjave instance) =>
    <String, dynamic>{
      'id': instance.id,
      'klubId': instance.klubId,
      'korisnikId': instance.korisnikId,
      'sadrzaj': instance.sadrzaj,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'datumBrisanja': instance.datumBrisanja?.toIso8601String(),
      'brojKomentara': instance.brojKomentara,
      'brojLajkova': instance.brojLajkova,
      'klub': instance.klub,
      'korisnik': instance.korisnik,
    };
