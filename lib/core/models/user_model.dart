import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final int tokenBalance;
  final int booksListed;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.tokenBalance = 10, // starting tokens
    this.booksListed = 0,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      tokenBalance: map['tokenBalance'] ?? 10,
      booksListed: map['booksListed'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'tokenBalance': tokenBalance,
        'booksListed': booksListed,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  UserModel copyWith({
    String? name,
    String? email,
    int? tokenBalance,
    int? booksListed,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      tokenBalance: tokenBalance ?? this.tokenBalance,
      booksListed: booksListed ?? this.booksListed,
      createdAt: createdAt,
    );
  }
}
