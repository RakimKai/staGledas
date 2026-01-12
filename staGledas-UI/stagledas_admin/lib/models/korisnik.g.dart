// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      id: json['id'] as int?,
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      email: json['email'] as String?,
      korisnickoIme: json['korisnickoIme'] as String?,
      telefon: json['telefon'] as String?,
      slika: json['slika'] as String?,
      status: json['status'] as bool?,
      isPremium: json['isPremium'] as bool?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      datumIzmjene: json['datumIzmjene'] == null
          ? null
          : DateTime.parse(json['datumIzmjene'] as String),
      uloge: (json['uloge'] as List<dynamic>?)
          ?.map((e) => Uloga.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'id': instance.id,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'korisnickoIme': instance.korisnickoIme,
      'telefon': instance.telefon,
      'slika': instance.slika,
      'status': instance.status,
      'isPremium': instance.isPremium,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
      'uloge': instance.uloge,
    };
