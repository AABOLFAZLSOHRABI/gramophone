class SearchPlaylist {
  const SearchPlaylist({
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
}
