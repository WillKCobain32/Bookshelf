import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewsmodel/auth_viewmodel.dart';
import '../../viewsmodel/diary_viewmodel.dart';
import '../../widgets/book_cover.dart';
import '../../widgets/star_rating.dart';
import '../book/book_detail_page.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
      context.read<DiaryViewModel>().load(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DiaryViewModel>();
    final userId = context.watch<AuthViewModel>().currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Meu diario')),
      body: RefreshIndicator(
        onRefresh: () => context.read<DiaryViewModel>().load(userId),
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.entries.isEmpty
            ? ListView(
          children: const [
            Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Seu diario esta vazio. Avalie um livro para comecar a registrar sua jornada de leitura!',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.entries.length,
          itemBuilder: (context, index) {
            final entry = vm.entries[index];
            if (entry.book == null) return const SizedBox.shrink();
            return Dismissible(
              key: ValueKey(entry.review.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) =>
                  context.read<DiaryViewModel>().removeEntry(entry.review.id, userId),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: BookCover(book: entry.book!, width: 44, height: 64),
                  title: Text(entry.book!.titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StarRating(rating: entry.review.rating, size: 14),
                      Text(
                        '${entry.review.date.day.toString().padLeft(2, '0')}/${entry.review.date.month.toString().padLeft(2, '0')}/${entry.review.date.year}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => BookDetailPage(bookId: entry.book!.id)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
