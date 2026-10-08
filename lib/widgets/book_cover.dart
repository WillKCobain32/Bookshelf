import 'package:flutter/material.dart';
import '../models/livro_log.dart';

/// Capa "sintetica" gerada a partir do titulo do livro (cor + iniciais/titulo).
/// Na Parte 2, este widget pode ser adaptado para exibir uma imagem real
/// (Image.network / Image.asset) assim que houver uma URL/arquivo de capa.
class BookCover extends StatelessWidget {
  final LivroLog book;
  final double width;
  final double height;

  const BookCover({super.key, required this.book, this.width = 90, this.height = 130});

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFromTitle(book.titulo);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        book.titulo,
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  List<Color> _colorsFromTitle(String title) {
    final hash = title.codeUnits.fold<int>(0, (a, b) => a + b);
    final palette = [
      [const Color(0xFF264653), const Color(0xFF2A9D8F)],
      [const Color(0xFF6A4C93), const Color(0xFF1982C4)],
      [const Color(0xFFBC4749), const Color(0xFF6A040F)],
      [const Color(0xFF283618), const Color(0xFF606C38)],
      [const Color(0xFF3D348B), const Color(0xFF7678ED)],
    ];
    return palette[hash % palette.length];
  }
}
