import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LockPageState createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(
        child: CircularPercentIndicator(
          animation: true,
          animationDuration: 3000,
          radius: 300,
          lineWidth: 20,
          percent: 1,
          progressColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple.shade100,
          circularStrokeCap: CircularStrokeCap.butt,
          center: const Text('1 1 1 1', style: TextStyle(fontSize: 50)),
      )
      ),
    );
  }
}
