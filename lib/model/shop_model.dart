// import 'package:tawasul_application/model/store_model.dart';

// class Shop {
//   final String idRelayPoint;
//   final String relayPointName;
//   final String image;
//   final StoreDetails? details;
  
//   final int? id;
//   final String? name;
//   final String? address;
//   final String? city;


//   Shop({
//     required this.idRelayPoint,
//     required this.relayPointName,
//     required this.image,
//     this.details,
    
//     this.id,
//     this.name,
//     this.address,
//     this.city,
//   });

//   factory Shop.fromShippingJson(Map<String, dynamic> json) {
//     return Shop(
//       idRelayPoint: json['id_relay_point']?.toString() ?? '',
//       relayPointName: json['relay_point_name'] ?? '',
//       image: json['image'] ?? '',
//       id: int.tryParse(json['id_relay_point']?.toString() ?? ''),
//       name: json['relay_point_name'] ?? '',
//       address: json['relay_point_name'] ?? '', // Use relay point name as address if needed
//       city: json['relay_point_name'] ?? '', // Use relay point name as city if needed
//     );
//   }

//   // For backward compatibility with existing fromJson method
//   factory Shop.fromJson(Map<String, dynamic> json) {
//     return Shop(
//       idRelayPoint: json['id']?.toString() ?? json['id_relay_point']?.toString() ?? '',
//       relayPointName: json['name'] ?? json['relay_point_name'] ?? '',
//       image: json['image'] ?? '',
//       id: json['id'] ?? int.tryParse(json['id_relay_point']?.toString() ?? ''),
//       name: json['name'] ?? json['relay_point_name'] ?? '',
//       address: json['address'] ?? json['relay_point_name'] ?? '',
//       city: json['city'] ?? json['relay_point_name'] ?? '',
//     );
//   }

//   // Copy with method to update details
//   Shop copyWith({StoreDetails? details}) {
//     return Shop(
//       idRelayPoint: idRelayPoint,
//       relayPointName: relayPointName,
//       image: image,
//       details: details ?? this.details,
//       id: id,
//       name: name,
//       address: address,
//       city: city,
//     );
//   }

//   // Getters for backward compatibility
//   int get getId => id ?? int.tryParse(idRelayPoint) ?? 0;
//   String get getName => name ?? relayPointName;
//   String get getAddress => address ?? relayPointName;
//   String get getCity => city ?? relayPointName;
// }

import 'package:tawasul_application/model/store_details_model.dart';

class Shop {
  final int id;
  final String name;
  final String address;
  final String city;
  final String image;
  
  // New fields for shipping integration
  final String idRelayPoint;
  final String relayPointName;
  final StoreDetails? details;

  Shop({
    // Original fields
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.image = '',
    
    // New shipping fields
    this.idRelayPoint = '',
    this.relayPointName = '',
    this.details,
  });

  // Factory constructor for original format
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      image: json['image'] ?? '',
      
      // For shipping compatibility
      idRelayPoint: json['id_relay_point']?.toString() ?? json['id']?.toString() ?? '',
      relayPointName: json['relay_point_name'] ?? json['name'] ?? '',
    );
  }

  // Factory constructor for shipping format
  factory Shop.fromShippingJson(Map<String, dynamic> json) {
    return Shop(
      id: int.tryParse(json['id_relay_point']?.toString() ?? '') ?? 0,
      name: json['relay_point_name'] ?? '',
      address: json['relay_point_name'] ?? '', // Use name as address
      city: json['relay_point_name'] ?? '', // Use name as city
      image: json['image'] ?? '',
      
      // Shipping specific fields
      idRelayPoint: json['id_relay_point']?.toString() ?? '',
      relayPointName: json['relay_point_name'] ?? '',
    );
  }

  // Copy with method to add details
  Shop copyWith({StoreDetails? details}) {
    return Shop(
      id: id,
      name: name,
      address: address,
      city: city,
      image: image,
      idRelayPoint: idRelayPoint,
      relayPointName: relayPointName,
      details: details ?? this.details,
    );
  }

  // Getters for compatibility
  String get getIdRelayPoint => idRelayPoint.isNotEmpty ? idRelayPoint : id.toString();
  String get getRelayPointName => relayPointName.isNotEmpty ? relayPointName : name;
}