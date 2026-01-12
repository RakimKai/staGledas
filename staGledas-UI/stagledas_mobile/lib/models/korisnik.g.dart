// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
  id: (json['id'] as num?)?.toInt(),
  ime: json['ime'] as String?,
  prezime: json['prezime'] as String?,
  korisnickoIme: json['korisnickoIme'] as String?,
  email: json['email'] as String?,
  slika: json['slika'] as String?,
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
  isPremium: json['isPremium'] as bool?,
);

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
  'id': instance.id,
  'ime': instance.ime,
  'prezime': instance.prezime,
  'korisnickoIme': instance.korisnickoIme,
  'email': instance.email,
  'slika': instance.slika,
  'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
  'isPremium': instance.isPremium,
};
