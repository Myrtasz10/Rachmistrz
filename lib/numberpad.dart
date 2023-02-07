import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './colors.dart';

class NumberPad extends StatefulWidget {
  final Function function;
  final NumPadInfo numPadInfo;

  NumberPad(this.function, [this.numPadInfo]);

  @override
  _NumberPadState createState() => _NumberPadState(numPadInfo);
}

class _NumberPadState extends State<NumberPad> {
  NumPadInfo info;

  _NumberPadState(NumPadInfo inf) {
    if (inf == null) {
      info = new NumPadInfo(new List<int>(16), 0, 0, null, false);
    } else {
      info = inf;
    }
  }

  void setTheValue(String text) {
    if (text == '.') {
      if (info.digitNumber == 0) {
        return;
      }
      if (!(info.indexOfADot == null)) {
        return;
      }
      info.indexOfADot = info.digitNumber + 1;
      info.isDotPlaced = true;
    } else if (text == '⌫') {
      if (info.value == 0) {
        info = new NumPadInfo(new List<int>(16), 0, 0, null, false);

        return;
      } else if (info.isDotPlaced) {
        if (info.digitNumber - info.indexOfADot == -1) {
          info.isDotPlaced = false;
          info.indexOfADot = null;
        } else {
          info.value -= info.digits[info.digitNumber - 1] / pow(10, info.digitNumber + 1 - info.indexOfADot);
          info.digitNumber--;
        }
      } else {
        info.value -= info.digits[info.digitNumber - 1];
        info.digitNumber--;
        info.value /= 10;
      }
    } else {
      if (info.digitNumber == 16) {
        return;
      }
      if (info.isDotPlaced) {
        if (info.value == null) {
          info.value = int.tryParse(text) / pow(10, info.digitNumber + 2 - info.indexOfADot);
          info.digits[info.digitNumber] = int.tryParse(text);
          info.digitNumber++;
        } else {
          info.value += int.tryParse(text) / pow(10, info.digitNumber + 2 - info.indexOfADot);
          info.digits[info.digitNumber] = int.tryParse(text);
          info.digitNumber++;
        }
      } else {
        if (info.value == null) {
          info.value = int.tryParse(text).toDouble();
          info.digits[info.digitNumber] = int.tryParse(text);
          info.digitNumber++;
        } else {
          info.value *= 10;
          info.value += int.tryParse(text).toDouble();
          info.digits[info.digitNumber] = int.tryParse(text);
          info.digitNumber++;
        }
      }
    }
    widget.function(info);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(children: <Widget>[
                Expanded(child: Button('1', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('2', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('3', setTheValue, MyColors.NumPadWhite, Colors.black)),
              ], crossAxisAlignment: CrossAxisAlignment.stretch),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(child: Button('4', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('5', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('6', setTheValue, MyColors.NumPadWhite, Colors.black)),
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
            Expanded(
              child: Row(children: <Widget>[
                Expanded(child: Button('7', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('8', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('9', setTheValue, MyColors.NumPadWhite, Colors.black)),
              ], crossAxisAlignment: CrossAxisAlignment.stretch),
            ),
            Expanded(
              child: Row(children: <Widget>[
                Expanded(child: Button('.', setTheValue, MyColors.NumPadBlue, Colors.white)),
                Expanded(child: Button('0', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('⌫', setTheValue, MyColors.NumPadBlue, Colors.white)),
              ], crossAxisAlignment: CrossAxisAlignment.stretch),
            ),
          ],
        ),
      ),
    );
  }
}

class NumPadInfo {
  List<int> digits = new List(16);
  int digitNumber = 0;
  double value;
  int indexOfADot;
  bool isDotPlaced = false;

  NumPadInfo(this.digits, this.digitNumber, this.value, this.indexOfADot, this.isDotPlaced);
}

/*
class NieUlanyNumberPad extends StatefulWidget {
  final Function function;

  NieUlanyNumberPad(this.function);

  @override
  _NieUlanyNumberPadState createState() => _NieUlanyNumberPadState();
}

class _NieUlanyNumberPadState extends State<NumberPad> {
  void setTheValue(String text) {
    widget.function(text);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        Expanded(
          child: Row(children: <Widget>[
            Expanded(child: Button('1', setTheValue, MyColors.NumPadWhite, Colors.black)),
            Expanded(child: Button('2', setTheValue, MyColors.NumPadWhite, Colors.black)),
            Expanded(child: Button('3', setTheValue, MyColors.NumPadWhite, Colors.black)),
          ], crossAxisAlignment: CrossAxisAlignment.stretch),
        ),
        Expanded(
            child: Row(children: <Widget>[
          Expanded(child: Button('4', setTheValue, MyColors.NumPadWhite, Colors.black)),
          Expanded(child: Button('5', setTheValue, MyColors.NumPadWhite, Colors.black)),
          Expanded(child: Button('6', setTheValue, MyColors.NumPadWhite, Colors.black)),
        ], crossAxisAlignment: CrossAxisAlignment.stretch)),
        Expanded(
            child: Row(children: <Widget>[
          Expanded(child: Button('7', setTheValue, MyColors.NumPadWhite, Colors.black)),
          Expanded(child: Button('8', setTheValue, MyColors.NumPadWhite, Colors.black)),
          Expanded(child: Button('9', setTheValue, MyColors.NumPadWhite, Colors.black)),
        ], crossAxisAlignment: CrossAxisAlignment.stretch)),
        Expanded(
            child: Row(children: <Widget>[
          Expanded(child: Button('.', setTheValue, MyColors.NumPadBlue, Colors.white)),
          Expanded(child: Button('0', setTheValue, MyColors.NumPadWhite, Colors.black)),
          Expanded(child: Button('<-', setTheValue, MyColors.NumPadBlue, Colors.white)),
        ], crossAxisAlignment: CrossAxisAlignment.stretch))
      ],
    ));
  }
}
*/
class Button extends StatelessWidget {
  final String text;
  final Function setvaluefunction;
  final Color kolor;
  final Color tekstKolor;

  Button(this.text, this.setvaluefunction, this.kolor, this.tekstKolor);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          setvaluefunction(text);
        },
        color: kolor,
        textColor: tekstKolor,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8.0),
        splashColor: MyColors.SecondaryBlueBright,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
        child: Text(
          text,
          style: TextStyle(fontSize: 20.0),
        ));
  }
}
