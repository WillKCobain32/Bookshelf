import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewsmodel/search_viewmodel.dart';
import '../../widgets/book_cover.dart';
import '../book/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadAll();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onChanged: (value) => context.read<SearchViewModel>().search(value),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Buscar por titulo, autor ou genero...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
      body: searchVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchVM.errorMessage != null
          ? Center(child: Text(searchVM.errorMessage!))
          : searchVM.results.isEmpty
          ? const Center(child: Text('Nenhum livro encontrado.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: searchVM.results.length,
        itemBuilder: (context, index) {
          final book = searchVM.results[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: BookCover(book: book, width: 48, height: 68),
              title: Text(book.titulo),
              subtitle: Text('${book.autor} \u2022 ${book.ano}'),
              trailing: Text(book.genero, style: const TextStyle(fontSize: 12)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => BookDetailPage(bookId: book.id)),
              ),
            ),
          );
        },
      ),
    );
  }
}
