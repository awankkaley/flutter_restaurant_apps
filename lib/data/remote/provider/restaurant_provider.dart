import 'package:flutter/cupertino.dart';
import 'package:restaurant_apps/models/restaurants.dart';

import '../../../models/result_state.dart';
import '../api_service.dart';


class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllData();
  }

  late RestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantResult get result => _restaurantResult;

  ResultState get state => _state;

  void reload() {
    _fetchAllData();
    notifyListeners();
  }

  Future<dynamic> _fetchAllData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getList();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Data Tidak Tersedia';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Tidak dapat menerima data, Periksa Jaringan Anda';
    }
  }
}