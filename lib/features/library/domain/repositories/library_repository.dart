import '../entities/library_playlist.dart';
import '../entities/library_source_type.dart';
import '../entities/library_track.dart';

abstract class LibraryRepository {
  Stream<List<LibraryTrack>> watchLocalTracks();
  Stream<List<LibraryTrack>> watchGramDownloadedTracks();
  Stream<List<LibraryTrack>> watchGramLikedTracks();
  Stream<List<LibraryPlaylist>> watchGramPlaylists();
  Stream<List<LibraryTrack>> watchGramAllTracks();

  Future<void> scanLocalLibrary({bool pickFoldersOnDesktop = false});
  Future<void> refreshGramData();

  Future<List<LibraryTrack>> search({
    required LibrarySourceType source,
    required String query,
  });

  Future<void> toggleLike(String trackId);
  Future<void> addToPlaylist(String trackId, String playlistId);
  Future<String> createPlaylist(String name);
  Future<void> renamePlaylist(String id, String name);
  Future<void> deletePlaylist(String id);
  Future<List<LibraryTrack>> getTracksForPlaylist(String playlistId);
}
