// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klub_lajkovi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlubLajkovi _$KlubLajkoviFromJson(Map<String, dynamic> json) => KlubLajkovi(
  id: (json['id'] as num?)?.toInt(),
  objavaId: (json['objavaId'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  datumLajka: json['datumLajka'] == null
      ? null
      : DateTime.parse(json['datumLajka'] as String),
  korisnik: json['korisnik'] == null
      ? null
      : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
);

Map<String, dynamic> _$KlubLajkoviToJson(KlubLajkovi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'objavaId': instance.objavaId,
      'korisnikId': instance.korisnikId,
      'datumLajka': instance.datumLajka?.toIso8601String(),
      'korisnik': instance.korisnik,
    };
