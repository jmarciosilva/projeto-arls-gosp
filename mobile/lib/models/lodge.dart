class Lodge {
  final int id;
  final String name;
  final String number;
  final String rite;
  final String city;
  final String state;

  Lodge({
    required this.id,
    required this.name,
    required this.number,
    required this.rite,
    required this.city,
    required this.state,
  });

  factory Lodge.fromJson(Map<String, dynamic> json) {
    return Lodge(
      id: json['id'] as int,
      name: json['name'] as String,
      number: json['number'] as String,
      rite: json['rite'] as String,
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }
}
