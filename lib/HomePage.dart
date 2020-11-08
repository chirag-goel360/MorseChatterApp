import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_box_bar/flip_box_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:morse_chatter/GoogleSignin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:morse/morse.dart';
import 'Login.dart';
import 'Signal.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser user;
  int _selectedIndex = 0;
  bool fab = true;
  bool old = false;
  getUser() async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    user = await _auth.currentUser();
    setState((){
    });
    print(user.email);
  }
  void initState(){
    super.initState();
    getUser();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(245, 170, 168, 0.9),
        bottomNavigationBar: FlipBoxBar(
          selectedIndex: _selectedIndex,
          onIndexChanged: (index) => setState(() {
            _selectedIndex = index;
          }),
          items: [
            FlipBarItem(
              icon: FaIcon(
                FontAwesomeIcons.comment,
                color: Colors.teal,
              ),
              text: Text(
                "Chats",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              frontColor: Colors.red.shade500,
              backColor: Colors.red.shade400,
            ),
            FlipBarItem(
              icon: FaIcon(
                FontAwesomeIcons.book,
                color: Colors.blue,
              ),
              text: Text(
                "OCR",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              frontColor: Colors.purpleAccent,
              backColor: Colors.purple,
            ),
            FlipBarItem(
              icon: FaIcon(
                FontAwesomeIcons.chalkboard,
                color: Color.fromRGBO(122,81,57,0.8),
              ),
              text: Text(
                "Learn",
                style: TextStyle(
                  color: Color.fromRGBO(122,83,57,1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              frontColor: Colors.brown.shade300,
              backColor: Colors.brown.shade200,
            ),
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Colors.blue,
                  Color(0xffFF21B7),
                  Colors.deepPurpleAccent,
                ],
              ),
            ),
          ),
          title: Text(
            'Morse Chatter',
            style:GoogleFonts.montserrat(
              textStyle:TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              color: Colors.blue,
              itemBuilder: (BuildContext context){
                return[
                  PopupMenuItem(
                    child: Center(
                      child: FlatButton(
                        onPressed:() async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          signOutGoogle();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),
                              ModalRoute.withName('homepage'));
                        },
                        child: Text(
                          'Logout',
                          style:GoogleFonts.orbitron(
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
        floatingActionButton: fab ? FloatingActionButton(
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewSignal(user)));
          },
          child: Icon(
            Icons.person,
          ),
          backgroundColor: Colors.orange,
        ) : null,
        body: _selectedIndex == 0 ? user != null ? StreamBuilder(
          stream: Firestore.instance.collection('signals').where('users',arrayContains:user.email).snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else
            if(snapshot.data.documents.length == 0)
            {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    Lottie.asset('assets/laboratory.json'),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'No previous Chats found',
                      style: GoogleFonts.varelaRound(
                        textStyle:TextStyle(
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
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewSignal(user)));
                      },
                    ),
                  ]
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Signal(user,snapshot.data.documents[index].data['chatId'],snapshot.data.documents[index].data['chatId'].replaceAll("-","").replaceAll(user.email,"").replaceAll('@gmail.com',''))));
                        },
                        title:Text(
                          '${snapshot.data.documents[index].data['chatId'].replaceAll("-","").replaceAll(user.email,"")}',
                          style:GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        leading:Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xffFF3798),
                                  const Color(0xffFF9E50),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height:4,
                              ),
                              Expanded(
                                child: Text(
                                  snapshot.data.documents[index].data['chatId'].replaceAll("-","").replaceAll(user.email,"").substring(0, 1),
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
                                '${Morse(snapshot.data.documents[index].data['chatId'].replaceAll("-","").replaceAll(user.email,"").substring(0, 1)).encode()}',
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
        ) : Center(
          child: CircularProgressIndicator(),
        ) : _selectedIndex == 1 ? OCR() : Learn()
    );
  }
}

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
        centerTitle:true,
        backgroundColor: Colors.purple[700],
        title: Text(
          'Add Chat',
          style:GoogleFonts.varelaRound(
            textStyle:TextStyle(
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
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Lottie.asset('assets/searching.json'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(
                    color:Colors.purpleAccent,
                    fontSize:18,
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
                      color:Colors.white,
                      fontSize: 18,
                    ),
                    labelText: 'Enter reciever\'s Email',
                  ),
                  onChanged: (value){
                    email = value;
                  },
                  onSubmitted: (value){
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
                onPressed: () async{
                  final z = await Firestore.instance.collection('users').document(mailController.text).get();
                  if(z.exists){
                    String chatId = '${widget.user.email}-${mailController.text}';
                    final x = await Firestore.instance.collection('signals').document(chatId).get();
                    final y = await Firestore.instance.collection('signals').document(chatId).get();
                    if(x.exists || y.exists)
                    {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return Signal(widget.user,chatId,chatId.replaceAll('-', '').replaceAll(widget.user.email,'').replaceAll('@gmail.com',''));
                      }));
                    }
                    else{
                      await Firestore.instance.collection('signals').document(chatId).setData({'users':[widget.user.email,mailController.text],'chatId':chatId});
                      await Firestore.instance.collection('users').document(widget.user.email).collection('ActiveSignals').document(chatId).setData({'signalId':chatId});
                      await Firestore.instance.collection('users').document(mailController.text).collection('ActiveSignals').document(chatId).setData({'signalId':chatId});
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return Signal(widget.user,chatId,chatId.replaceAll('-', '').replaceAll(widget.user.email,'').replaceAll('@gmail.com',''));
                      }));
                    }
                  }
                  else
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
                  style:GoogleFonts.orbitron(
                    textStyle:TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height:40,
              ),
            ],
          ),
        ],
      ) ,
    );
  }
}

class OCR extends StatefulWidget {
  @override
  _OCRState createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  String _textValue = "Sample Code";
  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _cameraOcr,
        waitTap: true,
        fps: 2.0,
      );
      setState(() {
        _textValue = (texts[0].value);
      });
    } on Exception {
      texts.add(
        OcrText(
          'Failed to recognize text',
        ),
      );
    }
  }
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset(
                  'assets/scan-some-words.json',
                  repeat: false,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  _textValue,
                  style:GoogleFonts.orbitron(
                    textStyle:TextStyle(
                      color: Colors.white,
                      fontSize:20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Morse(_textValue).encode(),
                  style:GoogleFonts.orbitron(
                    textStyle:TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height:30,
                ),
                RaisedButton(
                  onPressed: _read,
                  child: Text(
                    'Start Scanning',
                  ),
                  color: Colors.red,
                  splashColor: Colors.orangeAccent,
                ),
                SizedBox(
                  height:10,
                ),
                Text(
                  'Tap on the text to convert into morse code',
                  style: TextStyle(
                    color:Color(0xffE6BBFC),
                  ),
                ),
              ]
          )
      ),
    );
  }
}

class Learn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Image.asset('assets/learnMorse.jpg'),
        ),
      ),
    );
  }
}