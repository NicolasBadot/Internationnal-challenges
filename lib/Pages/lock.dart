import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LockPage extends StatefulWidget {
  const LockPage({Key? key}) : super(key: key);

  @override
  _LockPageState createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  late Timer _timer;
  String _code = '';
  double _percent = 1;
  String _selectedLock = 'Cadenas 1';
  List<String> _lockOptions = ['Cadenas 1', 'Cadenas 2', 'Cadenas 3'];

  @override
  void initState() {
    super.initState();
    _generateCode(); // Générer un code dès le lancement de la page
    _timer = Timer.periodic(
        const Duration(milliseconds: 10), (Timer t) => _updatePercent());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _generateCode() {
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
        _generateCode(); // Générer un nouveau code lorsque le pourcentage atteint 100%
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
                      Text('Bienvenue Nom_Utilisateur',
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
                                  width: largeurEcran * 0.25, // Utilisez largeurEcran pour définir la largeur du Container
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 20.0),
                                  )
                              )
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLock = newValue!;
                            _generateCode();
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
                      radius: min(largeurEcran, hauteurEcran) * 0.65, // Utilisez min(largeurEcran, hauteurEcran) pour définir le rayon du CircularPercentIndicator
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
        );
      },
    );
  }
}
