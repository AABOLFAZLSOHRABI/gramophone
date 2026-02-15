import 'library_track.dart';

class LibraryAlbum {
  const LibraryAlbum({
    required this.id,
    required this.title,
    required this.artist,
    required this.tracks,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String artist;
  final List<LibraryTrack> tracks;
  final String? imageUrl;
}
