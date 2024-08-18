import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/models/quiz_model.dart';
import 'package:flutter_application_2/models/question_model.dart';
import 'package:flutter_application_2/models/user_model.dart';
import 'package:flutter_application_2/models/leaderboard_entry.dart';

class ApiService {
  static const String baseUrl = "https://quiz-app-backend-1-midx.onrender.com";

  static Future<UserModel> createUser(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 409) {
        throw Exception('Username already exists');
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  static Future<List<QuizModel>> fetchQuizzes(int userId) async {
  try {
    print('Fetching quizzes for user ID: $userId');
    final response = await http.get(Uri.parse('$baseUrl/quizzes?user_id=$userId'));
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> quizzesJson = responseData['quizzes'];
      print('Number of quizzes received: ${quizzesJson.length}');
      return quizzesJson.map((json) => QuizModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quizzes: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchQuizzes: $e');
    rethrow;
  }
}

  static Future<List<QuestionModel>> fetchQuestions(String quizId) async {
  try {
    print('Fetching questions for quiz ID: $quizId');
    final response = await http.get(Uri.parse('$baseUrl/questions/$quizId'));
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> questionsJson = json.decode(response.body);
      print('Number of questions received: ${questionsJson.length}');
      
      // Remove duplicates based on question ID
      final uniqueQuestions = questionsJson.toSet().toList();
      
      return uniqueQuestions.map((json) => QuestionModel.fromJson(json)).toList();
    } else {
      print('Failed to load questions: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error in fetchQuestions: $e');
    return [];
  }
}

  static Future<Map<String, dynamic>> submitAnswer(int questionId, String answer) async {
  try {
    print('Submitting answer for question ID: $questionId, answer: $answer');
    final response = await http.post(
      Uri.parse('$baseUrl/answer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': 1, // Replace with actual user ID if needed
        'question_id': questionId,
        'answer': answer,
      }),
    );
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to submit answer: ${response.statusCode}');
      return {'correct': false};
    }
  } catch (e) {
    print('Error in submitAnswer: $e');
    return {'correct': false};
  }
}

  static Future<int> getUserCoins(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId/coins'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['coins'];
      } else {
        throw Exception('Failed to get user coins: ${response.statusCode}');
      }
    } catch (e) {
           Get.snackbar('Error', 'Failed to fetch leaderboard: ${e.toString()}');
      throw Exception('Connection failed: $e');
    }
  }

  static Future<Map<String, dynamic>> useLifeline(int questionId) async {
  try {
    print('Using lifeline for question ID: $questionId');
    final response = await http.post(
      Uri.parse('$baseUrl/lifeline'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': 18, // Fixed user ID
        'question_id': questionId,
        'lifeline_type': '50-50',
      }),
    );
    print('Lifeline response status: ${response.statusCode}');
    print('Lifeline response body: ${response.body}');
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to use lifeline. Status code: ${response.statusCode}');
      return {'error': 'Failed to use lifeline: ${response.body}'};
    }
  } catch (e) {
    print('Error in useLifeline: $e');
    return {'error': e.toString()};
  }
}

  static Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final response = await http.get(Uri.parse('$baseUrl/leaderboard'));
    if (response.statusCode == 200) {
      final List<dynamic> leaderboardJson = json.decode(response.body);
      return leaderboardJson.map((json) => LeaderboardEntry.fromJson(json)).toList();
    } else {
       Get.snackbar('Error', 'Failed to fetch leaderboard: ${e.toString()}');
      throw Exception('Failed to load leaderboard');
      
    }
  }
}