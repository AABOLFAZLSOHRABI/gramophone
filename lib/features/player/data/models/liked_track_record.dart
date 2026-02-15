import 'package:gramophone/domain/entities/track.dart';

class LikedTrackRecord {
  const LikedTrackRecord({
    required this.track,
    required this.liked,
    required this.updatedAt,
  });

  final Track track;
  final bool liked;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'liked': liked,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'track': {
        'id': track.id,
        'title': track.title,
        'artist': track.artist,
        'artistHandle': track.artistHandle,
        'imageUrl': track.imageUrl,
        'duration': track.duration,
        'streamUrl': track.streamUrl,
        'tags': track.tags,
        'genre': track.genre,
        'mood': track.mood,
        'isDownloadable': track.isDownloadable,
      },
    };
  }

  factory LikedTrackRecord.fromMap(Map<dynamic, dynamic> map) {
    final rawTrack = (map['track'] as Map?)?.cast<String, dynamic>() ?? {};
    return LikedTrackRecord(
      liked: (map['liked'] as bool?) ?? true,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updatedAt'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
      track: Track(
        id: (rawTrack['id'] ?? '').toString(),
        title: (rawTrack['title'] ?? '').toString(),
        artist: (rawTrack['artist'] ?? '').toString(),
        artistHandle: rawTrack['artistHandle'] as String?,
        imageUrl: rawTrack['imageUrl'] as String?,
        duration: rawTrack['duration'] as int?,
        streamUrl: rawTrack['streamUrl'] as String?,
        tags: rawTrack['tags'] as String?,
        genre: rawTrack['genre'] as String?,
        mood: rawTrack['mood'] as String?,
        isDownloadable: rawTrack['isDownloadable'] as bool?,
      ),
    );
  }
}
