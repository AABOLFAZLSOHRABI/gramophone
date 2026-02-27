class SearchPlaylistModel {
  const SearchPlaylistModel({
    required this.id,
    required this.name,
    required this.creatorName,
    required this.imageUrl,
    required this.trackCount,
  });

  final String id;
  final String name;
  final String creatorName;
  final String? imageUrl;
  final int trackCount;

  factory SearchPlaylistModel.fromJson(Map<String, dynamic> json) {
    final user = (json['user'] as Map?)?.cast<String, dynamic>() ?? {};
    final artwork = (json['artwork'] as Map?)?.cast<String, dynamic>() ?? {};

    return SearchPlaylistModel(
      id: '${json['id'] ?? ''}',
      name: (json['playlist_name'] ?? '').toString(),
      creatorName: (user['name'] ?? '').toString(),
      imageUrl:
          artwork['1000x1000']?.toString() ??
          artwork['480x480']?.toString() ??
          artwork['150x150']?.toString(),
      trackCount: (json['track_count'] as num?)?.toInt() ?? 0,
    );
  }
}
