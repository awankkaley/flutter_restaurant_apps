import 'package:flutter/cupertino.dart';
import 'package:restaurant_apps/models/detail.dart';

import '../../../models/result_state.dart';
import '../api_service.dart';


class DetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  DetailProvider({required this.apiService, required this.id}) {
    _fetchAllData();
  }

  late DetailResult _detailResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailResult get result => _detailResult;

  ResultState get state => _state;

  void reload() {
    _fetchAllData();
    notifyListeners();
  }

  Future<dynamic> _fetchAllData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final detail = await apiService.detail(id);
      _state = ResultState.Success;
      notifyListeners();
      return _detailResult = detail;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Tidak dapat menerima data, Periksa Jaringan Anda';
    }
  }
}
