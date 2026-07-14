import 'lodge.dart';
import 'member.dart';

class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? whatsapp;
  final String role;
  final Lodge? lodge;
  final Member? member;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.whatsapp,
    required this.role,
    this.lodge,
    this.member,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final lodgeJson = json['lodge'] as Map<String, dynamic>?;
    final memberJson = json['member'] as Map<String, dynamic>?;

    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      whatsapp: json['whatsapp'] as String?,
      role: json['role'] as String,
      lodge: (lodgeJson != null && lodgeJson.isNotEmpty)
          ? Lodge.fromJson(lodgeJson)
          : null,
      member: (memberJson != null && memberJson.isNotEmpty)
          ? Member.fromJson(memberJson)
          : null,
    );
  }
}
