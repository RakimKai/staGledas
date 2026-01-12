// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poruka.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poruka _$PorukaFromJson(Map<String, dynamic> json) => Poruka(
  id: (json['id'] as num?)?.toInt(),
  posiljateljId: (json['posiljateljId'] as num?)?.toInt(),
  primateljId: (json['primateljId'] as num?)?.toInt(),
  sadrzaj: json['sadrzaj'] as String?,
  procitano: json['procitano'] as bool?,
  datumSlanja: json['datumSlanja'] == null
      ? null
      : DateTime.parse(json['datumSlanja'] as String),
  datumCitanja: json['datumCitanja'] == null
      ? null
      : DateTime.parse(json['datumCitanja'] as String),
  posiljatelj: json['posiljatelj'] == null
      ? null
      : Korisnik.fromJson(json['posiljatelj'] as Map<String, dynamic>),
  primatelj: json['primatelj'] == null
      ? null
      : Korisnik.fromJson(json['primatelj'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PorukaToJson(Poruka instance) => <String, dynamic>{
  'id': instance.id,
  'posiljateljId': instance.posiljateljId,
  'primateljId': instance.primateljId,
  'sadrzaj': instance.sadrzaj,
  'procitano': instance.procitano,
  'datumSlanja': instance.datumSlanja?.toIso8601String(),
  'datumCitanja': instance.datumCitanja?.toIso8601String(),
  'posiljatelj': instance.posiljatelj,
  'primatelj': instance.primatelj,
};
