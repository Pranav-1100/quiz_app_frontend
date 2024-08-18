import 'package:get/get.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/leaderboard_entry.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderboardEntry> leaderboard = <LeaderboardEntry>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLoading(true);
      leaderboard.value = await ApiService.fetchLeaderboard();
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  void setCurrentUserId(String userId) {
    currentUserId.value = userId;
  }
}