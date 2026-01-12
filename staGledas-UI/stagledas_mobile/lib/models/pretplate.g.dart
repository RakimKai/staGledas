// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pretplate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pretplate _$PretplateFromJson(Map<String, dynamic> json) => Pretplate(
  id: (json['id'] as num?)?.toInt(),
  korisnikId: (json['korisnikId'] as num?)?.toInt(),
  stripeCustomerId: json['stripeCustomerId'] as String?,
  stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
  status: json['status'] as String?,
  datumPocetka: json['datumPocetka'] == null
      ? null
      : DateTime.parse(json['datumPocetka'] as String),
  datumIsteka: json['datumIsteka'] == null
      ? null
      : DateTime.parse(json['datumIsteka'] as String),
  datumKreiranja: json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String),
  datumIzmjene: json['datumIzmjene'] == null
      ? null
      : DateTime.parse(json['datumIzmjene'] as String),
);

Map<String, dynamic> _$PretplateToJson(Pretplate instance) => <String, dynamic>{
  'id': instance.id,
  'korisnikId': instance.korisnikId,
  'stripeCustomerId': instance.stripeCustomerId,
  'stripeSubscriptionId': instance.stripeSubscriptionId,
  'status': instance.status,
  'datumPocetka': instance.datumPocetka?.toIso8601String(),
  'datumIsteka': instance.datumIsteka?.toIso8601String(),
  'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
  'datumIzmjene': instance.datumIzmjene?.toIso8601String(),
};
