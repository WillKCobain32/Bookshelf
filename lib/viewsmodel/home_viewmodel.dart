import 'package:flutter/material.dart';
import '../models/livro_log.dart';
import '../models/review.dart';
import '../repositories/livro_repository_mock.dart';
import '../repositories/review_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final  _bookRepository;
  final ReviewRepository _reviewRepository;

  HomeViewModel({
    required BookRepository bookRepository,
    required ReviewRepository reviewRepository,
  })  : _bookRepository = bookRepository,
        _reviewRepository = reviewRepository;

  bool isLoading = false;
  String? errorMessage;
  List<LivroLog> featuredBooks = [];
  List<Review> recentActivity = [];

  Future<void> load(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      featuredBooks = await _bookRepository.getAllBooks();
      recentActivity =
      userId.isEmpty ? [] : await _reviewRepository.getReviewsByUser(userId);
    } catch (_) {
      errorMessage = 'Nao foi possivel carregar o feed.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
