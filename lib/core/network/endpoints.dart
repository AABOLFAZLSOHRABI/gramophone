class Endpoints {
  static const audiusBaseUrl = 'https://api.audius.co/v1';

  static const trendingTracks = '/tracks/trending';
  static const trendingUndergroundTracks = '/tracks/trending/underground';
  static const feelingLuckyTracks = '/tracks/feeling-lucky';
  static const trendingPlaylists = '/playlists/trending';
  static const searchTracks = '/tracks/search';
  static const searchUsers = '/users/search';
  static const searchPlaylists = '/playlists/search';

  // Audius requires api_key in every request.
  static const audiusApiKey = '618d8b1d224f289868ed91704da0ed79c85b0299';
}
