import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/TVShow.dart';
import '../models/episode.dart';
import '../models/person.dart';

const String baseUrl = 'https://api.tvmaze.com';

class TVServices {
  Future showIndex(int pageNumber) async {
    final String url = '$baseUrl/shows?page=$pageNumber';
    List<TVShow> shows = [];
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((element) => shows.add(TVShow.fromJson(element)));
    } else {
      throw Exception('request failed');
    }
    return shows;
  }

  Future getSeriesData(int id) async {
    final String url = '$baseUrl/shows/$id?embed[]=episodes&embed[]=cast';
    final response = await http.get(Uri.parse(url));
    TVShow? show;
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      show = TVShow.fromJson(body);
    } else {
      throw Exception('request failed');
    }
    return show;
  }

  Future getEpisodeData(int id) async {
    final String url = '$baseUrl/episodes/$id';
    final response = await http.get(Uri.parse(url));
    Episode? episode;
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      episode = Episode.fromJson(body);
    } else {
      throw Exception('request failed');
    }
    return episode;
  }

  Future searchSeries(String searchText) async {
    late String url;
    if (searchText == '') {
      url = '$baseUrl/shows?page=0';
    } else {
      url = '$baseUrl/search/shows?q=$searchText';
    }
    final response = await http.get(Uri.parse(url));
    List<TVShow> shows = [];
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      body.forEach((element) => shows.add(TVShow.fromJson(element)));
    } else {
      throw Exception('request failed');
    }
    return shows;
  }

  Future getPersonDetails(int id) async {
    final url = '$baseUrl/people/$id';
    final response = await http.get(Uri.parse(url));
    Person? person;
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      person = Person.fromJson(body);
    } else {
      throw Exception('request failed');
    }
    return person;
  }
}
