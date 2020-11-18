import 'package:flutter/material.dart';
import 'package:torch/torch.dart';
import 'dart:io';

Map timimg = {'-': 15000, '.': 10000, ' ': 0};
Map mapper = {
  'a': '.-',      'b': '-...',    'c': '-.-.',    'd': '-..',
  'e': '.',       'f': '..-.',    'g': '--.',     'h': '....',
  'i': '..',      'j': '.---',    'k': '-.-',     'l': '.-..',
  'm': '--',      'n': '-.',      'o': '---',     'p': '.--.',
  'q': '--.-',    'r': '.-.',     's': '...',     't': '-',
  'u': '..-',     'v': '...-',    'w': '.--',     'x': '-..-',
  'y': '-.--',    'z': '--..',

  '1': '.----',   '2': '..---',
  '3': '...--',   '4': '....-',   '5': '.....',   '6': '-....',
  '7': '--...',   '8': '---..',   '9': '----.',   '0': '-----',

  'A': '.-',      'B': '-...',    'C': '-.-.',    'D': '-..',
  'E': '.',       'F': '..-.',    'G': '--.',     'H': '....',
  'I': '..',      'J': '.---',    'K': '-.-',     'L': '.-..',
  'M': '--',      'N': '-.',      'O': '---',     'P': '.--.',
  'Q': '--.-',    'R': '.-.',     'S': '...',     'T': '-',
  'U': '..-',     'V': '...-',    'W': '.--',     'X': '-..-',
  'Y': '-.--',    'Z': '--..',

  '.': '.-.-.-',    ',': '--..--',    '?': '..--..',
  "'": '.----.',    '/': '-..-.',     '(': '-.--.',
  ')': '-.--.-',    '&': '.-...',     ':': '---...',
  ';': '-.-.-.',    '=': '-...-',     '+': '.-.-.',
  '-': '-....-',    '_': '..--.-',    '"': '.-..-.',
  '\$': '...-..-',  '!': '-.-.--',    '@': '.--.-.',
  ' ': '     ',
};

class LightMorse extends StatefulWidget {
  @override
  _LightMorseState createState() => _LightMorseState();
}

class _LightMorseState extends State<LightMorse> {
  TextEditingController texty = new TextEditingController();
  String code = '';
  String showCode='';
  String showMorseCode ='';

  void encoder() {
    setState(() {
      String temp = texty.text.toLowerCase();
      code = '';
      for (int i = 0; i < temp.length; i++) {
        code += mapper[temp[i]] + ' ';
      }
      texty.clear();
    });
  }

  void lit() {
    print(code);
    for (int i = 0; i < code.length - 1; i++) {
      int time = timimg[code[i]];
      time > 0 ? Torch.turnOn() :
      sleep(
        Duration(
          milliseconds: time+100,
        ),
      );
      Torch.turnOff();
      sleep(
        Duration(
          milliseconds: 200,
        ),
      );
    }
    texty.clear();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              controller: texty,
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
                hintText: 'Enter Text',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                labelText: 'Enter Text',
              ),
            ),
          ),
          RaisedButton(
            onPressed: encoder,
            child: Text(
              "Convert To Morse Code",
            ),
          ),
          Text(
            code,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: lit,
                child: Text(
                  "🔦",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
