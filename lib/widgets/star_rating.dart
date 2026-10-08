import 'package:flutter/material.dart';

/// Exibe/edita uma nota de 0 a 5 estrelas, em passos de 0.5.
/// Se [onChanged] for nulo, o widget e apenas para exibicao (read-only).
/// Toque numa estrela cheia para reduzir para meia estrela; toque novamente
/// para preencher.
class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final ValueChanged<double>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 32,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onChanged == null
              ? null
              : () {
            final newValue =
            rating == starValue ? starValue - 0.5 : starValue.toDouble();
            onChanged!(newValue);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(icon, color: Colors.amber, size: size),
          ),
        );
      }),
    );
  }
}
