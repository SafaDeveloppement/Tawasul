// import 'package:flutter/foundation.dart';
// import 'package:tawasul_application/model/carrier_model.dart';
// import 'package:tawasul_application/model/time_slot_model.dart';
// import 'package:tawasul_application/view/Quick_access/shops.dart';


// class OrderProvider with ChangeNotifier {
//   int? _cartId;
//   Carrier? _selectedCarrier;
//   RelayGroup? _selectedRelayGroup;
//   Shop? _selectedShop;
//   DateTime? _selectedDate;
//   TimeSlot? _selectedTimeSlot;

//   // Getters
//   int? get cartId => _cartId;
//   Carrier? get selectedCarrier => _selectedCarrier;
//   RelayGroup? get selectedRelayGroup => _selectedRelayGroup;
//   Shop? get selectedShop => _selectedShop;
//   DateTime? get selectedDate => _selectedDate;
//   TimeSlot? get selectedTimeSlot => _selectedTimeSlot;

//   // Setters
//   void setCartId(int id) {
//     _cartId = id;
//     notifyListeners();
//   }

//   void setDeliveryMethod(Carrier carrier) {
//     _selectedCarrier = carrier;
//     _selectedRelayGroup = null;
//     _selectedShop = null;
//     _selectedTimeSlot = null;
//     notifyListeners();
//   }

//   void setRelayGroup(RelayGroup relayGroup) {
//     _selectedRelayGroup = relayGroup;
//     _selectedShop = null;
//     _selectedTimeSlot = null;
//     notifyListeners();
//   }

//   void setStorePickupDetails(Shop shop, DateTime date, TimeSlot timeSlot, {RelayGroup? relayGroup}) {
//     _selectedShop = shop;
//     _selectedDate = date;
//     _selectedTimeSlot = timeSlot;
//     if (relayGroup != null) {
//       _selectedRelayGroup = relayGroup;
//     }
//     notifyListeners();
//   }

//   void clearStorePickupDetails() {
//     _selectedRelayGroup = null;
//     _selectedShop = null;
//     _selectedDate = null;
//     _selectedTimeSlot = null;
//     notifyListeners();
//   }

//   // Check if store pickup is complete
//   bool get isStorePickupComplete {
//     return _selectedCarrier != null &&
//         _selectedCarrier!.hasRelayGroups &&
//         _selectedRelayGroup != null &&
//         _selectedShop != null &&
//         _selectedDate != null &&
//         _selectedTimeSlot != null;
//   }

//   // Check if regular delivery is selected
//   bool get isRegularDeliverySelected {
//     return _selectedCarrier != null && !_selectedCarrier!.hasRelayGroups;
//   }
// }

// providers/order_provider.dart
import 'package:flutter/foundation.dart';
import 'package:tawasul_application/model/carrier_model.dart';
import 'package:tawasul_application/model/shop_model.dart'; // Import from models, not view
import 'package:tawasul_application/model/time_slot_model.dart';

class OrderProvider with ChangeNotifier {
  int? _cartId;
  //Carrier? _selectedCarrier;
  RelayGroup? _selectedRelayGroup;
  Shop? _selectedShop;
  DateTime? _selectedDate;
  TimeSlot? _selectedTimeSlot;

  // Getters
  int? get cartId => _cartId;
  //Carrier? get selectedCarrier => _selectedCarrier;
  RelayGroup? get selectedRelayGroup => _selectedRelayGroup;
  Shop? get selectedShop => _selectedShop;
  DateTime? get selectedDate => _selectedDate;
  TimeSlot? get selectedTimeSlot => _selectedTimeSlot;

  // Setters
  void setCartId(int id) {
    _cartId = id;
    notifyListeners();
  }

  void setDeliveryMethod() {   //Carrier carrier
   // _selectedCarrier = carrier;
    _selectedRelayGroup = null;
    _selectedShop = null;
    _selectedTimeSlot = null;
    notifyListeners();
  }

  void setRelayGroup(RelayGroup relayGroup) {
    _selectedRelayGroup = relayGroup;
    _selectedShop = null;
    _selectedTimeSlot = null;
    notifyListeners();
  }

  void setStorePickupDetails(Shop shop, DateTime date, TimeSlot timeSlot, {RelayGroup? relayGroup}) {
    _selectedShop = shop;
    _selectedDate = date;
    _selectedTimeSlot = timeSlot;
    if (relayGroup != null) {
      _selectedRelayGroup = relayGroup;
    }
    notifyListeners();
  }

  void clearStorePickupDetails() {
    _selectedRelayGroup = null;
    _selectedShop = null;
    _selectedDate = null;
    _selectedTimeSlot = null;
    notifyListeners();
  }

  // Check if store pickup is complete
  bool get isStorePickupComplete {
    //  _selectedCarrier != null &&
    //     _selectedCarrier!.hasRelayGroups &&
      return  _selectedRelayGroup != null &&
        _selectedShop != null &&
        _selectedDate != null &&
        _selectedTimeSlot != null;
  }

  // Check if regular delivery is selected
  // bool get isRegularDeliverySelected {
  //   return _selectedCarrier != null && !_selectedCarrier!.hasRelayGroups;
  // }
}