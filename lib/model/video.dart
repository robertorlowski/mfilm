class Video {
  String id;
  String key;
  String name;
  String site;
  int size;
  String type; //Trailer, Teaser, Clip, Featurette, Behind the Scenes, Bloopers
  String url;

  Video.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        key = jsonMap['key'],
        name = jsonMap['name'],
        site = jsonMap['site'],
        size = jsonMap['size'],
        type = jsonMap['type'];
}
