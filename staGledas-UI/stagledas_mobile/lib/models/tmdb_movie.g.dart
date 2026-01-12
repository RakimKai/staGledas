// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbMovie _$TmdbMovieFromJson(Map<String, dynamic> json) => TmdbMovie(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  originalTitle: json['original_title'] as String?,
  overview: json['overview'] as String?,
  releaseDate: json['release_date'] as String?,
  posterPath: json['poster_path'] as String?,
  backdropPath: json['backdrop_path'] as String?,
  voteAverage: (json['vote_average'] as num?)?.toDouble(),
  voteCount: (json['vote_count'] as num?)?.toInt(),
  popularity: (json['popularity'] as num?)?.toDouble(),
  genreIds: (json['genre_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$TmdbMovieToJson(TmdbMovie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'original_title': instance.originalTitle,
  'overview': instance.overview,
  'release_date': instance.releaseDate,
  'poster_path': instance.posterPath,
  'backdrop_path': instance.backdropPath,
  'vote_average': instance.voteAverage,
  'vote_count': instance.voteCount,
  'popularity': instance.popularity,
  'genre_ids': instance.genreIds,
};
