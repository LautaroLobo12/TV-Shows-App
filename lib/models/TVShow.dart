import 'dart:core';

import 'episode.dart';

class TVShow {
  TVShow({
    required this.image,
    required this.summary,
    required this.id,
    required this.name,
    required this.genres,
    required this.status,
    required this.schedule,
    required this.premiered,
    required this.cast,
    required this.episodes,
  });

  String image;
  String summary;
  int id;
  String name;
  List genres;
  String status;
  Map schedule;
  String premiered;
  List<dynamic> cast;
  List<Episode> episodes;

  factory TVShow.fromJson(Map<String, dynamic> json) {
    if (json['_embedded'] == null) {
      if (json['score'] == null) {
        return TVShow(
            image: json['image'] == null ? '' : json['image']['medium'],
            summary: json['summary'] == null ? '' : json['summary'],
            id: json['id'],
            name: json['name'],
            genres: json['genres'] == null ? [] : json['genres'],
            status: json['status'] == null ? '' : json['status'],
            schedule: json['schedule'],
            premiered: json['premiered'] == null ? '' : json['premiered'],
            cast: [],
            episodes: []);
      } else {
        return TVShow(
            image: json['show']['image'] == null
                ? ''
                : json['show']['image']['medium'],
            summary:
                json['show']['summary'] == null ? '' : json['show']['summary'],
            id: json['show']['id'],
            name: json['show']['name'],
            genres:
                json['show']['genres'] == null ? [] : json['show']['genres'],
            status:
                json['show']['status'] == null ? '' : json['show']['status'],
            schedule: json['show']['schedule'],
            premiered: json['show']['premiered'] == null
                ? ''
                : json['show']['premiered'],
            cast: [],
            episodes: []);
      }
    } else {
      return TVShow(
          image: json['image'] == null ? '' : json['image']['medium'],
          summary: json['summary'] == null ? '' : json['summary'],
          id: json['id'],
          name: json['name'],
          genres: json['genres'] == null ? [] : json['genres'],
          status: json['status'] == null ? '' : json['status'],
          schedule: json['schedule'],
          premiered: json['premiered'] == null ? '' : json['premiered'],
          cast: json['_embedded']['cast'],
          episodes: List<Episode>.from(
              json['_embedded']['episodes'].map((x) => Episode.fromJson(x))));
    }
  }
}
