import 'package:mfilm/model/move.dart';
import 'package:mfilm/util/utils.dart';

enum MediaType { movie, show }
enum MovieType { CDA }

class MediaItem {
  MediaType type;
  int id;
  double voteAverage;
  String title;
  String posterPath;
  String backdropPath;
  String overview;
  String releaseDate;
  List<Movie> movieIds = const <Movie>[];
  //"https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
  //"https://vcze602.cda.pl/PE_GXJTYIK3q7xTc32SxJA/1582713422/lq1da5e89c9fdc923830643648585c95c1.mp4";
  //"https://www.cda.pl/video/346890198"
  //"https://ebd.cda.pl/620x368/346890198",

  List<int> genreIds;
  List<String> videoIds;

  String getBackDropUrl() => getLargePictureUrl(backdropPath);
  String getPosterUrl() => getMediumPictureUrl(posterPath);
  int getReleaseYear() {
    return releaseDate == null || releaseDate == ""
        ? 0
        : DateTime.parse(releaseDate).year;
  }

  factory MediaItem(Map jsonMap, MediaType type) =>
      MediaItem._internalFromJson(jsonMap, type: type);

  MediaItem._internalFromJson(Map jsonMap, {MediaType type: MediaType.movie})
      : type = type,
        id = jsonMap["id"].toInt(),
        voteAverage = jsonMap["vote_average"].toDouble(),
        title = jsonMap[(type == MediaType.movie ? "title" : "name")],
        posterPath = jsonMap["poster_path"] ?? "",
        backdropPath = jsonMap["backdrop_path"] ?? "",
        overview = jsonMap["overview"],
        releaseDate = jsonMap[
            (type == MediaType.movie ? "release_date" : "first_air_date")],
        genreIds = (jsonMap["genre_ids"] as List<dynamic>)
            .map<int>((value) => value.toInt())
            .toList(),
        movieIds = new List<Movie>.filled(
            1,
            new Movie(
                "cda.pl",
                MovieType.CDA.toString(),
                "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                jsonMap[(type == MediaType.movie ? "title" : "name")]));

  Map toJson() => {
        'type': type == MediaType.movie ? 1 : 0,
        'id': id,
        'vote_average': voteAverage,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': overview,
        'release_date': releaseDate,
        'genre_ids': genreIds,
        'site': videoIds,
      };

  factory MediaItem.fromPrefsJson(Map jsonMap) => MediaItem._internalFromJson(
      jsonMap,
      type: (jsonMap['type'].toInt() == 1) ? MediaType.movie : MediaType.show);
}
