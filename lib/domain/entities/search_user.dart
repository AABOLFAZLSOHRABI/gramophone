class SearchUser {
  const SearchUser({
    required this.id,
    required this.name,
    required this.handle,
    required this.imageUrl,
    required this.isVerified,
  });

  final String id;
  final String name;
  final String handle;
  final String? imageUrl;
  final bool isVerified;
}
