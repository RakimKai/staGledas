// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pratitelji.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pratitelji _$PratiteljiFromJson(Map<String, dynamic> json) => Pratitelji(
  id: (json['id'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  pratiteljId: (json['pratiteljId'] as num?)?.toInt(),
  datumPracenja: json['datumPracenja'] == null
      ? null
      : DateTime.parse(json['datumPracenja'] as String),
  korisnik: json['korisnik'] == null
      ? null
      : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
  pratitelj: json['pratitelj'] == null
      ? null
      : Korisnik.fromJson(json['pratitelj'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PratiteljiToJson(Pratitelji instance) =>
    <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'pratiteljId': instance.pratiteljId,
      'datumPracenja': instance.datumPracenja?.toIso8601String(),
      'korisnik': instance.korisnik,
      'pratitelj': instance.pratitelj,
    };
