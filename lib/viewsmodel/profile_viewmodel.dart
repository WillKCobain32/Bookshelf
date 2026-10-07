import 'package:flutter/material.dart';
import '../repositories/review_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ReviewRepository _reviewRepository;

  ProfileViewModel({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  bool isLoading = false;
  int totalLivrosLidos = 0;
  double mediaNotas = 0;

  Future<void> loadStats(String userId) async {
    if (userId.isEmpty) return;
    isLoading = true;
    notifyListeners();
    final reviews = await _reviewRepository.getReviewsByUser(userId);
    totalLivrosLidos = reviews.length;
    mediaNotas = reviews.isEmpty
        ? 0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    isLoading = false;
    notifyListeners();
  }
}
