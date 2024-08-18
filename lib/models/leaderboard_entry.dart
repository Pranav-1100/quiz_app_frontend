class LeaderboardEntry {
  final String userId;
  final String username;
  final int score;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'],
      username: json['username'],
      score: json['score'],
    );
  }
}