import 'package:flutter/material.dart';
import 'package:internationnalchallenges/Components/my_button.dart';
import 'package:internationnalchallenges/Components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  //text editing controller
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //register user in
  void registerUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              // To space things better
              const SizedBox(height: 50),

              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 25),

              // login page
              Text(
                'Register Page',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 25),
              // email textfield

              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 25),
              // username textfield

              MyTextField(
                controller: usernameController,
                hintText: 'username',
                obscureText: false,
              ),

              const SizedBox(height: 25),
              // password textfield

              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ),

              const SizedBox(height: 35),

              MyButton(
                onTap: registerUser,
                buttonText: "Sign in",
              ),

        

            ],
          ),
        )));
  }
}
