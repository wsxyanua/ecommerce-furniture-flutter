import 'dart:async';

import '../screens/home.dart';
import '../screens/introduce.dart';
import '../screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcom extends StatefulWidget {
  const Welcom({super.key});

  @override
  State<Welcom> createState() => _WelcomState();
}

class _WelcomState extends State<Welcom> {

  String? authToken;

  @override
  void initState()  {
    super.initState();
    getPrefs();
  }

  Future<void> getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hideIntroducePage = prefs.getBool('SHOW_INTRODUCT_PAGE');
    authToken = prefs.getString('AUTH_TOKEN');

    Timer(const Duration(seconds: 4), () {

      if (hideIntroducePage != null && hideIntroducePage == true) {

        if(authToken != null && authToken!.isNotEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
        }
      }
      else
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Introduce()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff410000),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                    width: 200,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Furniture'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      fontFamily: "Open Sans",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Delivery'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      fontFamily: "Open Sans",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
