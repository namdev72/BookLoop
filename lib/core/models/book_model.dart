import 'package:cloud_firestore/cloud_firestore.dart';

enum BookCategory { academic, generic }
enum BookCondition { brandNew, likeNew, good, fair, poor }
enum BookStatus { available, requested, exchanged }

class BookModel {
  final String id;
  final String title;
  final String author;
  final BookCondition condition;
  final int tokenPrice;
  final BookCategory category;
  final String genre; // subject for academic, genre for generic
  final String coverUrl;
  final String ownerId;
  final String ownerName;
  final BookStatus status;
  final DateTime createdAt;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.condition,
    required this.tokenPrice,
    required this.category,
    required this.genre,
    required this.coverUrl,
    required this.ownerId,
    required this.ownerName,
    this.status = BookStatus.available,
    required this.createdAt,
  });

  factory BookModel.fromMap(Map<String, dynamic> map, String id) {
    return BookModel(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      condition: BookCondition.values.firstWhere(
        (e) => e.name == map['condition'],
        orElse: () => BookCondition.good,
      ),
      tokenPrice: map['tokenPrice'] ?? 1,
      category: BookCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => BookCategory.generic,
      ),
      genre: map['genre'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      status: BookStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookStatus.available,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'author': author,
        'condition': condition.name,
        'tokenPrice': tokenPrice,
        'category': category.name,
        'genre': genre,
        'coverUrl': coverUrl,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  String get conditionLabel {
    switch (condition) {
      case BookCondition.brandNew:
        return 'Brand New';
      case BookCondition.likeNew:
        return 'Like New';
      case BookCondition.good:
        return 'Good';
      case BookCondition.fair:
        return 'Fair';
      case BookCondition.poor:
        return 'Poor';
    }
  }

  BookModel copyWith({BookStatus? status}) {
    return BookModel(
      id: id,
      title: title,
      author: author,
      condition: condition,
      tokenPrice: tokenPrice,
      category: category,
      genre: genre,
      coverUrl: coverUrl,
      ownerId: ownerId,
      ownerName: ownerName,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
