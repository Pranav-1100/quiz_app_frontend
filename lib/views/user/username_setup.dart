import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/controllers/user_controller.dart';
import 'package:flutter_application_2/widgets/custom_text_field.dart';
import 'package:flutter_application_2/widgets/primary_button.dart';

class UsernameSetupScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to Quiz App!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomTextField(
                controller: _usernameController,
                labelText: 'Enter your username',
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 24),
              PrimaryButton(
                text: 'Start Quizzing',
                onPressed: () {
                  if (_usernameController.text.isNotEmpty) {
                    _userController.createUser(_usernameController.text);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter a username',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Theme.of(context).disabledColor,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}