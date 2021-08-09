import 'dart:core';

class Episode {
  Episode({
    required this.id,
    required this.name,
    required this.number,
    required this.season,
    required this.airdate,
    required this.image,
    required this.summary,
  });

  int id;
  String name;
  int number;
  int season;
  String airdate;
  String image;
  String summary;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      season: json['season'],
      airdate: json['airdate'],
      image: json['image'] == null ? '' : json['image']['medium'],
      summary: json['summary'] ?? '');
}
