// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
  id: (json['id'] as num?)?.toInt(),
  naslov: json['naslov'] as String?,
  sadrzaj: json['sadrzaj'] as String?,
  slika: json['slika'] as String?,
  autorId: (json['autorId'] as num?)?.toInt(),
  autorIme: json['autorIme'] as String?,
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
  brojPregleda: (json['brojPregleda'] as num?)?.toInt(),
);

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
  'id': instance.id,
  'naslov': instance.naslov,
  'sadrzaj': instance.sadrzaj,
  'slika': instance.slika,
  'autorId': instance.autorId,
  'autorIme': instance.autorIme,
  'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
  'brojPregleda': instance.brojPregleda,
};
