import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './unit.dart';
import './colors.dart';
import './numberpad.dart';
import './property.dart';

class ExchangeScreen extends StatefulWidget {
  final Property _property;

  ExchangeScreen(this._property);

  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  String value1 = '0.0';
  Unit currentUnit1;
  MetricPrefix currentPrefix1;
  Unit currentUnit2;
  MetricPrefix currentPrefix2;

  bool jezyk;

  int precisionNumber;
  bool alwaysUseNotation;

  void setValue(NumPadInfo info) {
    setState(() {
      value1 = info.value
          .toStringAsFixed(info.isDotPlaced ? info.digitNumber - info.indexOfADot + 1 : 1);
    });

    return;
  }

  @override
  void initState() {
    super.initState();
    readBool();
    readInt();

    if (precisionNumber == null) {
      precisionNumber = 4;
    }
    print(precisionNumber);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        centerTitle: true,
        title: Text(widget._property.name),
      ),
      body: Column(
        children: <Widget>[
          Container(
              width: width,
              height: height / 4,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                      height: height / 8,
                      width: widget._property.specialLogicIndex == 1 ? width*0.75 : width*0.97,
                      child: Text(
                        value1.toString(),
                        style: TextStyle(fontSize: 30),
                      ),
                      alignment: Alignment(-0.8, 0),
                      margin: EdgeInsets.all(width / 72),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.NumPadBlue),
                        borderRadius: BorderRadius.all(Radius.circular(width / 72)),
                      ),
                    ),
                    widget._property.specialLogicIndex == 1 ? Container(child: FlatButton(onPressed: () {
                      setState(() {
                        value1 = (-double.parse(value1)).toString();
                      });
                    }, child: Text('+/-')),
                      width: width * 0.2,
                    ) : Container(width: 0, height: 0,)
                  ]),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: width / 72),
                        height: height / 15,
                        width: width * 2 / 3,
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.NumPadBlue),
                          borderRadius: BorderRadius.all(Radius.circular(width / 72)),
                        ),
                        child: Text(
                          (jezyk ? 'Jednostka: ' : 'Unit: ') +
                              currentPrefix1.symbol +
                              currentUnit1.symbol,
                          style: TextStyle(fontSize: 20),
                        ),
                        alignment: Alignment(-0.8, 0),
                      ),
                      PopupMenuButton<Unit>(
                        onSelected: choiceAction,
                        itemBuilder: (BuildContext context) {
                          return widget._property.units.map((Unit unit) {
                            return PopupMenuItem<Unit>(value: unit, child: Text(unit.name));
                          }).toList();
                        },
                      ),
                      PopupMenuButton<MetricPrefix>(
                        onSelected: choiceAction2,
                        itemBuilder: (BuildContext context) {
                          return (jezyk ? Prefixes.prefixesPL : Prefixes.prefixesEN)
                              .map((MetricPrefix pref) {
                            return PopupMenuItem<MetricPrefix>(value: pref, child: Text(pref.name));
                          }).toList();
                        },
                      )
                    ],
                  )
                ],
              )),
          Container(
              width: width,
              height: height / 4,
              child: Column(
                children: <Widget>[
                  Container(
                    height: height / 8,
                    child: Text(
                      (alwaysUseNotation == true
                          ? getValue().toStringAsExponential(precisionNumber).replaceAll('e+0', '')
                          : getValue().toStringAsPrecision(precisionNumber).replaceAll('e+0', '')),
                      style: TextStyle(fontSize: 30),
                    ),
                    alignment: Alignment(-0.8, 0),
                    margin: EdgeInsets.all(width / 72),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.NumPadBlue),
                      borderRadius: BorderRadius.all(Radius.circular(width / 72)),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: width / 72),
                        height: height / 15,
                        width: width * 2 / 3,
                        decoration: BoxDecoration(
                          border: Border.all(color: MyColors.NumPadBlue),
                          borderRadius: BorderRadius.all(Radius.circular(width / 72)),
                        ),
                        child: Text(
                          (jezyk ? 'Jednostka: ' : 'Unit: ') +
                              currentPrefix2.symbol +
                              currentUnit2.symbol,
                          style: TextStyle(fontSize: 20),
                        ),
                        alignment: Alignment(-0.8, 0),
                      ),
                      PopupMenuButton<Unit>(
                        onSelected: choiceAction3,
                        itemBuilder: (BuildContext context) {
                          return widget._property.units.map((Unit unit) {
                            return PopupMenuItem<Unit>(value: unit, child: Text(unit.name));
                          }).toList();
                        },
                      ),
                      PopupMenuButton<MetricPrefix>(
                        onSelected: choiceAction4,
                        itemBuilder: (BuildContext context) {
                          return (jezyk ? Prefixes.prefixesPL : Prefixes.prefixesEN)
                              .map((MetricPrefix pref) {
                            return PopupMenuItem<MetricPrefix>(value: pref, child: Text(pref.name));
                          }).toList();
                        },
                      )
                    ],
                  )
                ],
              )),
          NumberPad(setValue)
        ],
      ),
    );
  }

  double getValue() {
    return (widget._property.specialLogicIndex == 1
        ? (currentUnit1.symbol == 'C'
            ? (currentUnit2.symbol == 'K'
                ? (double.parse(value1) * currentPrefix1.value + 273.15) / currentPrefix2.value
                : (currentUnit2.symbol == 'F'
                    ? ((((9 * currentPrefix1.value * double.parse(value1)) / 5) + 32) /
                        currentPrefix2.value)
                    : double.parse(value1) * currentPrefix1.value / currentPrefix2.value))
            : (currentUnit1.symbol == 'K'
                ? (currentUnit2.symbol == 'C'
                    ? ((double.parse(value1) * currentPrefix1.value - 273.15) /
                        currentPrefix2.value)
                    : (currentUnit2.symbol == 'F'
                        ? (((double.parse(value1) * currentPrefix1.value - 273.15) * (9 / 5) + 32) /
                            currentPrefix2.value)
                        : (double.parse(value1) * currentPrefix1.value / currentPrefix2.value)))
                : (currentUnit2.symbol == 'C'
                    ? ((5 / 9) *
                        (double.parse(value1) * currentPrefix1.value - 32) /
                        currentPrefix2.value)
                    : (currentUnit2.symbol == 'K'
                        ? (((5 / 9) * (double.parse(value1) * currentPrefix1.value - 32) + 273.15) /
                            currentPrefix2.value)
                        : (double.parse(value1) * currentPrefix1.value / currentPrefix2.value)))))
        : double.parse(value1) *
            (currentUnit1.value / currentUnit2.value) *
            ((currentUnit1.symbol.contains('²')
                    ? pow(currentPrefix1.value, 2)
                    : (currentUnit1.symbol.contains('³')
                        ? pow(currentPrefix1.value, 3)
                        : currentPrefix1.value)) /
                (currentUnit2.symbol.contains('²')
                    ? pow(currentPrefix2.value, 2)
                    : (currentUnit2.symbol.contains('³')
                        ? pow(currentPrefix2.value, 3)
                        : currentPrefix2.value))));
  }

  void readInt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      precisionNumber = prefs.getInt('PNUE') ?? 4;
    });
  }

  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alwaysUseNotation = prefs.getBool('Notation') ?? false;
      jezyk = prefs.getBool('polski') ?? true;
      currentUnit1 = widget._property.units[0];
      currentPrefix1 = jezyk ? Prefixes.prefixesPL[0] : Prefixes.prefixesEN[0];
      currentUnit2 = widget._property.units[0];
      currentPrefix2 = jezyk ? Prefixes.prefixesPL[0] : Prefixes.prefixesEN[0];
    });
  }

  void choiceAction(Unit unit) {
    setState(() {
      currentUnit1 = unit;
    });
  }

  void choiceAction2(MetricPrefix pref) {
    setState(() {
      currentPrefix1 = pref;
    });
  }

  void choiceAction3(Unit unit) {
    setState(() {
      currentUnit2 = unit;
    });
  }

  void choiceAction4(MetricPrefix pref) {
    setState(() {
      currentPrefix2 = pref;
    });
  }
}
