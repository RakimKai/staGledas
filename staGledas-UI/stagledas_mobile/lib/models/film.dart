import 'package:json_annotation/json_annotation.dart';

part 'film.g.dart';

@JsonSerializable()
class Film {
  int? id;
  int? tmdbId;
  String? naslov;
  String? opis;
  int? godinaIzlaska;
  String? reziser;
  int? trajanje;
  String? posterPath;
  String? backdropPath;
  double? prosjecnaOcjena;
  int? brojRecenzija;
  int? brojLajkova;

  Film({
    this.id,
    this.tmdbId,
    this.naslov,
    this.opis,
    this.godinaIzlaska,
    this.reziser,
    this.trajanje,
    this.posterPath,
    this.backdropPath,
    this.prosjecnaOcjena,
    this.brojRecenzija,
    this.brojLajkova,
  });

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);

  Map<String, dynamic> toJson() => _$FilmToJson(this);

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w342$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w780$backdropPath'
      : '';
}
