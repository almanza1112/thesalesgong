import 'dart:convert';

class AdminSigningUp {
  final String email;
  final String password;
  final String displayName;
  final String? teamName;
  final List<String>? teamEmailAddresses;

  AdminSigningUp({
    required this.email,
    required this.password,
    required this.displayName,
    this.teamName,
    this.teamEmailAddresses
  });

  AdminSigningUp copyWith({
    String? email,
    String? password,
    String? displayName,
    String? teamName,
    List<String>? teamEmailAddresses,
  }) {
    return AdminSigningUp(
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      teamName: teamName ?? this.teamName,
      teamEmailAddresses: teamEmailAddresses ?? this.teamEmailAddresses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emailAddress': email,
      'password': password,
      'teamName': teamName,
      'teamEmailAddresses': teamEmailAddresses,
    };
  }

  factory AdminSigningUp.fromMap(Map<String, dynamic> map) {
    return AdminSigningUp(
      email: map['emailAddress'] ?? '',
      password: map['password'] ?? '',
      displayName: map['displayName'] ?? '',
      teamName: map['teamName'],
      teamEmailAddresses: map['teamEmailAddresses'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminSigningUp.fromJson(String source) => AdminSigningUp.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdminSignigUp(emailAddress: $email, password: $password, teamName: $teamName, teamEmailAddresses: $teamEmailAddresses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AdminSigningUp &&
      other.email == email &&
      other.password == password &&
      other.teamName == teamName &&
      other.teamEmailAddresses == teamEmailAddresses;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      password.hashCode ^
      teamName.hashCode ^
      teamEmailAddresses.hashCode;
  }
}
