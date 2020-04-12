import 'package:mfilm/model/cast.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/utils.dart';

class SearchResult {
  String _mediaType;
  Map<String, dynamic> data;
  MediaItem _mediaItem;

  String _getImagePath() {
    switch (_mediaType) {
      case "db":
        return _mediaItem.posterPath;
      case "movie":
      case "tv":
        return data['poster_path'] ?? "";
      case "person":
        return data['profile_path'] ?? "";
      default:
        return "";
    }
  }

  String get mediaTypeName {
    switch (_mediaType) {
      case "db":
      case "movie":
      case "tv":
        return "movie";
      case "person":
        return "person";
      default:
        return "";
    }
  }

  String get mediaType {
    return _mediaType;
  }

  String get title {
    switch (_mediaType) {
      case "db":
        return _mediaItem.title;
      case "video":
      case "movie":
        return data['title'];
      case "tv":
      case "person":
        return data['name'];
      default:
        return "";
    }
  }

  MediaItem asMovie(MediaType mediaType) {
    if (mediaType == MediaType.db) {
      return _mediaItem;
    } else {
      return MediaItem(data, mediaType);
    }
  }

  MediaItem asShow() => MediaItem(data, MediaType.show);

  Actor asActor() => Actor.fromJson(data);

  String get subtitle {
    switch (_mediaType) {
      case "db":
        return _mediaItem.releaseDate;
      case "video":
      case "movie":
        return formatDate(data['release_date']);

      default:
        return "";
    }
  }

  String get imageUrl => getMediumPictureUrl(_getImagePath());

  SearchResult.fromJson(Map jsonMap)
      : _mediaType = jsonMap['media_type'],
        data = jsonMap;

  SearchResult.fromMediaItem(String mediaType, MediaItem mediaItem) {
    this._mediaType = mediaType;
    this._mediaItem = mediaItem;
  }
}
