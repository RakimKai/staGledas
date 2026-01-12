// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zalba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zalba _$ZalbaFromJson(Map<String, dynamic> json) => Zalba(
      id: json['id'] as int?,
      korisnikId: json['korisnikId'] as int?,
      recenzijaId: json['recenzijaId'] as int?,
      razlog: json['razlog'] as String?,
      status: json['status'] as String?,
      odgovor: json['odgovor'] as String?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      datumObrade: json['datumObrade'] == null
          ? null
          : DateTime.parse(json['datumObrade'] as String),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      recenzija: json['recenzija'] == null
          ? null
          : Recenzija.fromJson(json['recenzija'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ZalbaToJson(Zalba instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'recenzijaId': instance.recenzijaId,
      'razlog': instance.razlog,
      'status': instance.status,
      'odgovor': instance.odgovor,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumObrade': instance.datumObrade?.toIso8601String(),
      'korisnik': instance.korisnik,
      'recenzija': instance.recenzija,
    };
