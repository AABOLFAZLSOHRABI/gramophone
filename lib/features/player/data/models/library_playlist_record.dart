class LibraryPlaylistRecord {
  const LibraryPlaylistRecord({
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'trackIds': trackIds,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory LibraryPlaylistRecord.fromMap(Map<dynamic, dynamic> map) {
    final rawTrackIds = map['trackIds'];
    final trackIds = rawTrackIds is List
        ? rawTrackIds.map((item) => item.toString()).toList()
        : <String>[];

    return LibraryPlaylistRecord(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      trackIds: trackIds,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['createdAt'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['updatedAt'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
