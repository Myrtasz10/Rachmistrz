import 'package:flutter/material.dart';

import './colors.dart';

class Constant extends StatelessWidget {
  //wartosci jakie musza miec stale

  final String name;
  final String symbol;
  final double value;
  final String unit;
  final String shortinfo;

  Constant(this.name, this.symbol, this.value, this.unit, [this.shortinfo]);

  @override
  Widget build(BuildContext context) {
    //dostosowywanie widgeta ze stala w zaleznosci od  tego czy ma jendostke czy nie

    double textsize = 35;

    Widget textwidget = unit == ''
        ? Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(color: MyColors.SecondaryBlue, fontSize: textsize),
                  textAlign: TextAlign.center,
                ),
                Text(
                    ' ',
                  textScaleFactor: 1.5,
                ),
                Text(
                  symbol + ' = ' + value.toString(),
                  style: TextStyle(color: Colors.black87, fontSize: 40),
                  textScaleFactor: 0.7,
                )
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(color: MyColors.SecondaryBlue, fontSize: textsize),
                  textAlign: TextAlign.center,
                ),
                Text(
                  ' ',
                  textScaleFactor: 1.5,
                ),
                Text(
                  symbol + ' = ' + value.toString(),
                  style: TextStyle(color: Colors.black87, fontSize: 40),
                  textScaleFactor: 0.7,
                ),
                Text(
                  unit,
                  style: TextStyle(color: Colors.black87, fontSize: 40),
                  textScaleFactor: 0.7,
                )
              ],
            ),
          );
    // generowanie widgetu ze stała
    return (Container(
        child: RaisedButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed('/constant_info', arguments: Constant(name, symbol, value, unit, shortinfo));
            },
            child: Container(
              decoration: BoxDecoration(border: (Border.all(color: MyColors.SecondaryBlue, width: 2)), color: MyColors.NumPadWhite),
              margin: EdgeInsets.only(
                left: 0.0,
                right: 0.0,
                top: 15,
                bottom: 15,
              ),
              child: Center(child: textwidget),
            ))));
  }
}
