import 'package:flutter/cupertino.dart';

import '../../../models/result_state.dart';
import '../../../models/search.dart';
import '../api_service.dart';



class SearchProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  late SearchResult _searchResult;
  late String _keyword;
  ResultState _state = ResultState.NoData;
  String _message = '';

  String get message => _message;

  String get keyword => _keyword;

  SearchResult get result => _searchResult;

  ResultState get state => _state;

  void search(String key) {
    _keyword = key;
    _fetchAllData();
    notifyListeners();
  }


  Future<dynamic> _fetchAllData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.search(keyword);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Data Tidak Tersedia';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Tidak dapat menerima data, Periksa Jaringan Anda';
    }
  }
}
