import 'package:flutter/material.dart';
import '../models/livro_log.dart';
import '../repositories/livro_repository_mock.dart';

class SearchViewModel extends ChangeNotifier {
  final BookRepository _bookRepository;

  SearchViewModel({required BookRepository bookRepository})
      : _bookRepository = bookRepository;

  bool isLoading = false;
  String? errorMessage;
  List<LivroLog> results = [];
  String query = '';

  Future<void> search(String value) async {
    query = value;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      results = await _bookRepository.searchBooks(value);
    } catch (_) {
      errorMessage = 'Erro ao buscar livros.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAll() => search('');
}
