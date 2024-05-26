import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditLockPage extends StatefulWidget {
  final String lock;

  EditLockPage({required this.lock});

  @override
  _EditLockPageState createState() => _EditLockPageState();
}

class _EditLockPageState extends State<EditLockPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String primaryKey = '';

  @override
  void initState() {
    super.initState();
    _loadPrimaryKey();
  }

  Future<void> _loadPrimaryKey() async {
    final storage = FlutterSecureStorage();
    String? key = await storage.read(key: 'primaryKey');
    setState(() {
      primaryKey = key ?? '';
    });
  }

  Future<void> editLockName() async {
    final String name = _nameController.text;

    final response = await http.post(
      Uri.parse('http://10.107.10.64:8000/edit_lock_name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id' : primaryKey,
        'name': name,
        'lastname': widget.lock,
      }),
    );

    if (response.statusCode == 200) {
      print('Lock name edited successfully');
      // Clear text fields after successful operation
      _nameController.clear();
      // Navigate to another page or show success message
    } else {
      throw Exception('Failed to edit lock name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier ${widget.lock}'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await editLockName();
                    Navigator.pop(context);  // Navigate back to the previous page
                  }
                },
                child: Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
