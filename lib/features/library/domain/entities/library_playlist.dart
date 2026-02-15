class LibraryPlaylist {
  const LibraryPlaylist({
    required this.id,
    required this.name,
    required this.trackIds,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final List<String> trackIds;
  final DateTime createdAt;
  final DateTime updatedAt;
}
