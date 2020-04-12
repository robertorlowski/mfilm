import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:mfilm/model/cast.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/video.dart';
import 'package:mfilm/model/searchresult.dart';

import 'package:mfilm/util/constants.dart';
import 'package:mfilm/util/utils.dart';

class ApiClient {
  static final _client = ApiClient._internal();
  final _http = HttpClient();
  final sourceFormat = DateFormat('yyyy-MM-dd');

  ApiClient._internal();

  final String baseUrl = 'api.themoviedb.org';

  factory ApiClient() => _client;

  Future<dynamic> _getJson(Uri uri) async {
    var ppp = await _http.getUrl(uri);
    var response = await ppp.close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> fetchMovies(
      {int page: 1, String category: "popular", language: 'en-US'}) async {
    var url = Uri.https(baseUrl, '3/movie/$category',
        {'api_key': API_KEY, 'page': page.toString(), 'language': language});

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.video))
        .toList());
  }

  Future<List<MediaItem>> getMoviesForGenreIDs(
      {int page: 1, sortBy: "", List<int> genreIDs, language: 'en-US'}) async {
    var url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': API_KEY,
      'page': page.toString(),
      'primary_release_date.lte': sourceFormat.format(DateTime.now()),
      'with_genres': getGenreIDs(genreIDs),
      'sort_by': sortBy,
      'language': language
      //'sort_by': 'release_date.desc'
    });

    Future<List<MediaItem>> list = _getJson(url)
        .then((json) => json['results'])
        .then((data) => data
            .map<MediaItem>((item) => MediaItem(item, MediaType.video))
            .toList());

    return list.then((list) => list
        .where((item) => item.posterPath != "" || item.backdropPath != "")
        .toList());
  }

  Future<List<SearchResult>> getSearchResults(String query,
      {language: 'en-US'}) {
    var url = Uri.https(baseUrl, '3/search/multi',
        {'api_key': API_KEY, 'query': query, 'language': language});

    return _getJson(url).then((json) => json['results']
        .map<SearchResult>((item) => SearchResult.fromJson(item))
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
