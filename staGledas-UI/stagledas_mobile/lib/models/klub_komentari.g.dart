// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klub_komentari.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KlubKomentari _$KlubKomentariFromJson(Map<String, dynamic> json) =>
    KlubKomentari(
      id: (json['id'] as num?)?.toInt(),
      objavaId: (json['objavaId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      sadrzaj: json['sadrzaj'] as String?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      parentKomentarId: (json['parentKomentarId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KlubKomentariToJson(KlubKomentari instance) =>
    <String, dynamic>{
      'id': instance.id,
      'objavaId': instance.objavaId,
      'korisnikId': instance.korisnikId,
      'sadrzaj': instance.sadrzaj,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'parentKomentarId': instance.parentKomentarId,
      'korisnik': instance.korisnik,
    };
