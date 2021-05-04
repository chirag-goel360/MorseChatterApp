import 'package:flutter/material.dart';
import 'package:morse_chatter/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login = prefs.getBool(
    'login',
  );
  runApp(
    login == null
        ? MyApp1()
        : login
            ? MyApp2()
            : MyApp1(),
  );
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Morse Chat',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      routes: {
        'login': (context) {
          return Login();
        },
        'homepage': (context) {
          return HomePage();
        },
      },
    );
  }
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Morse Chat',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        'login': (context) {
          return Login();
        },
        'homepage': (context) {
          return HomePage();
        },
      },
    );
  }
}
