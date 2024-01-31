import 'dart:convert';

class TeamMember {
  final String name;
  final String email;
  final String role;

  TeamMember({
    required this.name,
    required this.email,
    required this.role,
  });

  TeamMember copyWith({
    String? name,
    String? email,
    String? role,
  }) {
    return TeamMember(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamMember.fromJson(String source) => TeamMember.fromMap(json.decode(source));

  @override
  String toString() => 'TeamMember(name: $name, email: $email, role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TeamMember &&
      other.name == name &&
      other.email == email &&
      other.role == role;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ role.hashCode;
}
