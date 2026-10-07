import 'package:flutter/material.dart';
import '../models/livro_log.dart';
import '../models/review.dart';
import '../repositories/livro_repository_mock.dart';
import '../repositories/review_repository.dart';

/// Uma linha do diario: a avaliacao + o livro avaliado.
class DiaryEntry {
  final Review review;
  final LivroLog? book;

  const DiaryEntry({required this.review, required this.book});
}

class DiaryViewModel extends ChangeNotifier {
  final BookRepository _bookRepository;
  final ReviewRepository _reviewRepository;

  DiaryViewModel({
    required BookRepository bookRepository,
    required ReviewRepository reviewRepository,
  })  : _bookRepository = bookRepository,
        _reviewRepository = reviewRepository;

  bool isLoading = false;
  String? errorMessage;
  List<DiaryEntry> entries = [];

  Future<void> load(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (userId.isEmpty) {
        entries = [];
      } else {
        final reviews = await _reviewRepository.getReviewsByUser(userId);
        entries = await Future.wait(reviews.map((r) async {
          final book = await _bookRepository.getBookById(r.livroId);
          return DiaryEntry(review: r, book: book);
        }));
      }
    } catch (_) {
      errorMessage = 'Nao foi possivel carregar o diario.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeEntry(String reviewId, String userId) async {
    // Remove da lista na hora: o Dismissible exige que o item saia da arvore.
    entries = entries.where((e) => e.review.id != reviewId).toList();
    notifyListeners();
    try {
      await _reviewRepository.deleteReview(reviewId);
    } catch (_) {
      errorMessage = 'Nao foi possivel remover a avaliacao.';
      await load(userId);
    }
  }
}