import 'package:json_annotation/json_annotation.dart';

part 'tmdb_movie.g.dart';

@JsonSerializable()
class TmdbMovie {
  int? id;
  String? title;
  @JsonKey(name: 'original_title')
  String? originalTitle;
  String? overview;
  @JsonKey(name: 'release_date')
  String? releaseDate;
  @JsonKey(name: 'poster_path')
  String? posterPath;
  @JsonKey(name: 'backdrop_path')
  String? backdropPath;
  @JsonKey(name: 'vote_average')
  double? voteAverage;
  @JsonKey(name: 'vote_count')
  int? voteCount;
  double? popularity;
  @JsonKey(name: 'genre_ids')
  List<int>? genreIds;

  TmdbMovie({
    this.id,
    this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.popularity,
    this.genreIds,
  });

  factory TmdbMovie.fromJson(Map<String, dynamic> json) => _$TmdbMovieFromJson(json);

  Map<String, dynamic> toJson() => _$TmdbMovieToJson(this);

  String get posterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w342$posterPath'
      : '';

  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w780$backdropPath'
      : '';

  int? get year {
    if (releaseDate != null && releaseDate!.length >= 4) {
      return int.tryParse(releaseDate!.substring(0, 4));
    }
    return null;
  }
}
