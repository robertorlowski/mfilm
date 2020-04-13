import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:mfilm/model/cast.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/video.dart';
import 'package:mfilm/model/searchresult.dart';
import 'package:mfilm/util/db_mongo.dart';
import 'package:mfilm/util/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';

class ApiClientDb {
  static final _client = ApiClientDb._internal();
  final _http = HttpClient();
  final sourceFormat = DateFormat('yyyy-MM-dd');
  static final DBConnection _mongoDb = DBConnection.getInstance();
  ApiClientDb._internal();

  final String baseUrl = 'api.themoviedb.org';

  factory ApiClientDb() => _client;

  Future<dynamic> _getJson(Uri uri) async {
    var ppp = await _http.getUrl(uri);
    var response = await ppp.close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> fetchMovies(
      {int page: 1, String category: "popularity"}) async {
    Db _db = await _mongoDb.getConnection();
    try {
      var collection = _db.collection("tmdb_cda_videos");
      List<MediaItem> list = await collection
          .find(where
              .eq("status", "Released")
              .sortBy(category, descending: true)
              .sortBy("Id")
              .skip((20 * (page - 1)))
              .limit(20))
          .map<MediaItem>((item) => MediaItem(item, MediaType.db))
          .where((item) => item.posterPath != "" || item.backdropPath != "")
          .toList();
      return list;
    } finally {
      _mongoDb.closeConnection(_db);
    }
  }

  Future<List<MediaItem>> getMoviesForGenreIDs(
      {int page: 1, sortBy: "", List<int> genreIDs}) async {
    Db _db = await _mongoDb.getConnection();
    try {
      var collection = _db.collection("tmdb_cda_videos");
      List<MediaItem> list = await collection
          .find(where
              .eq("status", "Released")
              .oneFrom("genres", genreIDs)
              .sortBy(sortBy, descending: true)
              .sortBy("Id")
              .skip((20 * (page - 1)))
              .limit(20))
          .map<MediaItem>((item) => MediaItem(item, MediaType.db))
          .where((item) => item.posterPath != "" || item.backdropPath != "")
          .toList();

      return list;
    } finally {
      _mongoDb.closeConnection(_db);
    }
  }

  Future<List<SearchResult>> getSearchResults(String query) async {
    Db _db = await _mongoDb.getConnection();
    try {
      var collection = _db.collection("tmdb_cda_videos");

      List<SearchResult> resultList = [];

      List<MediaItem> list = await collection
          .find(where
              .eq("status", "Released")
              .match("title", query, caseInsensitive: true)
              .match("originalTitle", query, caseInsensitive: true)
              .limit(100))
          .map<MediaItem>((item) => MediaItem(item, MediaType.db))
          .where((item) => item.posterPath != "" || item.backdropPath != "")
          .toList();

      for (var item in list) {
        resultList.add(SearchResult.fromMediaItem("db", item));
      }

      return resultList;
    } finally {
      _mongoDb.closeConnection(_db);
    }
  }

  Future<List<Video>> getVideos(int movieId) async {
    var url = Uri.https(baseUrl, '3/movie/$movieId/videos', {
      'api_key': API_KEY,
    });

    return _getJson(url).then((json) => json['results']).then(
        (data) => data.map<Video>((item) => Video.fromJson(item)).toList());
  }

  Future<List<Genres>> getGenres(String language) async {
    var url = Uri.https(baseUrl, '3/genre/movie/list',
        {'api_key': API_KEY, 'language': language});

    return _getJson(url).then((json) => json['genres']).then(
        (data) => data.map<Genres>((item) => Genres.fromJson(item)).toList());
  }

  Future<List<Actor>> getMediaCredits(int mediaId,
      {String type: "movie"}) async {
    var url =
        Uri.https(baseUrl, '3/$type/$mediaId/credits', {'api_key': API_KEY});

    return _getJson(url).then((json) =>
        json['cast'].map<Actor>((item) => Actor.fromJson(item)).toList());
  }

  Future<dynamic> getMediaDetails(int mediaId,
      {String type: "movie", language: 'en-US'}) async {
    var url = Uri.https(baseUrl, '3/$type/$mediaId',
        {'api_key': API_KEY, 'language': language});

    return _getJson(url);
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId,
      {language: 'en-US'}) async {
    var url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': API_KEY,
      'with_cast': actorId.toString(),
      'sort_by': 'popularity.desc',
      'language': language
    });

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.video))
        .toList());
  }
}
