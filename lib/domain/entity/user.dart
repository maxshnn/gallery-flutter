import 'dart:convert';

class User {
  int id;
  String? email;
  bool? enabled;
  String? phone;
  String? fullName;
  String? username;
  String? birthday;
  List<String>? roles;
  User({
    required this.id,
    this.email,
    this.enabled,
    this.phone,
    this.fullName,
    this.username,
    this.birthday,
    this.roles,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (email != null) {
      result.addAll({'email': email});
    }
    if (enabled != null) {
      result.addAll({'enabled': enabled});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (fullName != null) {
      result.addAll({'fullName': fullName});
    }
    if (username != null) {
      result.addAll({'username': username});
    }
    if (birthday != null) {
      result.addAll({'birthday': birthday});
    }
    if (roles != null) {
      result.addAll({'roles': roles});
    }

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      email: map['email'],
      enabled: map['enabled'],
      phone: map['phone'],
      fullName: map['fullName'],
      username: map['username'],
      birthday: map['birthday'],
      roles: List<String>.from(map['roles'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
