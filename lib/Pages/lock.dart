import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:internationnalchallenges/Pages/AddLockPage.dart';
import 'package:internationnalchallenges/Pages/EditLockPage.dart';

class LockPage extends StatefulWidget {
  const LockPage({Key? key}) : super(key: key);

  @override
  _LockPageState createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  late Timer _timer;
  String _code = '';
  double _percent = 1;
  String _selectedLock = 'Lock 1';
  List<String> _lockOptions = [];
  String primaryKey = '';
  String _username = '';

  // Encoded flag
  final String encodedFlag = "Y3Rme01tbW1oLi4ubW9ua2V9Cg==";

  @override
  void initState() {
    super.initState();
    _initializeCode(); // Générer un code dès le lancement de la page
    _timer = Timer.periodic(
        const Duration(milliseconds: 10), (Timer t) => _updatePercent());
    _initializeData();
  }

  Future<void> _initializeCode() async {
    await _generateCode();
    sendCode();
  }

  Future<void> _initializeData() async {
    await _loadPrimaryKey();
    _loadLocks();
  }

  Future<void> _loadLocks() async {
    final response = await http.post(
      Uri.parse('http://10.107.10.64:8000/get_locks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': primaryKey,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> locks = jsonDecode(response.body);
      print(locks);
      setState(() {
        _lockOptions = locks.map<String>((lock) => lock[1]).toList();
        if (_lockOptions.isNotEmpty) {
          _selectedLock = _lockOptions[0];
        }
      });
    } else {
      print('Failed to load locks');
    }
  }

  Future<void> _loadPrimaryKey() async {
    final storage = FlutterSecureStorage();
    String? key = await storage.read(key: 'primaryKey');
    String? username = await storage.read(key: 'username');
    setState(() {
      primaryKey = key ?? '';
      _username = username ?? '';
    });

    // Check if primaryKey is equal to "1" and show congratulatory popup if true
    if (primaryKey == "1") {
      _showCongratulatoryPopup();
    }
  }

  void _showCongratulatoryPopup() {
    // Decode the flag when showing the popup
    String flag = utf8.decode(base64.decode(encodedFlag));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'You are connected as the admin. Good job ! Here is the flag: $flag',
              style: TextStyle(
                fontSize: 20)),
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

  Future<void> deleteLock() async {
    print(_selectedLock);
    final response = await http.delete(
      Uri.parse('http://10.107.10.64:8000/delete_lock'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id' : primaryKey,
        'lock_name': _selectedLock,
      }),
    );

    if (response.statusCode == 200) {
      print('Lock deleted successfully');
      _loadLocks();
    } else {
      throw Exception('Failed to delete lock');
    }
  }

  Future<void> sendCode() async {
    final response = await http.post(
      Uri.parse('http://10.107.10.64:8000/set_secret'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'code' : _code,
        'user_ID' : primaryKey,
      }),
    );

    if (response.statusCode == 200) {
      print('Code was sent succesfully');
      _loadLocks();
    } else {
      throw Exception('Failed to send code');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _generateCode() async{
    final random = Random();
    setState(() {
      _code = '${random.nextInt(10000).toString().padLeft(4, '0')}';
      _percent = 0; // Réinitialiser le pourcentage à 0
    });
  }

  void _updatePercent() {
    setState(() {
      _percent += 0.00033333; // Augmenter le pourcentage de 1/30 chaque seconde
      if (_percent >= 1) {
        _initializeCode(); // Générer un nouveau code lorsque le pourcentage atteint 100%
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var largeurEcran = constraints.maxWidth;
        var hauteurEcran = constraints.maxHeight;

        return Scaffold(
          body: Container(
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                Container(
                  height: hauteurEcran * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Welcome $_username',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 40.0),
                      DropdownButton<String>(
                        dropdownColor: Colors.grey[350],
                        value: _selectedLock,
                        items: _lockOptions.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                  width: largeurEcran *
                                      0.5, // Utilisez largeurEcran pour définir la largeur du Container
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 20.0,),
                                    textAlign: TextAlign.center,
                                  )));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLock = newValue!;
                            _initializeCode();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: hauteurEcran * 0.4,
                  child: Center(
                    child: CircularPercentIndicator(
                      radius: min(largeurEcran, hauteurEcran) *
                          0.65, // Utilisez min(largeurEcran, hauteurEcran) pour définir le rayon du CircularPercentIndicator
                      lineWidth: 25,
                      percent: _percent,
                      progressColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade100,
                      circularStrokeCap: CircularStrokeCap.butt,
                      center: Text(_code, style: const TextStyle(fontSize: 50)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0,
                  left: largeurEcran *
                      0.1), // Ajoutez un espace en bas pour éviter que les boutons ne soient trop près du bord de l'écran
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Add \n Lock',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height:
                              10.0), // Espacement entre le texte et le bouton
                      FloatingActionButton(
                        onPressed: () {
                          // Naviguer vers la page d'ajout de cadenas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddLockPage()),
                          ).then((_) {
                            // Recharger les cadenas lorsque vous revenez de la page AddLockPage
                            _loadLocks();
                          });
                        },
                        child: Icon(Icons.add, size: 30.0), // Icône plus grande
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Modify \n Lock',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height:
                              10.0), // Espacement entre le texte et le bouton
                      FloatingActionButton(
                        onPressed: () {
                          // Naviguer vers la page de modification de cadenas
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditLockPage(lock: _selectedLock)),
                          ).then((_){
                            _loadLocks();
                          });
                        },
                        child:
                            Icon(Icons.edit, size: 30.0), // Icône plus grande
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Delete \n Lock',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height:
                              10.0), // Espacement entre le texte et le bouton
                      FloatingActionButton(
                        onPressed: () {
                          // Afficher une boîte de dialogue pour confirmer la suppression
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete the lock'),
                                content: Text(
                                    'Are you sure that you want to delete $_selectedLock ?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      deleteLock();
                                      setState(() {
                                        _lockOptions.remove(_selectedLock);
                                        if (_lockOptions.isNotEmpty) {
                                          _selectedLock = _lockOptions.first;
                                        } else {
                                          _selectedLock = '';
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child:
                            Icon(Icons.delete, size: 30.0), // Icône plus grande
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
