import 'dart:async';

import 'package:mfilm/model/cast.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/video.dart';
import 'package:mfilm/util/api_client_mongo.dart';

abstract class MediaProvider {
  Future<List<MediaItem>> loadMedia(String category, {int page: 1});

  Future<List<MediaItem>> loadMediaForGenreIDs(List<int> genreIDs,
      {sortBy: "", int page: 1});

  Future<List<Actor>> loadCast(int mediaId);

  Future<dynamic> getDetails(int mediaId);

  Future<List<Video>> loadVideo(int mediaId);

  Future<List<Genres>> loadGenres(String locale);
}

class MovieProvider extends MediaProvider {
  MovieProvider();

  ApiClientDb _apiClient = ApiClientDb();

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page: 1}) {
    return _apiClient.fetchMovies(category: category, page: page);
  }

  @override
  Future<List<MediaItem>> loadMediaForGenreIDs(List<int> genreIDs,
      {sortBy: "", int page: 1}) {
    return _apiClient.getMoviesForGenreIDs(
        genreIDs: genreIDs, page: page, sortBy: sortBy);
  }

  @override
  Future<dynamic> getDetails(int mediaId) {
    return _apiClient.getMediaDetails(mediaId, type: "movie");
  }

  @override
  Future<List<Actor>> loadCast(int mediaId) {
    return _apiClient.getMediaCredits(mediaId, type: "movie");
  }

  @override
  Future<List<Video>> loadVideo(int mediaId) {
    return _apiClient.getVideos(mediaId);
  }

  @override
  Future<List<Genres>> loadGenres(String locale) {
    return _apiClient.getGenres(locale);
  }
}
