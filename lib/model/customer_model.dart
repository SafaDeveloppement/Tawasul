class User {
  final int idCustomer;
  final int gender;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String birthday;
  final String cardNumber;

  User({
    required this.idCustomer,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.birthday,
    required this.cardNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idCustomer: json['idCustomer'] ?? 0,
      gender: json['gender'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      birthday: json['birthday'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCustomer': idCustomer,
      'gender': gender,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
      'birthday': birthday,
      'cardNumber': cardNumber,
    };
  }

  String get fullName => '$firstName $lastName';

  bool get isValid => idCustomer > 0 && email.isNotEmpty;
 
}
