import 'package:intl/intl.dart';
import 'package:mfilm/model/genres.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

enum LoadingState { INIT, DONE, LOADING, WAITING, ERROR }

final dollarFormat = NumberFormat("#,##0.00", "en_US");
final sourceFormat = DateFormat('yyyy-MM-dd');
final dateFormat = DateFormat.yMMMMd("en_US");
final String sysLanguage = ui.window.locale.languageCode;

final Map<String, String> moveSortBy = {
  "popularity.desc": "Popularity (desc.)",
  "popularity.asc": "Popularity (asc.)",
  "vote_average.desc": "Vote average (desc.)",
  "vote_average.asc": "Vote average (asc.)",
  "first_air_date.desc": "First air date (desc.)",
  "first_air_date.asc": "First air date (asc.)",
};

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

String concatListToString(List<dynamic> data, String mapKey) {
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(data.map<String>((map) => map[mapKey]).toList(), ", ");
  return buffer.toString();
}

String formatSeasonsAndEpisodes(int numberOfSeasons, int numberOfEpisodes) =>
    '$numberOfSeasons Seasons and $numberOfEpisodes Episodes';

String formatNumberToDollars(int amount) => '\$${dollarFormat.format(amount)}';

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
