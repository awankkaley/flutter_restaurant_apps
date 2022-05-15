import 'dart:convert';

import 'package:restaurant_apps/models/restaurants.dart';

SearchResult searchResultFromJson(String str) => SearchResult.fromJson(json.decode(str));

class SearchResult {
  SearchResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool error;
  int founded;
  List<Restaurant> restaurants;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    error: json["error"],
    founded: json["founded"],
    restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
  );
}
