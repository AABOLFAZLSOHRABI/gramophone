import '../../domain/entities/library_album.dart';
import '../../domain/entities/library_playlist.dart';
import '../../domain/entities/library_section.dart';
import '../../domain/entities/library_sort.dart';
import '../../domain/entities/library_source_type.dart';
import '../../domain/entities/library_track.dart';

class LibraryState {
  const LibraryState({
    required this.source,
    required this.section,
    required this.sort,
    required this.query,
    required this.isLoading,
    required this.isScanning,
    required this.scanProgress,
    required this.localTracks,
    required this.gramTracks,
    required this.downloadedTracks,
    required this.likedTracks,
    required this.playlists,
    required this.errorMessage,
    required this.infoMessage,
  });

  const LibraryState.initial()
    : source = LibrarySourceType.local,
      section = LibrarySection.allTracks,
      sort = LibrarySort.dateAdded,
      query = '',
      isLoading = true,
      isScanning = false,
      scanProgress = 0,
      localTracks = const [],
      gramTracks = const [],
      downloadedTracks = const [],
      likedTracks = const [],
      playlists = const [],
      errorMessage = null,
      infoMessage = null;

  final LibrarySourceType source;
  final LibrarySection section;
  final LibrarySort sort;
  final String query;
  final bool isLoading;
  final bool isScanning;
  final double scanProgress;
  final List<LibraryTrack> localTracks;
  final List<LibraryTrack> gramTracks;
  final List<LibraryTrack> downloadedTracks;
  final List<LibraryTrack> likedTracks;
  final List<LibraryPlaylist> playlists;
  final String? errorMessage;
  final String? infoMessage;

  List<LibraryTrack> get activeTracks {
    final base = switch (source) {
      LibrarySourceType.local => localTracks,
      LibrarySourceType.gram => switch (section) {
        LibrarySection.downloaded => downloadedTracks,
        LibrarySection.liked => likedTracks,
        _ => gramTracks,
      },
    };
    return _filterAndSort(base);
  }

  List<LibraryAlbum> get activeAlbums {
    final tracks = activeTracks;
    final grouped = <String, List<LibraryTrack>>{};
    for (final item in tracks) {
      final albumName = (item.album != null && item.album!.trim().isNotEmpty)
          ? item.album!
          : '${item.artist} Collection';
      final key = '${item.artist}|$albumName|${item.imageUrl ?? ''}';
      grouped.putIfAbsent(key, () => <LibraryTrack>[]).add(item);
    }
    return grouped.entries.map((entry) {
      final first = entry.value.first;
      final albumTitle = (first.album != null && first.album!.trim().isNotEmpty)
          ? first.album!
          : '${first.artist} Collection';
      return LibraryAlbum(
        id: entry.key,
        title: albumTitle,
        artist: first.artist,
        tracks: entry.value,
        imageUrl: first.imageUrl,
      );
    }).toList();
  }

  List<LibraryTrack> _filterAndSort(List<LibraryTrack> tracks) {
    final q = query.trim().toLowerCase();
    var result = tracks.where((item) {
      if (q.isEmpty) {
        return true;
      }
      return item.title.toLowerCase().contains(q) ||
          item.artist.toLowerCase().contains(q) ||
          (item.album ?? '').toLowerCase().contains(q);
    }).toList();

    // کامنت فارسی: ترتیب خروجی لیست‌ها بر اساس sort انتخابی کاربر انجام می‌شود.
    result.sort((a, b) {
      return switch (sort) {
        LibrarySort.title => a.title.toLowerCase().compareTo(
          b.title.toLowerCase(),
        ),
        LibrarySort.artist => a.artist.toLowerCase().compareTo(
          b.artist.toLowerCase(),
        ),
        LibrarySort.dateAdded => (b.dateAdded ?? DateTime(0)).compareTo(
          a.dateAdded ?? DateTime(0),
        ),
        LibrarySort.recentlyPlayed => (b.dateAdded ?? DateTime(0)).compareTo(
          a.dateAdded ?? DateTime(0),
        ),
      };
    });
    return result;
  }

  LibraryState copyWith({
    LibrarySourceType? source,
    LibrarySection? section,
    LibrarySort? sort,
    String? query,
    bool? isLoading,
    bool? isScanning,
    double? scanProgress,
    List<LibraryTrack>? localTracks,
    List<LibraryTrack>? gramTracks,
    List<LibraryTrack>? downloadedTracks,
    List<LibraryTrack>? likedTracks,
    List<LibraryPlaylist>? playlists,
    String? errorMessage,
    String? infoMessage,
    bool clearError = false,
    bool clearInfo = false,
  }) {
    return LibraryState(
      source: source ?? this.source,
      section: section ?? this.section,
      sort: sort ?? this.sort,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      isScanning: isScanning ?? this.isScanning,
      scanProgress: scanProgress ?? this.scanProgress,
      localTracks: localTracks ?? this.localTracks,
      gramTracks: gramTracks ?? this.gramTracks,
      downloadedTracks: downloadedTracks ?? this.downloadedTracks,
      likedTracks: likedTracks ?? this.likedTracks,
      playlists: playlists ?? this.playlists,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }
}
