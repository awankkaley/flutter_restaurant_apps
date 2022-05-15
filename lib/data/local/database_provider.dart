import 'package:flutter/material.dart';
import 'package:restaurant_apps/data/local/database_helper.dart';
import '../../models/restaurants.dart';
import '../../models/result_state.dart';

class DatabaseProvider extends ChangeNotifier{
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}){
    _getData();
  }

  late ResultState _state = ResultState.NoData;
  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<Restaurant> _favorite = [];
  List<Restaurant> get favorite => _favorite;


  void _getData() async {
    _favorite = await databaseHelper.getData();
    if (_favorite.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addData(Restaurant restaurant) async {
    try {
      await databaseHelper.insertData(restaurant);
      _getData();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getDataById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeData(String id) async {
    try {
      await databaseHelper.removeData(id);
      _getData();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

}