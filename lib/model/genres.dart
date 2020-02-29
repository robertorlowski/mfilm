class Genres {
  int id;
  String name;

  Genres.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'];
}
