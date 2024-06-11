import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

import 'package:internationnalchallenges/Components/my_button.dart';
import 'package:internationnalchallenges/Components/my_textfield.dart';
import 'package:internationnalchallenges/Pages/lock.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign user in
  Future<void> signUser(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    String hashed = sha256.convert(utf8.encode(password)).toString();

    final response = await http.post(
      Uri.parse('https://putlock.umons.ac.be:8000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': hashed,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String primaryKey = data['primaryKey'];

      final storage = FlutterSecureStorage();

      await storage.write(key: 'primaryKey', value: primaryKey);

      await storage.write(key: 'username', value: username);

      // Navigate to another page or show success message
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LockPage()),
      );
    } else {
      _showLoginErrorPopup(context);
    }
  }

  void _showLoginErrorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Login Failed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Couldn't log you in: incorrect username or password",
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                    'Login Page',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
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
                    onTap: () => signUser(context),
                    buttonText: "Sign in",
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
