// models/store_details_model.dart
class StoreDetails {
  final String idStore;
  final String idCountry;
  final String idState;
  final String city;
  final String postcode;
  final String latitude;
  final String longitude;
  final String phone;
  final String fax;
  final String email;
  final String active;
  final String dateAdd;
  final String dateUpd;
  final String idRelayPoint;
  final String idLang;
  final String name;
  final String address1;
  final String address2;
  final String note;
  final List<BusinessHours> businessHours;

  StoreDetails({
    required this.idStore,
    required this.idCountry,
    required this.idState,
    required this.city,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.fax,
    required this.email,
    required this.active,
    required this.dateAdd,
    required this.dateUpd,
    required this.idRelayPoint,
    required this.idLang,
    required this.name,
    required this.address1,
    required this.address2,
    required this.note,
    required this.businessHours,
  });

  factory StoreDetails.fromJson(Map<String, dynamic> json) {
    return StoreDetails(
      idStore: json['id_store']?.toString() ?? '',
      idCountry: json['id_country']?.toString() ?? '',
      idState: json['id_state']?.toString() ?? '',
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      phone: json['phone'] ?? '',
      fax: json['fax'] ?? '',
      email: json['email'] ?? '',
      active: json['active']?.toString() ?? '',
      dateAdd: json['date_add'] ?? '',
      dateUpd: json['date_upd'] ?? '',
      idRelayPoint: json['id_relay_point']?.toString() ?? '',
      idLang: json['id_lang']?.toString() ?? '',
      name: json['name'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      note: json['note'] ?? '',
      businessHours: json['business_hours'] != null
          ? (json['business_hours'] as List)
              .map((hours) => BusinessHours.fromJson(hours))
              .toList()
          : [],
    );
  }
}

class BusinessHours {
  final String day;
  final List<String> hours;

  BusinessHours({
    required this.day,
    required this.hours,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      day: json['day'] ?? '',
      hours: json['hours'] != null
          ? List<String>.from(json['hours'])
          : [],
    );
  }
}