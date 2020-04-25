import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'map_page.dart';
import 'choice_page.dart';
import 'archive_page.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      title: 'Мастер',
      theme: ThemeData(
        primaryColor: Colors.red,
        backgroundColor: Colors.white,
      ),
      home: MyHomePage(title: 'Выберете услугу'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottomBarIndex = 0, _activateTime = 3000;
  bool _isPageTwo = false;

  Widget callPage(int index) {
    switch (index) {
      case 0:
        return ChoicePage();
      case 1:
        return MapPage();
      case 2:
        return ArchivePage();
      default:
        return ChoicePage();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AbsorbPointer(
        absorbing: _isPageTwo,
        child: BottomNavigationBar(
          currentIndex: _bottomBarIndex,
          onTap: (value) {
            _bottomBarIndex = value;
            switch (value) {
              case 0:
                _isPageTwo = false;
                break;
              case 1:
              // locking it here as soon as user taps this option
                _isPageTwo = true;
                break;
              case 2:
                _isPageTwo = false;
                break;

              default:
                _isPageTwo = false;
            }
            setState(() {});

            // unlocking it here after 3000 ms
            Timer(Duration(milliseconds: _activateTime), (){
              setState(() {
                _isPageTwo = false;
              });
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, height: 0.0),
              ),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.location_on),
              title: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, height: 0.0),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              title: Text(
                '',
                style: TextStyle(fontWeight: FontWeight.bold, height: 0.0),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
      ),
      body: callPage(_bottomBarIndex),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}