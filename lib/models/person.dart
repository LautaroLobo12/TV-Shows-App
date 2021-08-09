import 'dart:core';

class Person {
  Person(
      {required this.name,
      required this.id,
      required this.image,
      required this.country,
      required this.birthday});

  String name;
  int id;
  String image;
  String country;
  String birthday;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
      id: json['id'],
      name: json['name'],
      country: json['country'] == null ? '' : json['country']['name'],
      image: json['image'] == null ? '' : json['image']['medium'],
      birthday: json['birthday'] == null ? '' : json['birthday']);
}
