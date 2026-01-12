// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obavijest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Obavijest _$ObavijestFromJson(Map<String, dynamic> json) => Obavijest(
  id: (json['id'] as num?)?.toInt(),
  tip: json['tip'] as String?,
  posiljateljId: (json['posiljateljId'] as num?)?.toInt(),
  primateljId: (json['primateljId'] as num?)?.toInt(),
  klubId: (json['klubId'] as num?)?.toInt(),
  poruka: json['poruka'] as String?,
  status: json['status'] as String?,
  procitano: json['procitano'] as bool?,
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
  datumObrade: json['datumObrade'] == null
      ? null
      : DateTime.parse(json['datumObrade'] as String),
  posiljatelj: json['posiljatelj'] == null
      ? null
      : Korisnik.fromJson(json['posiljatelj'] as Map<String, dynamic>),
  klub: json['klub'] == null
      ? null
      : KlubFilmova.fromJson(json['klub'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ObavijestToJson(Obavijest instance) => <String, dynamic>{
  'id': instance.id,
  'tip': instance.tip,
  'posiljateljId': instance.posiljateljId,
  'primateljId': instance.primateljId,
  'klubId': instance.klubId,
  'poruka': instance.poruka,
  'status': instance.status,
  'procitano': instance.procitano,
  'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
  'datumObrade': instance.datumObrade?.toIso8601String(),
  'posiljatelj': instance.posiljatelj,
  'klub': instance.klub,
};
