import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:morse/morse.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

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
              style: GoogleFonts.orbitron(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
              style: GoogleFonts.orbitron(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
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
              height: 10,
            ),
            Text(
              'Tap on the text to convert into morse code',
              style: TextStyle(
                color: Color(0xffE6BBFC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}