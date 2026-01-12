import 'package:json_annotation/json_annotation.dart';

part 'film.g.dart';

@JsonSerializable()
class Film {
  int? id;
  int? tmdbId;
  String? naslov;
  String? opis;
  int? godinaIzdanja;
  int? trajanje;
  String? reziser;
  String? posterPath;
  double? prosjecnaOcjena;
  int? brojOcjena;
  int? brojPregleda;
  DateTime? datumKreiranja;
  DateTime? datumIzmjene;

  Film({
    this.id,
    this.tmdbId,
    this.naslov,
    this.opis,
    this.godinaIzdanja,
    this.trajanje,
    this.reziser,
    this.posterPath,
    this.prosjecnaOcjena,
    this.brojOcjena,
    this.brojPregleda,
    this.datumKreiranja,
    this.datumIzmjene,
  });

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);
  Map<String, dynamic> toJson() => _$FilmToJson(this);

  String get fullPosterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w342$posterPath'
      : '';
}
