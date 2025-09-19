class Address {
  int id;
  String firstName;
  String lastName;
  String street;
  String city;
  String zip;
  String phone;
  double? latitude;
  double? longitude;

  Address({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.zip,
    required this.phone,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      zip: json['zip'] ?? '',
      phone: json['phone'] ?? '',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "street": street,
      "city": city,
      "zip": zip,
      "phone": phone,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
