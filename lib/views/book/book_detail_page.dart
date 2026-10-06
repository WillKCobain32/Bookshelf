import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/review.dart';
import '../../repositories/livro_repository_mock.dart';
import '../../repositories/review_repository.dart';
import '../../viewsmodel/auth_viewmodel.dart';
import '../../viewsmodel/book_detail_viewmodel.dart';
import '../../viewsmodel/review_form_ciewmodel.dart';
import '../../widgets/book_cover.dart';
import '../../widgets/star_rating.dart';
import '../review/review_form_page.dart';

class BookDetailPage extends StatelessWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookDetailViewModel>(
      create: (ctx) => BookDetailViewModel(
        bookRepository: ctx.read<BookRepository>(),
        reviewRepository: ctx.read<ReviewRepository>(),
      )..load(bookId),
      child: _BookDetailView(bookId: bookId),
    );
  }
}

class _BookDetailView extends StatelessWidget {
  final String bookId;

  const _BookDetailView({required this.bookId});

  Future<void> _openReviewForm(BuildContext context, Review? existing) async {
    final vm = context.read<BookDetailViewModel>();
    final reviewRepo = context.read<ReviewRepository>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<ReviewFormViewModel>(
          create: (_) => ReviewFormViewModel(reviewRepository: reviewRepo),
          child: ReviewFormPage(bookId: bookId, existingReview: existing),
        ),
      ),
    );
    await vm.load(bookId);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookDetailViewModel>();
    final userId = context.watch<AuthViewModel>().currentUser?.id ?? '';
    final book = vm.book;

    Review? mine;
    for (final r in vm.reviews) {
      if (r.userId == userId) {
        mine = r;
        break;
      }
    }

    Widget body;
    if (vm.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (vm.errorMessage != null || book == null) {
      body = Center(child: Text(vm.errorMessage ?? 'Livro nao encontrado.'));
    } else {
      body = ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: BookCover(book: book, width: 120, height: 170)),
          const SizedBox(height: 16),
          Text(
            book.titulo,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '${book.autor} \u2022 ${book.ano}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Center(child: Chip(label: Text(book.genero))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StarRating(rating: vm.averageRating, size: 22),
              const SizedBox(width: 8),
              Text(vm.reviews.isEmpty
                  ? 'Sem avaliacoes'
                  : '${vm.averageRating.toStringAsFixed(1)} (${vm.reviews.length})'),
            ],
          ),
          const SizedBox(height: 16),
          Text(book.sinopse),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(mine == null ? Icons.rate_review_outlined : Icons.edit_outlined),
            label: Text(mine == null ? 'Avaliar este livro' : 'Editar minha avaliacao'),
            onPressed: () => _openReviewForm(context, mine),
          ),
          const SizedBox(height: 24),
          Text('Avaliacoes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (vm.reviews.isEmpty)
            const Text('Ninguem avaliou este livro ainda.')
          else
            ...vm.reviews.map(
                  (r) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: StarRating(rating: r.rating, size: 16),
                  subtitle: r.text.isEmpty
                      ? null
                      : Text(r.contemSpoiler ? 'Contem spoilers' : r.text),
                  trailing: r.relido ? const Icon(Icons.replay, size: 18) : null,
                ),
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(book?.titulo ?? 'Livro')),
      body: body,
    );
  }
}