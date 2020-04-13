class Movie {
  String site;
  String type;
  String url;
  String title;
  int time;

  Movie(this.site, this.type, this.url, this.title, this.time);

  Map toJson() {
    return {
      'site': site,
      'type': type,
      'link': url,
      'title': title,
      'time_min': time.toString()
    };
  }
}
