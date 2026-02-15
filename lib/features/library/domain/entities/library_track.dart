import '../../../../domain/entities/track.dart';

class LibraryTrack {
  const LibraryTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.imageUrl,
    this.duration,
    this.streamUrl,
    this.localPath,
    this.dateAdded,
    this.isDownloaded = false,
    this.isLiked = false,
  });

  final String id;
  final String title;
  final String artist;
  final String? album;
  final String? imageUrl;
  final int? duration;
  final String? streamUrl;
  final String? localPath;
  final DateTime? dateAdded;
  final bool isDownloaded;
  final bool isLiked;

  LibraryTrack copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? imageUrl,
    int? duration,
    String? streamUrl,
    String? localPath,
    DateTime? dateAdded,
    bool? isDownloaded,
    bool? isLiked,
  }) {
    return LibraryTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      streamUrl: streamUrl ?? this.streamUrl,
      localPath: localPath ?? this.localPath,
      dateAdded: dateAdded ?? this.dateAdded,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Track toTrack() {
    return Track(
      id: id,
      title: title,
      artist: artist,
      imageUrl: imageUrl,
      duration: duration,
      streamUrl: localPath ?? streamUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'imageUrl': imageUrl,
      'duration': duration,
      'streamUrl': streamUrl,
      'localPath': localPath,
      'dateAdded': dateAdded?.millisecondsSinceEpoch,
      'isDownloaded': isDownloaded,
      'isLiked': isLiked,
    };
  }

  factory LibraryTrack.fromMap(Map<dynamic, dynamic> map) {
    return LibraryTrack(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      artist: (map['artist'] ?? '').toString(),
      album: map['album'] as String?,
      imageUrl: map['imageUrl'] as String?,
      duration: map['duration'] as int?,
      streamUrl: map['streamUrl'] as String?,
      localPath: map['localPath'] as String?,
      dateAdded: map['dateAdded'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] as int),
      isDownloaded: (map['isDownloaded'] as bool?) ?? false,
      isLiked: (map['isLiked'] as bool?) ?? false,
    );
  }
}
