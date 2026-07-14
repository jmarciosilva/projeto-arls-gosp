class Member {
  final int id;
  final String status;
  final String name;
  final String? nickname;
  final String? cim;
  final String? degree;
  final String? position;
  final String? admissionDate;
  final String? admissionType;

  Member({
    required this.id,
    required this.status,
    required this.name,
    this.nickname,
    this.cim,
    this.degree,
    this.position,
    this.admissionDate,
    this.admissionType,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as int,
      status: json['status'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String?,
      cim: json['cim'] as String?,
      degree: json['degree'] as String?,
      position: json['position'] as String?,
      admissionDate: json['admission_date'] as String?,
      admissionType: json['admission_type'] as String?,
    );
  }
}
