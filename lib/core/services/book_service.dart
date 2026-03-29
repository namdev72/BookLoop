import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _books => _firestore.collection('books');

  Future<void> addBook(BookModel book) async {
    final docRef = _books.doc();
    final newBook = BookModel(
      id: docRef.id,
      title: book.title,
      author: book.author,
      condition: book.condition,
      tokenPrice: book.tokenPrice,
      category: book.category,
      genre: book.genre,
      coverUrl: book.coverUrl,
      ownerId: book.ownerId,
      ownerName: book.ownerName,
      status: BookStatus.available,
      createdAt: DateTime.now(),
    );
    await docRef.set(newBook.toMap());

    // Increment booksListed
    await _firestore.collection('users').doc(book.ownerId).update({
      'booksListed': FieldValue.increment(1),
    });
  }

  Stream<List<BookModel>> getAvailableBooks() {
    return _books
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => BookModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Stream<List<BookModel>> getBooksByCategory(BookCategory category) {
    return _books
        .where('status', isEqualTo: 'available')
        .where('category', isEqualTo: category.name)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => BookModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Stream<List<BookModel>> getBooksByGenre(String genre) {
    return _books
        .where('status', isEqualTo: 'available')
        .where('genre', isEqualTo: genre)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => BookModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Stream<List<BookModel>> getUserBooks(String uid) {
    return _books
        .where('ownerId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => BookModel.fromMap(d.data() as Map<String, dynamic>, d.id))
            .toList());
  }

  Future<void> updateBookStatus(String bookId, BookStatus status) async {
    await _books.doc(bookId).update({'status': status.name});
  }

  Future<BookModel?> getBookById(String bookId) async {
    final doc = await _books.doc(bookId).get();
    if (doc.exists && doc.data() != null) {
      return BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
