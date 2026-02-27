class SearchUserModel {
  const SearchUserModel({
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

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    final profilePicture =
        (json['profile_picture'] as Map?)?.cast<String, dynamic>() ?? {};
    return SearchUserModel(
      id: '${json['id'] ?? ''}',
      name: (json['name'] ?? '').toString(),
      handle: (json['handle'] ?? '').toString(),
      imageUrl:
          profilePicture['1000x1000']?.toString() ??
          profilePicture['480x480']?.toString() ??
          profilePicture['150x150']?.toString(),
      isVerified: json['is_verified'] == true,
    );
  }
}
