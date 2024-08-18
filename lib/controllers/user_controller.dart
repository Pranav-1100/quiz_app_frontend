import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(user, (_) => _saveUserLocally());
    checkExistingUser();
  }

  Future<void> checkExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('user');
    if (storedUser != null) {
      try {
        user.value = UserModel.fromJson(json.decode(storedUser));
        print('Loaded user: ${user.value!.username}');
      } catch (e) {
        print('Error loading stored user: $e');
        await prefs.remove('user');
      }
    }
  }

  Future<void> createUser(String username) async {
    try {
      isLoading(true);
      final createdUser = await ApiService.createUser(username);
      user.value = createdUser;
      print('Created user: ${user.value!.username}');
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create user: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      print('Error creating user: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveUserLocally() async {
    if (user.value != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(user.value!.toJson()));
      print('Saved user locally: ${user.value!.username}');
    }
  }

  Future<void> logout() async {
    user.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    Get.offAllNamed('/username');
  }

  Future<void> fetchUserCoins() async {
    try {
      isLoading(true);
      if (user.value != null) {
        final coins = await ApiService.getUserCoins(user.value!.id);
        user.value = user.value!.copyWith(coins: coins);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user coins: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      try {
        final userJson = json.decode(userString);
        user.value = UserModel.fromJson(userJson);
      } catch (e) {
        print('Error loading user from local storage: $e');
      }
    }
  }
  void updateCoins(int newCoinValue) {
    if (user.value != null) {
      user.value = user.value!.copyWith(coins: newCoinValue);
    }
  }

  void updateCurrentLevel(int newLevel) {
    if (user.value != null) {
      user.value = user.value!.copyWith(currentLevel: newLevel);
    }
  }

  void updateStreak(int newStreak) {
    if (user.value != null) {
      user.value = user.value!.copyWith(streak: newStreak);
    }
  }

  void updateUserInfo({int? coins, int? currentLevel, int? streak}) {
    if (user.value != null) {
      user.value = user.value!.copyWith(
        coins: coins ?? user.value!.coins,
        currentLevel: currentLevel ?? user.value!.currentLevel,
        streak: streak ?? user.value!.streak,
      );
    }
  }
}