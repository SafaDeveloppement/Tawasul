class CarrierModel {
  final int idCarrier;
  final String name;
  final String delay;
  final String price;
  final String minDate;
  final List<RelayGroup> relayGroups;

  CarrierModel({
    required this.idCarrier,
    required this.name,
    required this.delay,
    required this.price,
    required this.minDate,
    required this.relayGroups,
  });

  factory CarrierModel.fromJson(Map<String, dynamic> json) {
    return CarrierModel(
      idCarrier: json['id_carrier'] ?? 0,
      name: json['name'] ?? '',
      delay: json['delay'] ?? '',
      price: json['price'] ?? '',
      minDate: json['min_date'] ?? '',
      relayGroups: (json['relay_groups'] as List? ?? [])
          .map((group) => RelayGroup.fromJson(group))
          .toList(),
    );
  }

  bool get isStorePickup => name.toLowerCase().contains('store') || 
                            name.toLowerCase().contains('pickup');
}

class RelayGroup {
  final int idRelayGroup;
  final String relayGroupName;
  final int cityId;
  final int idLang;
  final List<RelayPoint>? relayPoints;

  RelayGroup({
    required this.idRelayGroup,
    required this.relayGroupName,
    required this.cityId,
    required this.idLang,
    this.relayPoints,
  });

  factory RelayGroup.fromJson(Map<String, dynamic> json) {
    return RelayGroup(
      idRelayGroup: json['id_relay_group'] ?? 0,
      relayGroupName: json['relay_group_name'] ?? '',
      cityId: json['city_id'] ?? 0,
      idLang: json['id_lang'] ?? 0,
      relayPoints: json['relay_points'] != null
          ? (json['relay_points'] as List)
              .map((point) => RelayPoint.fromJson(point))
              .toList()
          : null,
    );
  }
}

class RelayPoint {
  final int idRelayPoint;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String openingHours;

  RelayPoint({
    required this.idRelayPoint,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.openingHours,
  });

  factory RelayPoint.fromJson(Map<String, dynamic> json) {
    return RelayPoint(
      idRelayPoint: json['id_relay_point'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
      openingHours: json['opening_hours'] ?? '',
    );
  }
}