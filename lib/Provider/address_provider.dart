import 'package:flutter/foundation.dart';
import 'package:tawasul_application/model/address_model.dart';

class AddressProvider with ChangeNotifier {
  Address? _defaultAddress;
  Address? _defaultShippingAddress;

  Address? get defaultAddress => _defaultAddress;
  Address? get defaultShippingAddress => _defaultShippingAddress;

  void setDefaultAddress(Address address) {
    _defaultAddress = address;
    notifyListeners();
  }

  void setDefaultShippingAddress(Address address) {
    _defaultShippingAddress = address;
    notifyListeners();
  }
}

