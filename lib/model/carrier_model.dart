class Carrier {
  final int idCarrier;
  final String name;
  final String delay;
  final String price;
  final List<RelayGroup>? relayGroups;

  Carrier({
    required this.idCarrier,
    required this.name,
    required this.delay,
    required this.price,
    this.relayGroups,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      idCarrier: json['id_carrier'] ?? 0,
      name: json['name'] ?? '',
      delay: json['delay'] ?? '',
      price: json['price'] ?? '',
      relayGroups:
          json['relay_groups'] != null
              ? (json['relay_groups'] as List)
                  .map((group) => RelayGroup.fromJson(group))
                  .toList()
              : null,
    );
  }

  bool get hasRelayGroups => relayGroups != null && relayGroups!.isNotEmpty;
}

class RelayGroup {
  final String idRelayGroup;
  final String relayGroupName;
  final String cityId;
  final String idLang;

  RelayGroup({
    required this.idRelayGroup,
    required this.relayGroupName,
    required this.cityId,
    required this.idLang,
  });

  factory RelayGroup.fromJson(Map<String, dynamic> json) {
    return RelayGroup(
      idRelayGroup: json['id_relay_group']?.toString() ?? '',
      relayGroupName: json['relay_group_name'] ?? '',
      cityId: json['city_id']?.toString() ?? '',
      idLang: json['id_lang']?.toString() ?? '',
    );
  }
}
