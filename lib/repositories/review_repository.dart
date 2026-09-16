import '../models/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviewsByUser(String userId);
  Future<List<Review>> getReviewsByBook(String bookId);
  Future<Review> addReview(Review review);
  Future<Review> updateReview(Review review);
  Future<void> deleteReview(String id);
}

class InMemoryReviewRepository implements ReviewRepository {
  static final List<Review> _reviews = [];
  static int _counter = 0;

  @override
  Future<List<Review>> getReviewsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final list = _reviews.where((r) => r.userId == userId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<List<Review>> getReviewsByBook(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final list = _reviews.where((r) => r.livroId == bookId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<Review> addReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _counter++;
    final withId = review.copyWith(id: 'r$_counter');
    _reviews.add(withId);
    return withId;
  }

  @override
  Future<Review> updateReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _reviews.indexWhere((r) => r.id == review.id);
    if (index == -1) {
      throw Exception('Avaliacao nao encontrada.');
    }
    _reviews[index] = review;
    return review;
  }

  @override
  Future<void> deleteReview(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _reviews.removeWhere((r) => r.id == id);
  }
}
