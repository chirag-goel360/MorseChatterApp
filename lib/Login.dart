import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:morse_chatter/GoogleSignin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/background.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Morse Chat',
                style: GoogleFonts.orbitron(
                  textStyle: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Chat Using Morse',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Lottie.asset(
                'assets/loginanimation.json',
              ),
              SizedBox(
                height: 10,
              ),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () {
                  signInWithGoogle(context);
                },
                text: 'SignUp With Google',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
