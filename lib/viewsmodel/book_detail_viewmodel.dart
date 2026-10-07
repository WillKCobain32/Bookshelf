import 'package:flutter/material.dart';
import '../models/livro_log.dart';
import '../models/review.dart';
import '../repositories/livro_repository_mock.dart';
import '../repositories/review_repository.dart';

class BookDetailViewModel extends ChangeNotifier {
  final BookRepository _bookRepository;
  final ReviewRepository _reviewRepository;

  BookDetailViewModel({
    required BookRepository bookRepository,
    required ReviewRepository reviewRepository,
  })  : _bookRepository = bookRepository,
        _reviewRepository = reviewRepository;

  bool isLoading = false;
  String? errorMessage;
  LivroLog? book;
  List<Review> reviews = [];

  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }

  Future<void> load(String bookId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      book = await _bookRepository.getBookById(bookId);
      if (book == null) {
        errorMessage = 'Livro nao encontrado.';
      } else {
        reviews = await _reviewRepository.getReviewsByBook(bookId);
      }
    } catch (_) {
      errorMessage = 'Erro ao carregar o livro.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
