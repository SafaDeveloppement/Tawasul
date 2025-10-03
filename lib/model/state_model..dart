class StateModel {
  final int idState;
  final int idCountry;
  final String isoCode;
  final String name;
  final int active;

  StateModel({
    required this.idState,
    required this.idCountry,
    required this.isoCode,
    required this.name,
    required this.active,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      idState: json['id_state'] ?? 0,
      idCountry: json['id_country'] ?? 0,
      isoCode: json['iso_code'] ?? '',
      name: json['name'] ?? '',
      active: json['active'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_state': idState,
      'id_country': idCountry,
      'iso_code': isoCode,
      'name': name,
      'active': active,
    };
  }
}