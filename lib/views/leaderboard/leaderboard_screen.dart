import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/leaderboard_controller.dart';
import 'package:flutter_application_2/widgets/custom_app_bar.dart';
import 'package:flutter_application_2/widgets/leaderboard_tile.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardController _leaderboardController = Get.find<LeaderboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Leaderboard'),
      body: Obx(
        () => _leaderboardController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : _leaderboardController.leaderboard.isEmpty
                ? Center(child: Text('No leaderboard data available'))
                : ListView.builder(
                    itemCount: _leaderboardController.leaderboard.length,
                    itemBuilder: (context, index) {
                      final entry = _leaderboardController.leaderboard[index];
                      return LeaderboardTile(
                        rank: index + 1,
                        username: entry.username,
                        score: entry.score,
                        isCurrentUser: entry.userId == _leaderboardController.currentUserId,
                      );
                    },
                  ),
      ),
    );
  }
}