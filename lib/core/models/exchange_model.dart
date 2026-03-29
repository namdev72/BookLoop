import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeModel {
  final String id;
  final String requestId;
  final String bookId;
  final String bookTitle;
  final String bookCoverUrl;
  final String requesterId;
  final String requesterName;
  final String ownerId;
  final String ownerName;
  final int tokens;
  final DateTime createdAt;

  ExchangeModel({
    required this.id,
    required this.requestId,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.requesterId,
    required this.requesterName,
    required this.ownerId,
    required this.ownerName,
    required this.tokens,
    required this.createdAt,
  });

  factory ExchangeModel.fromMap(Map<String, dynamic> map, String id) {
    return ExchangeModel(
      id: id,
      requestId: map['requestId'] ?? '',
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      bookCoverUrl: map['bookCoverUrl'] ?? '',
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      tokens: map['tokens'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'requestId': requestId,
        'bookId': bookId,
        'bookTitle': bookTitle,
        'bookCoverUrl': bookCoverUrl,
        'requesterId': requesterId,
        'requesterName': requesterName,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'tokens': tokens,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
