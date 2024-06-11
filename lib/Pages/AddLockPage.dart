import 'package:crypto/crypto.dart';
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

    String hashed = sha256.convert(utf8.encode(signature)).toString();

    final response = await http.post(
      Uri.parse('https://putlock.umons.ac.be:8000/add_lock'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id' : primaryKey,
        'name': name,
        'id': id,
        'signature': hashed,
      }),
    );

    if (response.statusCode == 201) {
      print('Lock added successfully');
      // Clear text fields after successful registration
      _nameController.clear();
      _idController.clear();
      _signatureController.clear();
      Navigator.pop(context);
    } else {
      _showAddLockErrorPopup(context);
    }
  }

  void _showAddLockErrorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Adding the lock failed",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Couldn't add your lock: incorrect ID or signature",
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

              const SizedBox(height: 25),

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