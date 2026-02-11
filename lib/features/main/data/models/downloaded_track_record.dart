import '../../../../domain/entities/track.dart';

class DownloadedTrackRecord {
  const DownloadedTrackRecord({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.audioFilePath,
    required this.downloadedAt,
    this.artistHandle,
    this.imagePath,
    this.duration,
    this.tags,
    this.genre,
    this.mood,
    this.isDownloadable,
  });

  final String trackId;
  final String title;
  final String artist;
  final String audioFilePath;
  final DateTime downloadedAt;
  final String? artistHandle;
  final String? imagePath;
  final int? duration;
  final String? tags;
  final String? genre;
  final String? mood;
  final bool? isDownloadable;

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'title': title,
      'artist': artist,
      'artistHandle': artistHandle,
      'imagePath': imagePath,
      'duration': duration,
      'tags': tags,
      'genre': genre,
      'mood': mood,
      'isDownloadable': isDownloadable,
      'audioFilePath': audioFilePath,
      'downloadedAt': downloadedAt.millisecondsSinceEpoch,
    };
  }

  factory DownloadedTrackRecord.fromMap(Map<dynamic, dynamic> map) {
    return DownloadedTrackRecord(
      trackId: map['trackId'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      artistHandle: map['artistHandle'] as String?,
      imagePath: map['imagePath'] as String?,
      duration: map['duration'] as int?,
      tags: map['tags'] as String?,
      genre: map['genre'] as String?,
      mood: map['mood'] as String?,
      isDownloadable: map['isDownloadable'] as bool?,
      audioFilePath: map['audioFilePath'] as String,
      downloadedAt: DateTime.fromMillisecondsSinceEpoch(
        map['downloadedAt'] as int,
      ),
    );
  }

  Track toEntity() {
    return Track(
      id: trackId,
      title: title,
      artist: artist,
      artistHandle: artistHandle,
      imageUrl: imagePath,
      duration: duration,
      streamUrl: audioFilePath,
      tags: tags,
      genre: genre,
      mood: mood,
      isDownloadable: isDownloadable,
    );
  }
}
