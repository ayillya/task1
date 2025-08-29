import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../network_utils/network_manager.dart';
import '../status_enum.dart';

class StatusProvider extends ChangeNotifier {
  FetchState _state = FetchState.initial; FetchState get state => _state;
  User? _user; User? get user => _user;
  String? _error; String? get error => _error;

  Future<void> fetchUserById(int? id) async {
    _state = FetchState.loading; notifyListeners(); // show spinner immediately
    if (id == null || id < 1 || id > 3) { 
      await Future.delayed(const Duration(milliseconds: 300)); // spinner visible briefly
      _state = FetchState.apiError; 
      _error = "Please enter a valid ID (1, 2, or 3). The value provided was invalid."; 
      notifyListeners(); 
      return; 
    }
    try { _user = await NetworkManager.fetchUser(id); _state = FetchState.success; } 
    catch (e) { _state = FetchState.apiError; _error = e.toString().replaceFirst("Exception: ", ""); }
    notifyListeners();
  }
}
