import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internationnalchallenges/Pages/lock.dart';
import 'package:internationnalchallenges/Pages/login.dart';
import 'package:internationnalchallenges/Pages/register.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  // ignore: empty_constructor_bodies
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    RegisterPage(),
    LoginPage(),
    LockPage(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.grey[300],
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.lock,
                text: 'Locks',
              ),
              GButton(
                icon: Icons.add,
                text: 'New',
              )
            ],
          ),
        ),
      ),
    );
  }
}