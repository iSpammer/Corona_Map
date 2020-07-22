//import 'package:bubbled_navigation_bar/bubbled_navigation_bar.dart';
import 'package:coronamap/main.dart';
import 'package:flutter/material.dart';
import 'package:coronamap/views/heat_map.dart';
import 'country_list.dart';
import 'global_info.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> _widgets = <Widget>[
    GlobalInfoPage(),
    CountryListPage(),
    HeatMapScreen(),
  ];

  bool dark = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Colors.grey,
        onTap: (int val) {
          setState(() {
            _currentIndex = val;
          });
        },
        currentIndex: _currentIndex,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.list, title: 'Countries'),
          FloatingNavbarItem(icon: Icons.map, title: 'HeatMap'),
//        FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ],
      ),
      body: _widgets.elementAt(_currentIndex),
    );
  }
}
