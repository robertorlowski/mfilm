import 'package:intl/intl.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

enum LoadingState { INIT, DONE, LOADING, WAITING, ERROR }

final dollarFormat = NumberFormat("#,##0.00", "en_US");
final sourceFormat = DateFormat('yyyy-MM-dd');
final dateFormat = DateFormat.yMMMMd("en_US");
final String sysLanguage = ui.window.locale.languageCode;

final List<String> moveSortBy = [
  "release_date",
  "popularity",
  //"vote_average",
];

getSortByKey(MediaType mediaType, String key) {
  if (MediaType.db == mediaType) {
    switch (key) {
      case 'popularity':
        return 'popularity';
      case 'vote_average':
        return 'voteAverage';
      case "release_date":
        return 'releaseDate';
    }
  } else {
    switch (key) {
      case 'popularity':
        return 'popularity.desc';
      case 'vote_average':
        return 'vote_average.desc';
      case "release_date":
        return 'primary_release_date.desc';
    }
  }
}

List<int> getGenresForIds(List<Genres> genreIds) =>
    genreIds.map<int>((map) => map.id).toList();

List<String> getGenresNameForIds2(List<int> ids, List<Genres> genreIds) {
  List<String> lll = new List<String>();
  for (Genres gg in genreIds) {
    if (ids.contains(gg.id)) {
      lll.add(gg.name);
    }
  }
  return lll;
}

List<String> getGenresNameForIds(List<Genres> genreIds) =>
    genreIds.map<String>((map) => map.name).toList();

String getGenreString(List<Genres> genreIds) {
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(getGenresForIds(genreIds), ",");
  return buffer.toString();
}

String getGenreStringNames(List<Genres> genreIds) {
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(getGenresNameForIds(genreIds), ", ");
  return buffer.toString();
}

String getGenreIDs(List<int> genreIds) {
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(genreIds, ", ");
  return buffer.toString();
}

String formatDate(String date) {
  try {
    return dateFormat.format(sourceFormat.parse(date));
  } catch (Exception) {
    return "";
  }
}

String formatRuntime(int runtime) {
  int hours = runtime ~/ 60;
  int minutes = runtime % 60;

  return '$hours\h $minutes\m';
}

launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

String getImdbUrl(String imdbId) => 'http://www.imdb.com/title/$imdbId';

final String _imageUrlLarge = "https://image.tmdb.org/t/p/w500";
final String _imageUrlMedium = "https://image.tmdb.org/t/p/w300";

String getMediumPictureUrl(String path) => _imageUrlMedium + path;
String getLargePictureUrl(String path) => _imageUrlLarge + path;
