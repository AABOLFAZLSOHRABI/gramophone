import 'track.dart';

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.tracks = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final List<Track> tracks;
}
