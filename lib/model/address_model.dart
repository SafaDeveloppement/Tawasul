// address_model.dart
class Address {
  final String code;
  final String address1;
  final String? address2;
  final String firstName;
  final String lastName;
  final String city;
  final String postcode;
  final String phone;

  Address({
    required this.code,
    required this.address1,
    this.address2,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.postcode,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      code: json['code']?.toString() ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'address1': address1,
      'address2': address2,
      'firstName': firstName,
      'lastName': lastName,
      'city': city,
      'postcode': postcode,
      'phone': phone,
    };
  }
}
