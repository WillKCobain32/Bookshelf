class Review {
  final String id;
  final String livroId;
  final String userId;
  final double rating;
  final String text;
  final DateTime date;
  final bool relido;
  final bool contemSpoiler;

  Review({
    required this.id, required this.livroId, required this.userId, required this.rating, required this.text, required this.date, this.relido = false, this.contemSpoiler = false
});

  Review copyWith({
    String? id, double? rating, String? text, DateTime? date, bool? relido, bool? contemSpoiler,
}) {
    return Review(id: id ?? this.id, livroId: livroId, userId: userId, rating: rating ?? this.rating, text: text ?? this.text, date: date ?? this.date, relido: relido ?? this.relido, contemSpoiler: contemSpoiler ?? this.contemSpoiler);

  }
}