import 'package:flutter/material.dart';
import '../core/models/book_model.dart';
import '../core/services/book_service.dart';
import '../core/services/cloudinary_service.dart';
import 'dart:io';

class BookProvider extends ChangeNotifier {
  final BookService _bookService = BookService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  bool _isUploading = false;
  String? _uploadError;

  bool get isUploading => _isUploading;
  String? get uploadError => _uploadError;

  Stream<List<BookModel>> getAvailableBooks() =>
      _bookService.getAvailableBooks();

  Stream<List<BookModel>> getBooksByCategory(BookCategory cat) =>
      _bookService.getBooksByCategory(cat);

  Stream<List<BookModel>> getBooksByGenre(String genre) =>
      _bookService.getBooksByGenre(genre);

  Stream<List<BookModel>> getUserBooks(String uid) =>
      _bookService.getUserBooks(uid);

  Future<bool> addBook({
    required BookModel book,
    File? imageFile,
  }) async {
    _isUploading = true;
    _uploadError = null;
    notifyListeners();

    String coverUrl = book.coverUrl;

    if (imageFile != null) {
      final url = await _cloudinaryService.uploadImage(imageFile);
      if (url != null) {
        coverUrl = url;
      } else {
        _uploadError = 'Image upload failed. Book saved without cover.';
      }
    }

    final finalBook = BookModel(
      id: '',
      title: book.title,
      author: book.author,
      condition: book.condition,
      tokenPrice: book.tokenPrice,
      category: book.category,
      genre: book.genre,
      coverUrl: coverUrl,
      ownerId: book.ownerId,
      ownerName: book.ownerName,
      createdAt: DateTime.now(),
    );

    await _bookService.addBook(finalBook);
    _isUploading = false;
    notifyListeners();
    return true;
  }

  Future<bool> deleteBook(String bookId, String ownerId) async {
    try {
      await _bookService.deleteBook(bookId, ownerId);
      notifyListeners();
      return true;
    } catch (e) {
      _uploadError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> reuploadBook(String bookId) async {
    try {
      await _bookService.reuploadBook(bookId);
      notifyListeners();
      return true;
    } catch (e) {
      _uploadError = e.toString();
      notifyListeners();
      return false;
    }
  }
}
