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
import 'package:mfilm/util/utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';

class ApiClientDb {
  static final _client = ApiClientDb._internal();
  final _http = HttpClient();
  final sourceFormat = DateFormat('yyyy-MM-dd');
  static final DBConnection _dbConnection = DBConnection.getInstance();
  ApiClientDb._internal();

  final String baseUrl = 'api.themoviedb.org';

  factory ApiClientDb() => _client;

  Future<dynamic> _getJson(Uri uri) async {
    var response = await (await _http.getUrl(uri)).close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> fetchMovies(
      {int page: 1, String category: "popularity"}) async {
    var collection =
        (await _dbConnection.getConnection()).collection("tmdb_cda_videos");

    List<MediaItem> list = await collection
        .find(where
            .sortBy('popularity', descending: true)
            .skip(30 * (page - 1))
            .limit(30 * page))
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie, db: true))
        .toList();

    _dbConnection.closeConnection();
    return list;
  }

  Future<List<MediaItem>> getMoviesForGenreIDs(
      {int page: 1, sortBy: "", List<int> genreIDs}) async {
    var url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': API_KEY,
      'page': page.toString(),
      'primary_release_date.lte': sourceFormat.format(DateTime.now()),
      'with_genres': getGenreIDs(genreIDs),
      'sort_by': sortBy
      //'sort_by': 'release_date.desc'
    });

    Future<List<MediaItem>> list = _getJson(url)
        .then((json) => json['results'])
        .then((data) => data
            .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
            .toList());

    return list.then((list) => list
        .where((item) => item.posterPath != "" || item.backdropPath != "")
        .toList());
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

  Future<dynamic> getMediaDetails(int mediaId, {String type: "movie"}) async {
    var url = Uri.https(baseUrl, '3/$type/$mediaId', {'api_key': API_KEY});

    return _getJson(url);
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    var url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': API_KEY,
      'with_cast': actorId.toString(),
      'sort_by': 'popularity.desc'
    });

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    var url = Uri.https(
        baseUrl, '3/search/multi', {'api_key': API_KEY, 'query': query});

    return _getJson(url).then((json) => json['results']
        .map<SearchResult>((item) => SearchResult.fromJson(item))
        .toList());
  }
}
