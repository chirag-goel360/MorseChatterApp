import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:morse_chatter/GoogleSignin.dart';
import 'package:morse_chatter/LearnMorse.dart';
import 'package:morse_chatter/MorseLight.dart';
import 'package:morse_chatter/NewSignal.dart';
import 'package:morse_chatter/OCR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morse/morse.dart';
import 'Login.dart';
import 'Signal.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser user;
  int _selectedIndex = 0;
  bool fab = true;
  bool old = false;
  getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser();
    setState(() {});
    print(user.email);
  }

  void initState() {
    super.initState();
    getUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color.fromRGBO(32,178,170, 0.9),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Color(0xff150F70),
          selectedIndex: _selectedIndex,
          showElevation: true,
          curve: Curves.easeIn, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Text('Signals'),
                activeColor: Color(0xFFFF16CD)),
            BottomNavyBarItem(
                icon: Icon(Icons.image),
                title: Text('OCR'),
                activeColor: Colors.purpleAccent),
            BottomNavyBarItem(
              icon: Icon(Icons.flash_auto),
              title: Text('Flash'),
              activeColor: Colors.greenAccent[400],
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.school),
              title: Text('Learn'),
              activeColor: Colors.red,
            ),
            
          ],
        ),
        // FlipBoxBar(
        //   navBarHeight: 90.0,
        //   selectedIndex: _selectedIndex,
        //   onIndexChanged: (index) => setState(() {
        //     _selectedIndex = index;
        //   }),
        //   items: [
        //     FlipBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.comment,
        //         color: Colors.red,
        //       ),
        //       text: Text(
        //         "Chats",
        //         style: TextStyle(
        //           color: Colors.red,
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       frontColor: Colors.blue[500],
        //       backColor: Colors.blue[700],
        //     ),
        //     FlipBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.book,
        //         color: Colors.blue,
        //       ),
        //       text: Text(
        //         "OCR",
        //         style: TextStyle(
        //           color: Colors.blue,
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       frontColor: Colors.purpleAccent,
        //       backColor: Colors.purple,
        //     ),
        //     FlipBarItem(
        //       icon: FaIcon(
        //         FontAwesomeIcons.chalkboard,
        //         color: Color.fromRGBO(122,81,57,0.8),
        //       ),
        //       text: Text(
        //         "Learn",
        //         style: TextStyle(
        //           color: Color.fromRGBO(122,83,57,1),
        //           fontSize: 18,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       frontColor: Colors.brown.shade300,
        //       backColor: Colors.brown.shade200,
        //     ),
        //   ],
        // ),
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Colors.blue,
                  // Color(0xffFF21B7),
                  Colors.deepPurpleAccent,
                ],
              ),
            ),
          ),
          title: Text(
            'Morse Chatter',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              color: Colors.blue,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Center(
                      child: FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          signOutGoogle();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              ModalRoute.withName('homepage'));
                        },
                        child: Text(
                          'Logout',
                          style: GoogleFonts.orbitron(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        splashColor: Colors.tealAccent,
                      ),
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        floatingActionButton: fab
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewSignal(user)));
                },
                child: Icon(
                  Icons.person,
                ),
                backgroundColor: Colors.orange,
              )
            : null,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _selectedIndex == 0
                ? user != null
                    ? StreamBuilder(
                        stream: Firestore.instance
                            .collection('signals')
                            .where('users', arrayContains: user.email)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.data.documents.length == 0) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Lottie.asset('assets/laboratory.json'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'No previous Chats found',
                                    style: GoogleFonts.varelaRound(
                                      textStyle: TextStyle(
                                        color: Colors.teal,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    child: Text(
                                      'Chat with Others',
                                      style: GoogleFonts.orbitron(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    color: Colors.yellowAccent,
                                    splashColor: Colors.tealAccent,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewSignal(user)));
                                    },
                                  ),
                                ]);
                          }
                          return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Signal(
                                                    user,
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['chatId'],
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['chatId']
                                                        .replaceAll("-", "")
                                                        .replaceAll(
                                                            user.email, "")
                                                        .replaceAll(
                                                            '@gmail.com',
                                                            ''))));
                                      },
                                      title: Text(
                                        '${snapshot.data.documents[index].data['chatId'].replaceAll("-", "").replaceAll(user.email, "")}',
                                        style: GoogleFonts.varelaRound(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                      leading: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                // const Color(0xffEA3798),
                                                // const Color(0xffBF9E50),
                                                Colors.blue[600],
                                                // Color(0xffFF21B7),
                                                Colors.deepPurpleAccent[700],
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    .data['chatId']
                                                    .replaceAll("-", "")
                                                    .replaceAll(user.email, "")
                                                    .substring(0, 1),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 24,
                                                  fontFamily: 'OverpassRegular',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${Morse(snapshot.data.documents[index].data['chatId'].replaceAll("-", "").replaceAll(user.email, "").substring(0, 1)).encode()}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            )
                                          ],
                                        ),
                                      ),
                                      enabled: true,
                                      trailing: Icon(
                                        Icons.navigate_next,
                                        color: Colors.green,
                                        size: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
                : _selectedIndex == 1
                    ? OCR()
                    :_selectedIndex==2? LightMorse(): Learn()
          ],
        ));
  }
}


