// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
      id: json['id'] as int?,
      naslov: json['naslov'] as String?,
      sadrzaj: json['sadrzaj'] as String?,
      slika: json['slika'] as String?,
      autorId: json['autorId'] as int?,
      brojPregleda: json['brojPregleda'] as int?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      datumIzmjene: json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
      autor: json['autor'] == null
          ? null
          : Korisnik.fromJson(json['autor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
      'id': instance.id,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'slika': instance.slika,
      'autorId': instance.autorId,
      'brojPregleda': instance.brojPregleda,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
      'autor': instance.autor,
    };
