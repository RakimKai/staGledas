import 'package:json_annotation/json_annotation.dart';

part 'pretplate.g.dart';

@JsonSerializable()
class Pretplate {
  int? id;
  int? korisnikId;
  String? stripeCustomerId;
  String? stripeSubscriptionId;
  String? status;
  DateTime? datumPocetka;
  DateTime? datumIsteka;
  DateTime? datumKreiranja;
  DateTime? datumIzmjene;

  Pretplate({
    this.id,
    this.korisnikId,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.status,
    this.datumPocetka,
    this.datumIsteka,
    this.datumKreiranja,
    this.datumIzmjene,
  });

  factory Pretplate.fromJson(Map<String, dynamic> json) =>
      _$PretplateFromJson(json);

  Map<String, dynamic> toJson() => _$PretplateToJson(this);

  bool get isActive => status == 'active';
}
