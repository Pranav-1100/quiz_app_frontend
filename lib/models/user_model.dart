class UserModel {
  final int id;
  final String username;
  final int coins;
  final int currentLevel;
  final int streak;

  UserModel({
    required this.id,
    required this.username,
    required this.coins,
    required this.currentLevel,
    required this.streak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      coins: json['coins'],
      currentLevel: json['current_level'],
      streak: json['streak'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'coins': coins,
      'current_level': currentLevel,
      'streak': streak,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    int? coins,
    int? currentLevel,
    int? streak,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      coins: coins ?? this.coins,
      currentLevel: currentLevel ?? this.currentLevel,
      streak: streak ?? this.streak,
    );
  }
}