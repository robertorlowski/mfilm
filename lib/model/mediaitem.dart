import 'package:mfilm/model/move.dart';
import 'package:mfilm/util/utils.dart';

enum MediaType { video, show, db }
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

  factory MediaItem(Map jsonMap, MediaType type) => type == MediaType.db
      ? MediaItem._internalFromDbJson(jsonMap, type: type)
      : MediaItem._internalFromJson(jsonMap, type: type);

  MediaItem._internalFromDbJson(Map jsonMap, {MediaType type: MediaType.db})
      : type = type,
        id = jsonMap["id"].toInt(),
        voteAverage = jsonMap["voteAverage"] != null
            ? jsonMap["voteAverage"].toDouble()
            : null,
        title = jsonMap["title"],
        posterPath = jsonMap["posterPath"] ?? "",
        backdropPath = jsonMap["backdropPath"] ?? "",
        overview = jsonMap["overview"],
        releaseDate = jsonMap["releaseDate"],
        genreIds = jsonMap["genres"] == null
            ? []
            : (jsonMap["genres"] as List<dynamic>)
                .map<int>((value) => value.toInt())
                .toList(),
        movieIds = jsonMap["cdaIds"] == null
            ? []
            : (jsonMap["cdaIds"])
                .map<Movie>((value) => new Movie("cda.pl",
                    MovieType.CDA.toString(), value["link"], value["title"]))
                .toList();

  MediaItem._internalFromJson(Map jsonMap, {MediaType type: MediaType.video})
      : type = type,
        id = jsonMap["id"].toInt(),
        voteAverage = jsonMap["vote_average"] != null
            ? jsonMap["vote_average"].toDouble()
            : null,
        title = jsonMap[(type == MediaType.video ? "title" : "name")],
        posterPath = jsonMap["poster_path"] ?? "",
        backdropPath = jsonMap["backdrop_path"] ?? "",
        overview = jsonMap["overview"],
        releaseDate = jsonMap[
            (type == MediaType.video ? "release_date" : "first_air_date")],
        genreIds = jsonMap["genres"] == null
            ? []
            : (jsonMap["genre_ids"] as List<dynamic>)
                .map<int>((value) => value.toInt())
                .toList(),
        movieIds = [];

  Map toJson() {
    if (type == MediaType.db)
      return {
        'type': 2,
        'id': id,
        'voteAverage': voteAverage,
        'title': title,
        'posterPath': posterPath,
        'backdropPath': backdropPath,
        'overview': overview,
        'releaseDate': releaseDate,
        'genres': genreIds,
        'site': videoIds,
      };
    else
      return {
        'type': type == MediaType.video ? 1 : 0,
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
  }

  factory MediaItem.fromPrefsJson(Map jsonMap) {
    if (jsonMap['type'].toInt() == 1) {
      return MediaItem._internalFromJson(jsonMap, type: MediaType.video);
    } else if (jsonMap['type'].toInt() == 0) {
      return MediaItem._internalFromJson(jsonMap, type: MediaType.show);
    } else {
      return MediaItem._internalFromDbJson(jsonMap, type: MediaType.db);
    }
  }
}
