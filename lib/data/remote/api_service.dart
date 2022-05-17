import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:restaurant_apps/models/detail.dart';
import 'package:restaurant_apps/models/restaurants.dart';

import '../../models/search.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantResult> getList() async {
    final response = await http.get(Uri.parse(_baseUrl + "/list"));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<SearchResult> search(String keyword) async {
    final response = await http.get(
        Uri.parse(_baseUrl + "/search?q=" + keyword));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<DetailResult> detail(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + "/detail/" + id));
        if (response.statusCode == 200)
    {
      return DetailResult.fromJson(json.decode(response.body));
    } else {
    throw Exception('Failed to load data');
    }
  }
}