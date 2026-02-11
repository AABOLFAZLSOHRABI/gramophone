class PlaylistDto {
  const PlaylistDto({
    required this.id,
    required this.name,
    required this.creatorName,
    this.description,
    this.artwork1000,
    this.artwork480,
    this.artwork150,
  });

  final String id;
  final String name;
  final String creatorName;
  final String? description;
  final String? artwork1000;
  final String? artwork480;
  final String? artwork150;

  factory PlaylistDto.fromJson(Map<String, dynamic> json) {
    final artwork = (json['artwork'] as Map?)?.cast<String, dynamic>() ?? {};
    final user = (json['user'] as Map?)?.cast<String, dynamic>() ?? {};

    return PlaylistDto(
      id: '${json['id']}',
      name: (json['playlist_name'] ?? '').toString(),
      description: (json['description'] as String?)?.trim(),
      creatorName: (user['name'] ?? '').toString(),
      artwork1000: artwork['1000x1000']?.toString(),
      artwork480: artwork['480x480']?.toString(),
      artwork150: artwork['150x150']?.toString(),
    );
  }
}
