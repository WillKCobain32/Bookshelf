
import '../models/livro_log.dart';

abstract class BookRepository {
  Future<List<LivroLog>> getAllBooks();
  Future<LivroLog?> getBookById(String id);
  Future<List<LivroLog>> searchBooks(String query);
}


class InMemoryBookRepository implements BookRepository {
  static final List<LivroLog> _books = [
    LivroLog(
      id: 'b1',
      titulo: 'O Senhor Dos Aneis: A Sociedade Do Anel',
      autor: 'J.R.R. Tolkien',
      ano: 1954,
      genero: 'Fantasia Medieval',
      sinopse:
      'Bentinho narra sua infancia, o amor por Capitu e a desconfianca que consome sua vida adulta.',
    ),
    LivroLog(
      id: 'b2',
      titulo: '1984',
      autor: 'George Orwell',
      ano: 1949,
      genero: 'Ficcao Cientifica',
      sinopse:
      'Um retrato sombrio de um regime totalitario que vigia e controla todos os cidadaos.',
    ),
    LivroLog(
      id: 'b3',
      titulo: 'O Hobbit',
      autor: 'J.R.R. Tolkien',
      ano: 1937,
      genero: 'Fantasia',
      sinopse:
      'Bilbo Bolseiro e levado a uma aventura inesperada pela Terra Media ao lado de anoes e um mago.',
    ),
    LivroLog(
      id: 'b4',
      titulo: 'A Revolucao dos Bichos',
      autor: 'George Orwell',
      ano: 1945,
      genero: 'Satira',
      sinopse:
      'Animais de uma fazenda se rebelam contra seus donos humanos em busca de igualdade.',
    ),
    LivroLog(
      id: 'b5',
      titulo: 'Cem Anos de Solidao',
      autor: 'Gabriel Garcia Marquez',
      ano: 1967,
      genero: 'Realismo Magico',
      sinopse:
      'A saga de varias geracoes da familia Buendia na cidade ficticia de Macondo.',
    ),
    LivroLog(
      id: 'b6',
      titulo: 'O Pequeno Principe',
      autor: 'Antoine de Saint-Exupery',
      ano: 1943,
      genero: 'Fabula',
      sinopse:
      'Um piloto perdido no deserto encontra um pequeno principe vindo de outro planeta.',
    ),
  ];

  @override
  Future<List<LivroLog>> getAllBooks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_books);
  }

  @override
  Future<LivroLog?> getBookById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<LivroLog>> searchBooks(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return List.unmodifiable(_books);
    return _books
        .where((b) =>
    b.titulo.toLowerCase().contains(q) ||
        b.autor.toLowerCase().contains(q) ||
        b.genero.toLowerCase().contains(q))
        .toList();
  }
}
