import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/config/theme.dart';
import 'package:flutter_application_2/views/home/home_screen.dart';
import 'package:flutter_application_2/views/quiz/quiz_detail_screen.dart';
import 'package:flutter_application_2/views/quiz/quiz_screen.dart';
import 'package:flutter_application_2/views/quiz/quiz_result_screen.dart';
import 'package:flutter_application_2/views/user/username_setup.dart';
import 'package:flutter_application_2/views/leaderboard/leaderboard_screen.dart';
import 'package:flutter_application_2/controllers/user_controller.dart';
import 'package:flutter_application_2/controllers/quiz_controller.dart';
import 'package:flutter_application_2/controllers/leaderboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(MyApp());
}

Future<void> initServices() async {
  print('Starting services ...');
  await Get.putAsync(() async => await UserController());
  await Get.putAsync(() async => await QuizController());
  await Get.putAsync(() async => await LeaderboardController());
  print('All services started...');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/username', page: () => UsernameSetupScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(
          name: '/quiz/:id',
          page: () {
            final quizId = Get.parameters['id'];
            return QuizDetailScreen(quizId: quizId ?? '');
          },
        ),
        GetPage(
          name: '/quiz/:id/start',
          page: () {
            final quizId = Get.parameters['id'];
            return QuizScreen(quizId: quizId ?? '');
          },
        ),
        GetPage(name: '/quiz-result', page: () => QuizResultScreen()),
        GetPage(name: '/leaderboard', page: () => LeaderboardScreen()),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(Duration(seconds: 2)); // Simulated splash delay
    final UserController userController = Get.find<UserController>();
    await userController.checkExistingUser();
    if (userController.user.value != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/username');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}