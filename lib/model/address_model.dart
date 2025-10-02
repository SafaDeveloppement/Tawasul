class AddressModel {
  final int? id;
  final int idCustomer;
  final String firstname;
  final String lastname;
  final String address1;
  final String? address2;
  final String city;
  final String postcode;
  final int idState;
  final String? phone;
  final String? alias;
  final String? country;
  final String? stateName;
  final DateTime? dateAdd;
  final DateTime? dateUpd;

  AddressModel({
    this.id,
    required this.idCustomer,
    required this.firstname,
    required this.lastname,
    required this.address1,
    this.address2,
    required this.city,
    required this.postcode,
    required this.idState,
    this.phone,
    this.alias = 'Home Address',
    this.country,
    this.stateName,
    this.dateAdd,
    this.dateUpd,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? json['id_address'],
      idCustomer: json['id_customer'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      idState: json['id_state'] ?? 0,
      phone: json['phone'] ?? json['phone_mobile'] ?? '',
      alias: json['alias'] ?? 'Home Address',
      country: json['country'],
      stateName: json['state'],
      dateAdd: json['date_add'] != null 
          ? DateTime.parse(json['date_add'])
          : null,
      dateUpd: json['date_upd'] != null
          ? DateTime.parse(json['date_upd'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'id_customer': idCustomer,
      'firstname': firstname,
      'lastname': lastname,
      'address1': address1,
      if (address2 != null && address2!.isNotEmpty) 'address2': address2,
      'city': city,
      'postcode': postcode,
      'id_state': idState,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      'alias': alias,
    };
  }

  String get displayAddress {
    return '$address1, $city, ${stateName ?? ''} $postcode';
  }

  bool get isValid {
    return firstname.isNotEmpty &&
        lastname.isNotEmpty &&
        address1.isNotEmpty &&
        city.isNotEmpty &&
        postcode.isNotEmpty &&
        idState != 0;
  }

  // Create from API response
  factory AddressModel.fromApiResponse(Map<String, dynamic> response) {
    final addressData = response['address'] ?? response;
    return AddressModel.fromJson(addressData);
  }

  // Copy with method for updates
  AddressModel copyWith({
    int? id,
    int? idCustomer,
    String? firstname,
    String? lastname,
    String? address1,
    String? address2,
    String? city,
    String? postcode,
    int? idState,
    String? phone,
    String? alias,
  }) {
    return AddressModel(
      id: id ?? this.id,
      idCustomer: idCustomer ?? this.idCustomer,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      idState: idState ?? this.idState,
      phone: phone ?? this.phone,
      alias: alias ?? this.alias,
      dateAdd: dateAdd,
      dateUpd: dateUpd,
    );
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, firstname: $firstname, lastname: $lastname, city: $city, state: $idState)';
  }
}