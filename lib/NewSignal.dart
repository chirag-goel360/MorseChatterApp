import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Signal.dart';

class NewSignal extends StatefulWidget {
  FirebaseUser user;
  NewSignal(this.user);

  @override
  _NewSignalState createState() => _NewSignalState();
}

class _NewSignalState extends State<NewSignal> {
  String email;
  String error;
  TextEditingController mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[700],
        title: Text(
          'Add Chat',
          style: GoogleFonts.varelaRound(
            textStyle: TextStyle(
              color: Colors.tealAccent,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/bg.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Lottie.asset(
                  'assets/searching.json',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 18,
                  ),
                  controller: mailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.purpleAccent,
                      ),
                    ),
                    hintText: 'Enter reciever\'s Email',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    labelText: 'Enter reciever\'s Email',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  onSubmitted: (value) {
                    email = value;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                splashColor: Colors.tealAccent,
                onPressed: () async {
                  final z = await Firestore.instance
                      .collection('users')
                      .document(mailController.text)
                      .get();
                  if (z.exists) {
                    String chatId = '${widget.user.email}-${mailController.text}';
                    final x = await Firestore.instance
                        .collection('signals')
                        .document(chatId)
                        .get();
                    final y = await Firestore.instance
                        .collection('signals')
                        .document(chatId)
                        .get();
                    if (x.exists || y.exists) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return Signal(
                          widget.user,
                          chatId,
                          chatId
                              .replaceAll('-', '')
                              .replaceAll(widget.user.email, '')
                              .replaceAll('@gmail.com', ''),
                        );
                      },
                      ),
                      );
                    } else {
                      await Firestore.instance
                          .collection('signals')
                          .document(chatId)
                          .setData({
                        'users': [widget.user.email, mailController.text],
                        'chatId': chatId,
                      });
                      await Firestore.instance
                          .collection('users')
                          .document(widget.user.email)
                          .collection('ActiveSignals')
                          .document(chatId)
                          .setData({
                        'signalId': chatId,
                      });
                      await Firestore.instance
                          .collection('users')
                          .document(mailController.text)
                          .collection('ActiveSignals')
                          .document(chatId)
                          .setData({
                        'signalId': chatId,
                      });
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                          return Signal(
                            widget.user,
                            chatId,
                            chatId
                                .replaceAll('-', '')
                                .replaceAll(widget.user.email, '')
                                .replaceAll('@gmail.com', ''),
                          );
                        },
                        ),
                      );
                    }
                  } else
                    Fluttertoast.showToast(
                      msg: "Email not registered",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                },
                child: Text(
                  'Send Signal',
                  style: GoogleFonts.orbitron(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}