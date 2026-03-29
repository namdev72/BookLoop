import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';
import '../models/exchange_model.dart';
import '../models/book_model.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _requests => _firestore.collection('requests');
  CollectionReference get _exchanges => _firestore.collection('exchanges');
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _books => _firestore.collection('books');

  Future<void> createRequest(RequestModel request) async {
    final docRef = _requests.doc();
    final newReq = RequestModel(
      id: docRef.id,
      bookId: request.bookId,
      bookTitle: request.bookTitle,
      bookCoverUrl: request.bookCoverUrl,
      tokenPrice: request.tokenPrice,
      requesterId: request.requesterId,
      requesterName: request.requesterName,
      ownerId: request.ownerId,
      ownerName: request.ownerName,
      status: RequestStatus.pending,
      createdAt: DateTime.now(),
    );
    await docRef.set(newReq.toMap());
  }

  Future<void> acceptRequest(RequestModel request) async {
    // Just update request status to accepted
    await _requests.doc(request.id).update({'status': 'accepted'});
  }

  Future<void> completeExchange(RequestModel request) async {
    // 1. Verify requester still has enough tokens
    final requesterDoc = await _users.doc(request.requesterId).get();
    if (!requesterDoc.exists) throw Exception("Requester not found.");
    
    final requesterData = requesterDoc.data() as Map<String, dynamic>;
    final currentBalance = requesterData['tokenBalance'] as int? ?? 0;
    
    if (currentBalance < request.tokenPrice) {
      throw Exception("You do not have enough tokens to complete this exchange.");
    }

    final batch = _firestore.batch();

    // Update request status to completed
    batch.update(_requests.doc(request.id), {'status': 'completed'});

    // Deduct tokens from requester
    batch.update(_users.doc(request.requesterId), {
      'tokenBalance': FieldValue.increment(-request.tokenPrice),
    });

    // Add tokens to owner
    batch.update(_users.doc(request.ownerId), {
      'tokenBalance': FieldValue.increment(request.tokenPrice),
    });

    // Mark book as exchanged
    batch.update(_books.doc(request.bookId), {'status': 'exchanged'});

    // Create exchange record
    final exchangeRef = _exchanges.doc();
    final exchange = ExchangeModel(
      id: exchangeRef.id,
      requestId: request.id,
      bookId: request.bookId,
      bookTitle: request.bookTitle,
      bookCoverUrl: request.bookCoverUrl,
      requesterId: request.requesterId,
      requesterName: request.requesterName,
      ownerId: request.ownerId,
      ownerName: request.ownerName,
      tokens: request.tokenPrice,
      createdAt: DateTime.now(),
    );
    batch.set(exchangeRef, exchange.toMap());

    await batch.commit();
  }

  Future<void> rejectRequest(String requestId) async {
    await _requests.doc(requestId).update({'status': 'rejected'});
  }

  Stream<List<RequestModel>> getMyRequests(String uid) {
    return _requests
        .where('requesterId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RequestModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Stream<List<RequestModel>> getIncomingRequests(String uid) {
    return _requests
        .where('ownerId', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => RequestModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Stream<List<ExchangeModel>> getCompletedExchanges(String uid) {
    return _exchanges
        .where('requesterId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ExchangeModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Stream<List<ExchangeModel>> getOwnerExchanges(String uid) {
    return _exchanges
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ExchangeModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  // Check if user already has a pending request for this book
  Future<bool> hasExistingRequest(String bookId, String requesterId) async {
    final snap = await _requests
        .where('bookId', isEqualTo: bookId)
        .where('requesterId', isEqualTo: requesterId)
        .where('status', isEqualTo: 'pending')
        .get();
    return snap.docs.isNotEmpty;
  }
}
