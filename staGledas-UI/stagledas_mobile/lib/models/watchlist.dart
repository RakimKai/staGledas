import 'package:json_annotation/json_annotation.dart';
import 'package:stagledas_mobile/models/film.dart';
import 'package:stagledas_mobile/models/korisnik.dart';

part 'watchlist.g.dart';

@JsonSerializable()
class Watchlist {
  int? id;
  int? korisnikId;
  int? filmId;
  DateTime? datumDodavanja;
  bool? pogledano;
  DateTime? datumGledanja;
  Korisnik? korisnik;
  Film? film;

  Watchlist({
    this.id,
    this.korisnikId,
    this.filmId,
    this.datumDodavanja,
    this.pogledano,
    this.datumGledanja,
    this.korisnik,
    this.film,
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) =>
      _$WatchlistFromJson(json);

  Map<String, dynamic> toJson() => _$WatchlistToJson(this);
}
