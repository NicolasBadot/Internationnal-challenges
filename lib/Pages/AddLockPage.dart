import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddLockPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _signatureController = TextEditingController();


  Future<void> addLock() async {
    const userid = '1';
    final String name = _nameController.text;
    final String id = _idController.text;
    final String signature = _signatureController.text;

    final response = await http.post(
      Uri.parse('http://10.107.10.64:8000/add_lock'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id' : userid,
        'name': name,
        'id': id,
        'signature': signature, // Sending the password to the backend
      }),
    );

    if (response.statusCode == 201) {
      print('User registered successfully');
      // Clear text fields after successful registration
      _nameController.clear();
      _idController.clear();
      _signatureController.clear();
      // Navigate to another page or show success message
    } else {
      throw Exception('Failed to register user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un cadenas'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _signatureController,
                decoration: InputDecoration(labelText: 'Signature'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une marque';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: addLock,
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
