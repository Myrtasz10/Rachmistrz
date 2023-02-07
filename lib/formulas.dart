import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constants.dart';
import './numberpad.dart';
import './colors.dart';
import './operation.dart';

class FormulaScreen extends StatefulWidget {
  final Operation baseFormula;

  FormulaScreen(this.baseFormula);

  _FormulaScreenState createState() => _FormulaScreenState(baseFormula);
}

class _FormulaScreenState extends State<FormulaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  _FormulaScreenState(this.formulaToDisplay);

  Operation formulaToDisplay;
  String activeButton;
  String activeStrToCalc;
  List<NumPadInfo> listOfInfo;
  double valueOfTheFormula = 0;
  bool inNotation = false;
  int numberOfComponents = 0;
  int presisonNumber;
  bool jezyk = true;

  showSnackBar(String popText) {
    final snackBar = new SnackBar(
      content: new Text(popText),
      duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void setTheValue(String text) {
    setValue(text);
  }

  void setValue(String text) {
    setState(() {
      try {
        if (text == '.') {
          if (listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .digitNumber == 0) {
            return;
          }
          if (!(listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .indexOfADot == null)) {
            return;
          }
          listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .indexOfADot = listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .digitNumber + 1;
          listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .isDotPlaced = true;
        } else if (text == '-') {
          listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .value *= -1;
        } else if (text == '⌫') {
          if (listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .value == 0) {
            listOfInfo[formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0)] =
            new NumPadInfo(List<int>(16), 0, 0, null, false);

            return;
          } else if (listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .isDotPlaced) {
            if (listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .digitNumber - listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .indexOfADot == -1) {
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .isDotPlaced = false;
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .indexOfADot = null;
            } else {
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .value -=
                  listOfInfo
                      .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                      (inNotation ? numberOfComponents : 0))
                      .digits[listOfInfo
                      .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                      (inNotation ? numberOfComponents : 0))
                      .digitNumber - 1] /
                      pow(10, listOfInfo
                          .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                          (inNotation ? numberOfComponents : 0))
                          .digitNumber + 1 - listOfInfo
                          .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                          (inNotation ? numberOfComponents : 0))
                          .indexOfADot);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber--;
            }
          } else {
            listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .value -=
            listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .digits[listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .digitNumber - 1];
            listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .digitNumber--;
            listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .value /= 10;
          }
        } else {
          if (listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .digitNumber == 16) {
            return;
          }
          if (listOfInfo
              .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
              (inNotation ? numberOfComponents : 0))
              .isDotPlaced) {
            if (listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .value == null) {
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .value = int.tryParse(text) /
                  pow(10, listOfInfo
                      .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                      (inNotation ? numberOfComponents : 0))
                      .digitNumber + 2 - listOfInfo
                      .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                      (inNotation ? numberOfComponents : 0))
                      .indexOfADot);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digits[listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber] = int.tryParse(text);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber++;
            } else {
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .value += int.tryParse(text) /
                  pow(10, listOfInfo
                      .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                      (inNotation ? numberOfComponents : 0))
                      .digitNumber + 2 - listOfInfo
                      .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                      (inNotation ? numberOfComponents : 0))
                      .indexOfADot);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digits[listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber] = int.tryParse(text);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber++;
            }
          } else {
            if (listOfInfo
                .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                (inNotation ? numberOfComponents : 0))
                .value == null) {
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .value = int.tryParse(text).toDouble();
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digits[listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber] = int.tryParse(text);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber++;
            } else {
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .value *= 10;
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .value += int.tryParse(text).toDouble();
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digits[listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber] = int.tryParse(text);
              listOfInfo
                  .elementAt(formulaToDisplay.getComponents().indexOf(activeButton) +
                  (inNotation ? numberOfComponents : 0))
                  .digitNumber++;
            }
          }
        }
        for (int i = 0; i < formulaToDisplay
            .getComponents()
            .length; i++) {
          formulaToDisplay.setNumericValueOf(
              formulaToDisplay.getComponents().elementAt(i), listOfInfo
              .elementAt(i)
              .value * pow(10, listOfInfo
              .elementAt(i + numberOfComponents)
              .value));
        }
      } catch(error) {
        showSnackBar(jezyk ? "Najpierw wybierz daną do wpisania" : "Please first choose a value to input");
      }
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      readBool();
      readInt();
    });
    if (presisonNumber == null) {
      presisonNumber = 4;
    }
    numberOfComponents = formulaToDisplay.getComponents().length;
    listOfInfo = new List<NumPadInfo>(formulaToDisplay.getComponents().length * 2);
    for (int i = 0; i < formulaToDisplay.getComponents().length; i++) {
      listOfInfo[i] = new NumPadInfo(new List(16), 0, 0, null, false);
      listOfInfo[i + numberOfComponents] = new NumPadInfo(new List(16), 0, 0, null, false);

      if (!(formulaToDisplay.firstOperation.type == Operations.single)) {
        formulaToDisplay = formulaToDisplay.reformOperation(formulaToDisplay.getComponents().elementAt(0));
      }

      if (formulaToDisplay.firstOperation.value == null && !(formulaToDisplay.secondOperation.value == null)) {
        formulaToDisplay = new Operation(Operations.equal, null, formulaToDisplay.secondOperation, formulaToDisplay.firstOperation);
      }
    }

    formulaToDisplay = formulaToDisplay.simplify();

    activeStrToCalc = formulaToDisplay.firstOperation.value;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
            child: Icon(
              Icons.keyboard_return,
            ),
          ),
          backgroundColor: MyColors.MainOrange,
          centerTitle: true,
          title: Text(jezyk ? 'Wzory' : 'Formulas'),
        ),
        body: Column(children: <Widget>[
          TeXView(
            renderingEngine: RenderingEngine.Katex,
            teXHTML: formulaToDisplay.createKatexString(),
          ),
          Row(children: <Widget>[
            GestureDetector(
              child: FlatButton(
                child: Text(formulaToDisplay.firstOperation.value),
                onPressed: () {
                  setState(() {
                    formulaToDisplay = formulaToDisplay.newOperation(formulaToDisplay.firstOperation.value);
                    return;
                  });
                },
              ),
              onLongPress: () {
                print('name $activeStrToCalc');
                Navigator.of(context).pushNamed('/additional_choise', arguments: TestClass(formulaToDisplay, activeStrToCalc));
              },
            ),
            FlatButton(
              child: Text('= ' + valueOfTheFormula.toStringAsPrecision(presisonNumber).replaceAll('Infinity', 'error').replaceAll('NaN', 'error')),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < formulaToDisplay.getComponents().length; i++) {
                    if (isItAConstant(formulaToDisplay.getComponents().elementAt(i))) {
                      formulaToDisplay.setNumericValueOf(formulaToDisplay.getComponents().elementAt(i), getValueOfAConst(formulaToDisplay.getComponents().elementAt(i)));
                    }
                  }
                  valueOfTheFormula = formulaToDisplay.secondOperation.calculate();
                });
              },
            )
          ]),
          Column(
              children: formulaToDisplay.getComponents().map((String name) {
            return ((formulaToDisplay.firstOperation.value == name || isItAConstant(name)
                ? Container(
                    width: 0,
                    height: 0,
                  )
                : Row(
                    children: <Widget>[
                      GestureDetector(
                        child: FlatButton(
                          child: Text(name),
                          onPressed: () {
                            setState(() {
                              formulaToDisplay = formulaToDisplay.newOperation(name);
                              activeStrToCalc = name;
                              return;
                            });
                          },
                        ),
                        onLongPress: () {
                          print('name $name');
                          Navigator.of(context).pushNamed('/additional_choise', arguments: TestClass(formulaToDisplay.newOperation(name), name));
                        },
                      ),
                      FlatButton(
                        child: Text(listOfInfo == null
                            ? 'error'
                            : listOfInfo.elementAt(formulaToDisplay.getComponents().indexOf(name)).value.toStringAsFixed(
                                listOfInfo.elementAt(formulaToDisplay.getComponents().indexOf(name)).isDotPlaced ? listOfInfo.elementAt(formulaToDisplay.getComponents().indexOf(name)).digitNumber - listOfInfo.elementAt(formulaToDisplay.getComponents().indexOf(name)).indexOfADot + 1 : 1)),
                        onPressed: () {
                          setState(() {
                            activeButton = name;
                            inNotation = false;
                          });
                        },
                      ),
                      FlatButton(
                        child: Text('*10^' + listOfInfo.elementAt(formulaToDisplay.getComponents().indexOf(name) + numberOfComponents).value.toString()),
                        onPressed: () {
                          setState(() {
                            activeButton = name;
                            inNotation = true;
                          });
                        },
                      )
                    ],
                  )));
          }).toList()),
          Expanded(
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
                      Expanded(child: Button(inNotation ? '-' : '.', setTheValue, MyColors.NumPadBlue, Colors.white)),
                      Expanded(child: Button('0', setTheValue, MyColors.NumPadWhite, Colors.black)),
                      Expanded(child: Button('⌫', setTheValue, MyColors.NumPadBlue, Colors.white)),
                    ], crossAxisAlignment: CrossAxisAlignment.stretch),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  void readInt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      presisonNumber = prefs.getInt('PNF') ?? 4;
    });
  }
  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jezyk = prefs.getBool('polski') ?? true;
    });
  }
}

class Value {
  String name;
  double val;

  Value(this.name, this.val);
}
