import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddLockPage extends StatefulWidget {
  @override
  _AddLockPageState createState() => _AddLockPageState();
}

class _AddLockPageState extends State<AddLockPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _signatureController = TextEditingController();
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

  Future<void> addLock() async {
    final String name = _nameController.text;
    final String id = _idController.text;
    final String signature = _signatureController.text;

    final response = await http.post(
      Uri.parse('http://10.107.10.64:8000/add_lock'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id' : primaryKey,
        'name': name,
        'id': id,
        'signature': signature,
      }),
    );

    if (response.statusCode == 201) {
      print('Lock added successfully');
      // Clear text fields after successful registration
      _nameController.clear();
      _idController.clear();
      _signatureController.clear();
      // Navigate to another page or show success message
    } else {
      throw Exception('Failed to add lock');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Lock'),
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
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an id';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _signatureController,
                decoration: InputDecoration(labelText: 'Signature'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a signature';
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