import 'package:flutter/material.dart';
import '../core/models/request_model.dart';
import '../core/models/exchange_model.dart';
import '../core/services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  final RequestService _requestService = RequestService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<List<RequestModel>> getMyRequests(String uid) =>
      _requestService.getMyRequests(uid);

  Stream<List<RequestModel>> getIncomingRequests(String uid) =>
      _requestService.getIncomingRequests(uid);

  Stream<List<ExchangeModel>> getCompletedExchanges(String uid) =>
      _requestService.getCompletedExchanges(uid);

  Stream<List<ExchangeModel>> getOwnerExchanges(String uid) =>
      _requestService.getOwnerExchanges(uid);

  Future<bool> createRequest(RequestModel request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final exists = await _requestService.hasExistingRequest(
          request.bookId, request.requesterId);
      if (exists) {
        _error = 'You already have a pending request for this book.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      await _requestService.createRequest(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> acceptRequest(RequestModel request) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _requestService.acceptRequest(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeExchange(RequestModel request) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _requestService.completeExchange(request);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> rejectRequest(String requestId) async {
    await _requestService.rejectRequest(requestId);
  }
}
