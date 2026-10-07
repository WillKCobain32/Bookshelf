import 'package:flutter/material.dart';
import '../models/review.dart';
import '../repositories/review_repository.dart';


class ReviewFormViewModel extends ChangeNotifier {
  final ReviewRepository _reviewRepository;

  ReviewFormViewModel({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  bool isSaving = false;
  String? errorMessage;

  double rating = 0;
  bool relido = false;
  bool contemSpoiler = false;
  DateTime date = DateTime.now();

  void setRating(double value) {
    rating = value;
    errorMessage = null;
    notifyListeners();
  }

  void setRelido(bool value) {
    relido = value;
    notifyListeners();
  }

  void setContemSpoiler(bool value) {
    contemSpoiler = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void loadExisting(Review review) {
    rating = review.rating;
    relido = review.relido;
    contemSpoiler = review.contemSpoiler;
    date = review.date;
  }

  Future<bool> submit({
    required String? existingId,
    required String bookId,
    required String userId,
    required String text,
  }) async {
    if (rating <= 0) {
      errorMessage = 'Selecione uma nota de 0.5 a 5 estrelas.';
      notifyListeners();
      return false;
    }
    if (date.isAfter(DateTime.now())) {
      errorMessage = 'A data nao pode ser no futuro.';
      notifyListeners();
      return false;
    }
    if (text.length > 500) {
      errorMessage = 'A resenha deve ter no maximo 500 caracteres.';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (existingId == null) {
        await _reviewRepository.addReview(Review(
          id: '',
          livroId: bookId,
          userId: userId,
          rating: rating,
          text: text.trim(),
          date: date,
          relido: relido,
          contemSpoiler: contemSpoiler,
        ));
      } else {
        await _reviewRepository.updateReview(Review(
          id: existingId,
          livroId: bookId,
          userId: userId,
          rating: rating,
          text: text.trim(),
          date: date,
          relido: relido,
          contemSpoiler: contemSpoiler,
        ));
      }
      return true;
    } catch (_) {
      errorMessage = 'Nao foi possivel salvar a avaliacao. Tente novamente.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
