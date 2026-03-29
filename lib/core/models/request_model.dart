import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus { pending, accepted, rejected, completed }

class RequestModel {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookCoverUrl;
  final int tokenPrice;
  final String requesterId;
  final String requesterName;
  final String ownerId;
  final String ownerName;
  final RequestStatus status;
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.tokenPrice,
    required this.requesterId,
    required this.requesterName,
    required this.ownerId,
    required this.ownerName,
    this.status = RequestStatus.pending,
    required this.createdAt,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id,
      bookId: map['bookId'] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      bookCoverUrl: map['bookCoverUrl'] ?? '',
      tokenPrice: map['tokenPrice'] ?? 0,
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      status: RequestStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RequestStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'bookId': bookId,
        'bookTitle': bookTitle,
        'bookCoverUrl': bookCoverUrl,
        'tokenPrice': tokenPrice,
        'requesterId': requesterId,
        'requesterName': requesterName,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
