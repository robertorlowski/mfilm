import 'dart:async';

import 'package:netfilm/model/cast.dart';
import 'package:netfilm/model/genres.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/model/searchresult.dart';
import 'package:netfilm/model/video.dart';
import 'package:netfilm/util/api_client.dart';
import 'package:netfilm/util/api_client_db.dart';

abstract class MediaProvider {
  Future<List<MediaItem>> loadMedia(String category, {int page: 1});

  Future<List<MediaItem>> loadMediaForGenreIDs(List<int> genreIDs,
      {sortBy: "", int page: 1});

  Future<List<Actor>> loadCast(int mediaId);

  Future<dynamic> getDetails(int mediaId);

  Future<List<Video>> loadVideo(int mediaId);

  Future<List<Genres>> loadGenres();

  Future<List<SearchResult>> getSearchResults(String query);

  Future<List<MediaItem>> getMoviesForActor(int actorId);
}

class MovieProviderDb extends MediaProvider {
  String _language = "en_US";

  MovieProviderDb(this._language);

  ApiClientDb _apiClient = ApiClientDb();

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page: 1}) {
    return _apiClient.fetchMovies(category: category, page: page);
  }

  @override
  Future<List<MediaItem>> loadMediaForGenreIDs(
    List<int> genreIDs, {
    sortBy: "",
    int page: 1,
  }) {
    return _apiClient.getMoviesForGenreIDs(
        genreIDs: genreIDs, page: page, sortBy: sortBy);
  }

  @override
  Future<dynamic> getDetails(int mediaId) {
    return _apiClient.getMediaDetails(mediaId,
        type: "movie", language: _language);
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
  Future<List<Genres>> loadGenres() {
    return _apiClient.getGenres(_language);
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    return _apiClient.getSearchResults(query);
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) {
    return _apiClient.getMoviesForActor(actorId, language: _language);
  }
}

class MovieProviderVideo extends MediaProvider {
  String _language = "en_US";

  MovieProviderVideo(this._language);

  ApiClient _apiClient = ApiClient();

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page: 1}) {
    return _apiClient.fetchMovies(
        category: category, page: page, language: _language);
  }

  @override
  Future<List<MediaItem>> loadMediaForGenreIDs(List<int> genreIDs,
      {sortBy: "", int page: 1}) {
    return _apiClient.getMoviesForGenreIDs(
        genreIDs: genreIDs, page: page, sortBy: sortBy, language: _language);
  }

  @override
  Future<dynamic> getDetails(int mediaId) {
    return _apiClient.getMediaDetails(mediaId,
        type: "movie", language: _language);
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
  Future<List<Genres>> loadGenres() {
    return _apiClient.getGenres(this._language);
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    return _apiClient.getSearchResults(query, language: _language);
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) {
    return _apiClient.getMoviesForActor(actorId, language: _language);
  }
}
