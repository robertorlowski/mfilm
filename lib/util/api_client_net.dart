import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:netfilm/model/cast.dart';
import 'package:netfilm/model/genres.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/model/video.dart';
import 'package:netfilm/model/searchresult.dart';
import 'package:netfilm/util/constants.dart';
import 'package:netfilm/util/utils.dart';

class ApiClientNet {
  static final _client = ApiClientNet._internal();
  final sourceFormat = DateFormat('yyyy-MM-dd');
  ApiClientNet._internal();

  final String baseUrl = 'api.themoviedb.org';
  final String netUrl = '91.192.2.140:9000';

  factory ApiClientNet() => _client;

  Future<dynamic> _getJson(Uri uri, {String apiKey}) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    HttpClientRequest request = await client.getUrl(uri);
    request.headers.removeAll('Content-Type');
    request.headers.set('Content-Type', 'application/json; charset=utf-8');
    if (apiKey != null) {
      request.headers.removeAll('API-Key');
      request.headers.set("API-Key", apiKey);
    }

    HttpClientResponse result = await request.close();
    var transformedResponse = await result.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> fetchMovies(
      {int page: 1, String category: "popularity"}) async {
    var url = Uri.https(netUrl, 'netfilm/fetchMovies',
        {'page': page.toString(), 'category': category});

    return _getJson(url, apiKey: NET_API_KEY).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.db))
        .where((item) => item.posterPath != "" || item.backdropPath != "")
        .toList());
  }

  Future<List<MediaItem>> getMoviesForGenreIDs(
      {int page: 1, sortBy: "", List<int> genreIDs}) async {
    var url = Uri.https(netUrl, '/netfilm/fetchMoviesForGenres', {
      'page': page.toString(),
      'category': sortBy,
      'genres': getGenreIDs(genreIDs)
    });

    return _getJson(url, apiKey: NET_API_KEY).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.db))
        .where((item) => item.posterPath != "" || item.backdropPath != "")
        .toList());
  }

  Future<List<SearchResult>> getSearchResults(String query) async {
    var url = Uri.https(netUrl, '/netfilm/fetchSearchMovies', {'title': query});

    List<SearchResult> resultList = [];

    List<MediaItem> list = await _getJson(url, apiKey: NET_API_KEY).then(
        (data) => data
            .map<MediaItem>((item) => MediaItem(item, MediaType.db))
            .where((item) => item.posterPath != "" || item.backdropPath != "")
            .toList());

    for (var item in list) {
      resultList.add(SearchResult.fromMediaItem("db", item));
    }

    return resultList;
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
