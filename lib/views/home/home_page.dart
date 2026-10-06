import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewsmodel/auth_viewmodel.dart';
import '../../viewsmodel/home_viewmodel.dart';
import '../../widgets/book_cover.dart';
import '../book/book_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
      context.read<HomeViewModel>().load(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    final user = context.watch<AuthViewModel>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Bookish')),
      body: RefreshIndicator(
        onRefresh: () => context.read<HomeViewModel>().load(user?.id ?? ''),
        child: homeVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : homeVM.errorMessage != null
            ? Center(child: Text(homeVM.errorMessage!))
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Ola, ${user?.nome.split(' ').first ?? ''}!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Em destaque', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: homeVM.featuredBooks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final book = homeVM.featuredBooks[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => BookDetailPage(bookId: book.id)),
                    ),
                    child: BookCover(book: book),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text('Sua atividade recente', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (homeVM.recentActivity.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                    'Voce ainda nao avaliou nenhum livro. Explore e comece seu diario!'),
              )
            else
              ...homeVM.recentActivity.take(5).map((review) {
                final matches = homeVM.featuredBooks.where((b) => b.id == review.livroId);
                if (matches.isEmpty) return const SizedBox.shrink();
                final book = matches.first;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: BookCover(book: book, width: 40, height: 60),
                  title: Text(book.titulo),
                  subtitle: Text('Nota: ${review.rating.toStringAsFixed(1)} \u2605'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BookDetailPage(bookId: book.id)),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
