class LodgeSession {
  final int id;
  final String date;
  final String type;
  final String degree;
  final String rite;
  final String? summary;

  LodgeSession({
    required this.id,
    required this.date,
    required this.type,
    required this.degree,
    required this.rite,
    this.summary,
  });

  factory LodgeSession.fromJson(Map<String, dynamic> json) {
    return LodgeSession(
      id: json['id'] as int,
      date: json['date'] as String,
      type: json['type'] as String,
      degree: json['degree'] as String,
      rite: json['rite'] as String,
      summary: json['summary'] as String?,
    );
  }
}
