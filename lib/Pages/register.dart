import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:internationnalchallenges/Components/my_button.dart';
import 'package:internationnalchallenges/Components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  //text editing controller
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //register user in
  Future<void> registerUser() async {
    final String email = emailController.text;
    final String username = usernameController.text;
    final String password = passwordController.text;

    String hashed = sha256.convert(utf8.encode(password)).toString();

    final response = await http.post(
      Uri.parse('http://10.107.10.64:8000/add_user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': hashed, // Sending the password to the backend
      }),
    );

    if (response.statusCode == 201) {
      print('User registered successfully');
      // Clear text fields after successful registration
      emailController.clear();
      usernameController.clear();
      passwordController.clear();
      // Navigate to another page or show success message
    } else {
      throw Exception('Failed to register user');
    }
  }

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
