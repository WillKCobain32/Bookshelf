
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
      'Frodo Bolseiro herda o Um Anel de seu tio Bilbo e descobre sua natureza maligna. Ele parte do Condado com Sam, Merry e Pippin, formando a Sociedade do Anel com Aragorn, Legolas e Gimli para proteger a jornada até que o grupo se dissolva após a traição de Boromir',
    ),
    LivroLog(
      id: 'b2',
      titulo: 'O Senhor Dos Aneis: As Duas Torres',
      autor: 'J.R.R. Tolkien',
      ano: 1954,
      genero: 'Fantasia Medieval',
      sinopse:
      ' A Sociedade se divide; Frodo e Sam são capturados por Gollum e seguem para Mordor, enquanto Aragorn, Legolas e Gimli perseguem orcs que sequestraram Merry e Pippin. Paralelamente, os hobbits libertam-se e se envolvem na guerra dos Ents contra Isengarde.',
    ),
    LivroLog(
      id: 'b3',
      titulo: 'O Hobbit',
      autor: 'J.R.R. Tolkien',
      ano: 1937,
      genero: 'Fantasia Medieval',
      sinopse:
      'Bilbo Bolseiro e levado a uma aventura inesperada pela Terra Media ao lado de anoes e um mago.',
    ),
    LivroLog(
      id: 'b4',
      titulo: 'O Senhor Dos Aneis: O Retorno Do Rei',
      autor: 'J.R.R. Tolkien',
      ano: 1955,
      genero: 'Fantasia Medieval',
      sinopse:
      'O clímax da saga onde Frodo e Sam enfrentam os últimos obstáculos rumo à Montanha da Perdição. Simultaneamente, Aragorn lidera os exércitos dos homens na batalha final por Gondor contra Sauron, culminando na destruição do Anel e na restauração da paz na Terra-média.',
    ),
    LivroLog(
      id: 'b5',
      titulo: 'O Guia do Mochileiro Das Galaxias ',
      autor: 'Douglas Adams',
      ano: 2007,
      genero: 'Ficção Cientifica',
      sinopse:
      'Arthur Dent é um inglês comum que tem seu dia destruído quando descobre que sua casa será demolida para uma rodovia e, em seguida, que o planeta Terra será destruído pelos alienígenas burocráticos Vogons para dar lugar a uma via interestelar.',
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
