class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
}
