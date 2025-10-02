import 'package:flutter/foundation.dart';
import 'package:tawasul_application/Services/api_service.dart';
import 'package:tawasul_application/model/customer_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _user != null && _user!.isValid;

  Future<void> loadUserData() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await ApiService.getCustomerDetails();

      if (userData != null) {
        _user = User.fromJson(userData);
      } else {
        _error = 'Failed to load user data';
      }
    } catch (e) {
      _error = 'Error loading user data: $e';
      print('UserProvider error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    _error = null;
    notifyListeners();
  }
}