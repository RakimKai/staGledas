// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zalba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zalba _$ZalbaFromJson(Map<String, dynamic> json) => Zalba(
  id: (json['id'] as num?)?.toInt(),
  recenzijaId: (json['recenzijaId'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  razlog: json['razlog'] as String?,
  opis: json['opis'] as String?,
  status: json['status'] as String?,
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
);

Map<String, dynamic> _$ZalbaToJson(Zalba instance) => <String, dynamic>{
  'id': instance.id,
  'recenzijaId': instance.recenzijaId,
  'korisnikId': instance.korisnikId,
  'razlog': instance.razlog,
  'opis': instance.opis,
  'status': instance.status,
  'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
};
