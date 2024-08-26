// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String username;
  final String phone;
  final String profileURl;
  final String bio;
  UserModel({
    required this.id,
    required this.username,
    required this.phone,
    required this.profileURl,
    required this.bio,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? phone,
    String? profileURl,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      profileURl: profileURl ?? this.profileURl,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'phone': phone,
      'profileURl': profileURl,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      username: map['username'] as String,
      phone: map['phone'] as String,
      profileURl: map['profileURl'] as String,
      bio: map['bio'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, phone: $phone, profileURl: $profileURl, bio: $bio)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.phone == phone &&
        other.profileURl == profileURl &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        phone.hashCode ^
        profileURl.hashCode ^
        bio.hashCode;
  }
}
