import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import './colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar = new SnackBar(
      content: new Text(popText),
      duration: new Duration(seconds: 3),
    );
    print("Show Snackbar here!");
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    setState(() {
      readBool();
    });
    super.initState();
  }

  void operationsDLC() {
    print(userInput);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(8.0),
                        color: MyColors.NumPadBlue,
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        splashColor: MyColors.SecondaryBlueBright,
                        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
                        child: new Icon(Icons.keyboard_arrow_down),
                      ))
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              )),
              Expanded(
                flex: 2,
                child: Row(children: <Widget>[
                  Expanded(child: Button('MS', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('MR', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('π', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('e', setTheValue, MyColors.NumPadWhite, Colors.black)),
                ], crossAxisAlignment: CrossAxisAlignment.stretch),
              ),
              Expanded(
                  flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(child: Button('xʸ', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('√', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('|x|', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('n!', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  ], crossAxisAlignment: CrossAxisAlignment.stretch)),
              Expanded(
                  flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(child: Button(mode, setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('⅟x', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('10ˣ', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('mod', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  ], crossAxisAlignment: CrossAxisAlignment.stretch)),
              Expanded(
                  flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(child: Button('sin', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('cos', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('tg', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('log', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  ], crossAxisAlignment: CrossAxisAlignment.stretch)),
              Expanded(
                  flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Button('sin⁻¹', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(
                        child: Button('cos⁻¹', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(
                        child: Button('tg⁻¹', setTheValue, MyColors.NumPadWhite, Colors.black)),
                    Expanded(child: Button('ln', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  ], crossAxisAlignment: CrossAxisAlignment.stretch))
            ],
          );
        });
  }

  bool jezyk = true;

  String userInput = "";
  String memory = "";
  final String operationSigns = "+-×÷^%mod";
  final String numbersNoZero = '123456789';
  double scaleFactor = 4;
  bool commable = true;
  bool zeroFriendly = false;
  int openParentheses = 0;

  String mode = "DEG";

  List<double> values = [];
  List<String> operations = [];

  int closingParenthesis = 1;

  int walkinIndex = 0; //dis index be walkin'
  int maxDepth = 0;
  int currentDepth = 0;
  int issueIndex = 0;
  String parenthesisHolder = ""; //pretty self-explanatory
  String parenthesisHolderBackup = "";
  bool interpretable = true;
  int i = 0;
  int fact = 1;

  bool completed = false; //aby kasować wszystko po wciśnięciu czegoś po "="
  int yeetIndex = 0; //jak duża jest liczba, jaką należy yeetnąć?

  int idxAdd = 0;
  int idxSubtract = 0;
  int idxMultiply = 0;
  int idxDivide = 0;
  int idxExponentiation = 0;
  int idxModulo = 0; //indeks danej operacji

  void setTheValue(String text) {
    setState(() {
      if (!operationSigns.contains(text) && completed == true && text != "MS") {
        print("stfu 2");
        userInput = "";
        commable = true;
        zeroFriendly = false;
      }
      completed = false;
      //po wykonaniu działania czyścimy userInput
      if (text == 'C') {
        print("stfu");
        userInput = "";
        commable = true;
        zeroFriendly = false;
        openParentheses = 0;
      } //usuwanie tekstu pod C

      else if (text == '⌫') {
        if (userInput.isNotEmpty) {
          if (userInput[userInput.length - 1] == ',') {
            commable = true;
          } else if (userInput[userInput.length - 1] == ')') {
            openParentheses++;
          } else if (userInput[userInput.length - 1] == '(') {
            openParentheses--;
          }
          if (operationSigns.contains(userInput[userInput.length - 1])) {
            if (userInput[userInput.length - 1] == 'd') {
              userInput = userInput.substring(0, userInput.length - 3);
            } else {
              userInput = userInput.substring(0, userInput.length - 1);
            }
            yeetIndex = userInput.length - 1;
            while (true) {
              if (yeetIndex == -1) {
                commable = true;
                break;
              }
              if (operationSigns.contains(userInput[yeetIndex]) || userInput[yeetIndex] == '(') {
                commable = true;
                break;
              } else if (userInput[yeetIndex] == ',') {
                commable = false;
                break;
              }
              yeetIndex--;
            }
            yeetIndex = userInput.length - 1;
            while (true) {
              if (yeetIndex == -1) {
                zeroFriendly = false;
                break;
              }
              if (operationSigns.contains(userInput[yeetIndex]) || userInput[yeetIndex] == '(') {
                zeroFriendly = false;
                break;
              } else if (numbersNoZero.contains(userInput[yeetIndex])) {
                zeroFriendly = true;
                break;
              }
              yeetIndex--;
            }
          } else {
            if (userInput.isNotEmpty) {
              userInput = userInput.substring(0, userInput.length - 1);
              if (userInput.isNotEmpty) {
                if ('√gnst'.contains(userInput[userInput.length - 1])) {
                  if (userInput[userInput.length - 1] == '√') {
                    userInput = userInput.substring(0, userInput.length - 1);
                  } else if (userInput.substring(userInput.length - 2, userInput.length) == 'ln') {
                    userInput = userInput.substring(0, userInput.length - 2);
                  } else {
                    userInput = userInput.substring(0, userInput.length - 3);
                  }
                  if (userInput.length >= 3) {
                    if (userInput.substring(userInput.length - 3, userInput.length) == 'arc') {
                      userInput = userInput.substring(0, userInput.length - 3);
                    }
                  }
                }
              }
            }
          }
          print(openParentheses);
        } //backspace, w dwóch warunkach aby nie powodować wyjątków a zarazem nie wrzucać backspace do tekstu

        //algorytm obliczenia
      } else if (text == '=') {
        print("Parse: $userInput");
        interpretable = true;
        userInput = userInput.replaceAll(',', '.');
        try {
          while (operationSigns.contains(userInput[userInput.length - 1]) ||
              userInput[userInput.length - 1] == '(' ||
              userInput[userInput.length - 1] == ',') {
            if (userInput[userInput.length - 1] == '(') {
              openParentheses--;
            }
            userInput = userInput.substring(0, userInput.length - 1);
          }
        } catch (e) {
          showSnackBar(jezyk
              ? "To wyrażenie nie ma rozwiązania w liczbach rzeczywistych"
              : "This expression has no solution in real numbers");
          interpretable = false;
          userInput = "";
        }
        if (!userInput.contains('+') &&
            !userInput.contains('-') &&
            !userInput.contains('×') &&
            !userInput.contains('÷') &&
            !userInput.contains('^') &&
            !userInput.contains('√') &&
            !userInput.contains('abs') &&
            !userInput.contains('fact') &&
            !userInput.contains('mod') &&
            !userInput.contains('log') &&
            !userInput.contains('ln') &&
            !userInput.contains('arcsin') &&
            !userInput.contains('arccos') &&
            !userInput.contains('arctg') &&
            !userInput.contains('sin') &&
            !userInput.contains('cos') &&
            !userInput.contains('tg')) {
          interpretable = false;
          showSnackBar(
              jezyk ? "To wyrażenie nie jest działaniem" : "This expression is not an operation");
        }
        if (interpretable) {
          //kompilacja
//          if (userInput[0] == '-') {
//            userInput = "0" + userInput; //obejście minusa na początku przez dodanie zera XD
//          }
          if (operationSigns.contains(userInput[userInput.length - 1])) {
            userInput = userInput.substring(0, userInput.length - 1);
          }
          while (openParentheses > 0) {
            userInput += ")";
            openParentheses--;
          }
          walkinIndex = 0;
          userInput = userInput.replaceAll('abs', 'a');
          userInput = userInput.replaceAll('fact', 'f');
          userInput = userInput.replaceAll('mod', '%');
          userInput = userInput.replaceAll('log', 'l');
          userInput = userInput.replaceAll('ln', 'n');
          userInput = userInput.replaceAll('arcsin', 'i');
          userInput = userInput.replaceAll('arccos', 'j');
          userInput = userInput.replaceAll('arctg', 'k');
          userInput = userInput.replaceAll('sin', 's');
          userInput = userInput.replaceAll('cos', 'c');
          userInput = userInput.replaceAll('tg', 't');

          while (userInput.contains('√')) {
            i = userInput.indexOf('√') + 1;
            do {
              print("Searching for expression at index $i");
              if (userInput[i] == '(') {
                walkinIndex++;
              } else if (userInput[i] == ')') {
                walkinIndex--;
              }
              i++;
            } while (walkinIndex > 0);
            print("call:");
            print(userInput.substring(userInput.indexOf('√'), i));
            userInput = userInput.replaceAll(userInput.substring(userInput.indexOf('√'), i),
                userInput.substring(userInput.indexOf('√') + 1, i) + "^0.5");
          }
          userInput = "(" + userInput + ")";
          //koniec kompilacji
          while (userInput.contains('(')) {
            print("Processing");
            print(userInput);
            operations.clear();
            values.clear();
            walkinIndex = 0;
            currentDepth = 0;
            maxDepth = 0;
            issueIndex = 0;

            userInput = userInput.replaceAll('--', '+');
            userInput = userInput.replaceAll('(+', '(');

            while (userInput.length > walkinIndex) {
              if (userInput[walkinIndex] == '(') {
                currentDepth++;
                if (currentDepth > maxDepth) {
                  maxDepth = currentDepth;
                  issueIndex = walkinIndex;
                }
              } else if (userInput[walkinIndex] == ')') {
                currentDepth--;
              }
              walkinIndex++;
            }
            print(issueIndex);
            print(userInput.substring(issueIndex, userInput.length).indexOf(')'));
            parenthesisHolder = userInput.substring(
                issueIndex,
                userInput.substring(issueIndex, userInput.length).indexOf(')') +
                    userInput.substring(0, issueIndex).length +
                    1);
            print('Operate at $parenthesisHolder');
            parenthesisHolderBackup = parenthesisHolder;
            parenthesisHolder = parenthesisHolder.substring(1, parenthesisHolder.length - 1);
//            if (parenthesisHolder[0] == '-') {
//              parenthesisHolder = '0' + parenthesisHolder;
//            }
            print(parenthesisHolder);
            while (parenthesisHolder.isNotEmpty) {
              print("while");
              print(parenthesisHolder);
              //upewnienie się, że userInput posiada prawidłowe działanie
              if (parenthesisHolder.contains('+') &&
                      !operationSigns.contains(parenthesisHolder[parenthesisHolder.length - 1]) ||
                  parenthesisHolder.substring(1, parenthesisHolder.length).contains('-') &&
                      !operationSigns.contains(parenthesisHolder[parenthesisHolder.length - 1]) ||
                  parenthesisHolder.contains('×') &&
                      !operationSigns.contains(parenthesisHolder[parenthesisHolder.length - 1]) ||
                  userInput.contains('÷') &&
                      !operationSigns.contains(parenthesisHolder[parenthesisHolder.length - 1]) ||
                  userInput.contains('^') &&
                      !operationSigns.contains(parenthesisHolder[parenthesisHolder.length - 1]) ||
                  userInput.contains('%') &&
                      !operationSigns.contains(parenthesisHolder[parenthesisHolder.length - 1])) {
                print("Verification return positive");
                //sprawdzanie, który znak jest pierwszy
                if (parenthesisHolder.contains('+')) {
                  idxAdd = parenthesisHolder.indexOf('+');
                } else {
                  idxAdd = 16777216;
                }
                //próba obejścia interpretacji znaku "-" jako operacji
                if (parenthesisHolder.contains('-')) {
                  idxSubtract = parenthesisHolder.indexOf('-');
                  if (idxSubtract == 0) {
                    if (parenthesisHolder.length > 1) {
                      if (parenthesisHolder.substring(1, parenthesisHolder.length).contains('-')) {
                        idxSubtract =
                            parenthesisHolder.substring(1, parenthesisHolder.length).indexOf('-') + 1;
                      } else {
                        idxSubtract = 16777216;
                      }
                    } else {
                      idxSubtract = 16777216;
                    }
                  }
                } else {
                  idxSubtract = 16777216;
                }
                if (parenthesisHolder.contains('×')) {
                  idxMultiply = parenthesisHolder.indexOf('×');
                } else {
                  idxMultiply = 16777216;
                }
                if (parenthesisHolder.contains('÷')) {
                  idxDivide = parenthesisHolder.indexOf('÷');
                } else {
                  idxDivide = 16777216;
                }
                if (parenthesisHolder.contains('^')) {
                  idxExponentiation = parenthesisHolder.indexOf('^');
                } else {
                  idxExponentiation = 16777216;
                }
                if (parenthesisHolder.contains('%')) {
                  idxModulo = parenthesisHolder.indexOf('%');
                } else {
                  idxModulo = 16777216;
                }
                if (idxAdd < idxSubtract &&
                    idxAdd < idxMultiply &&
                    idxAdd < idxDivide &&
                    idxAdd < idxExponentiation &&
                    idxAdd < idxModulo) {
                  yeetIndex = idxAdd;
                } else if (idxSubtract < idxAdd &&
                    idxSubtract < idxMultiply &&
                    idxSubtract < idxDivide &&
                    idxSubtract < idxExponentiation &&
                    idxSubtract < idxModulo) {
                  yeetIndex = idxSubtract;
                } else if (idxMultiply < idxAdd &&
                    idxMultiply < idxSubtract &&
                    idxMultiply < idxDivide &&
                    idxMultiply < idxExponentiation &&
                    idxMultiply < idxModulo) {
                  yeetIndex = idxMultiply;
                } else if (idxDivide < idxAdd &&
                    idxDivide < idxSubtract &&
                    idxDivide < idxMultiply &&
                    idxDivide < idxExponentiation &&
                    idxDivide < idxModulo) {
                  yeetIndex = idxDivide;
                } else if (idxExponentiation < idxAdd &&
                    idxExponentiation < idxSubtract &&
                    idxExponentiation < idxMultiply &&
                    idxExponentiation < idxDivide &&
                    idxExponentiation < idxModulo) {
                  yeetIndex = idxExponentiation;
                } else if (idxModulo < idxAdd &&
                    idxModulo < idxSubtract &&
                    idxModulo < idxMultiply &&
                    idxModulo < idxDivide &&
                    idxModulo < idxExponentiation) {
                  yeetIndex = idxModulo;
                } else {
                  print('No yeeting occured');
                  yeetIndex = parenthesisHolder.length;
                }
                //values.add(double.tryParse(userInput.substring(0, yeetIndex)));
                //print("from 0 to $yeetIndex");
                print("Calculating:");
                print(parenthesisHolder);
                print(yeetIndex);
                print(parenthesisHolder.substring(0, yeetIndex));
                values.add(double.parse(parenthesisHolder.substring(0, yeetIndex)));
                parenthesisHolder =
                    parenthesisHolder.substring(yeetIndex, parenthesisHolder.length);
                if (parenthesisHolder.isNotEmpty) {
                  if (parenthesisHolder.contains('+') ||
                      parenthesisHolder.contains('-') ||
                      parenthesisHolder.contains('×') ||
                      parenthesisHolder.contains('÷') ||
                      parenthesisHolder.contains('^') ||
                      parenthesisHolder.contains('%')) {
                    print(parenthesisHolder[0]);
                    operations.add(parenthesisHolder[0]);
                    parenthesisHolder = parenthesisHolder.substring(1, parenthesisHolder.length);
                  }
                }
              } else {
                print("Verification return negative");
                print("$parenthesisHolder - done");
                values.add(double.parse(parenthesisHolder));
                parenthesisHolder = "";
                print(values);
                print(operations);
              }
            }
            //Uzyskaliśmy wszystkie informacje w postaci list. Pora obliczyć wynik.
            while (operations.contains('^')) {
              print("true 0");
              print(values);
              print(operations);
              idxExponentiation = operations.indexOf("^");
              print(operations.indexOf('^'));
              print("Reading:");
              if (operations.indexOf('^') - 1 >= 0) {
                if ((1 / values[operations.indexOf('^') + 1] / 2) % 1 == 0 &&
                    operations[operations.indexOf('^') - 1] == '-') {
                  values[operations.indexOf('^')] = log(-1);
                } else {
                  values[operations.indexOf('^')] =
                      pow(values[operations.indexOf('^')], values[operations.indexOf('^') + 1]);
                }
              } else {
                values[operations.indexOf('^')] =
                    pow(values[operations.indexOf('^')], values[operations.indexOf('^') + 1]);
              }
              values.removeAt(operations.indexOf('^') + 1);
              operations.removeAt(operations.indexOf('^'));
            }
            while (
                operations.contains('×') || operations.contains('÷') || operations.contains('%')) {
              print("true 1");
              if (operations.contains('×')) {
                idxMultiply = operations.indexOf('×');
              } else {
                idxMultiply = 16777216;
              }
              if (operations.contains('÷')) {
                idxDivide = operations.indexOf('÷');
              } else {
                idxDivide = 16777216;
              }
              if (operations.contains('%')) {
                idxModulo = operations.indexOf('%');
              } else {
                idxModulo = 16777216;
              }
              if (idxMultiply < idxDivide && idxMultiply < idxDivide) {
                print(operations.indexOf('×'));
                values[operations.indexOf('×')] =
                    values[operations.indexOf('×')] * values[operations.indexOf('×') + 1];
                values.removeAt(operations.indexOf('×') + 1);
                operations.removeAt(operations.indexOf('×'));
              } else if (idxDivide < idxMultiply && idxDivide < idxModulo) {
                print(operations.indexOf('÷'));
                values[operations.indexOf('÷')] =
                    values[operations.indexOf('÷')] / values[operations.indexOf('÷') + 1];
                values.removeAt(operations.indexOf('÷') + 1);
                operations.removeAt(operations.indexOf('÷'));
              } else {
                print(operations.indexOf('%'));
                values[operations.indexOf('%')] =
                    values[operations.indexOf('%')] % values[operations.indexOf('%') + 1];
                values.removeAt(operations.indexOf('%') + 1);
                operations.removeAt(operations.indexOf('%'));
              }
            }
            while (operations.contains('+') || operations.contains('-')) {
              print("true 2");
              if (operations.contains('+')) {
                idxAdd = operations.indexOf('+');
              } else {
                idxAdd = 16777216;
              }
              if (operations.contains('-')) {
                idxSubtract = operations.indexOf('-');
              } else {
                idxSubtract = 16777216;
              }
              if (idxAdd < idxSubtract) {
                print(operations.indexOf('+'));
                values[operations.indexOf('+')] =
                    values[operations.indexOf('+')] + values[operations.indexOf('+') + 1];
                values.removeAt(operations.indexOf('+') + 1);
                operations.removeAt(operations.indexOf('+'));
              } else {
                print(operations.indexOf('-'));
                values[operations.indexOf('-')] =
                    values[operations.indexOf('-')] - values[operations.indexOf('-') + 1];
                values.removeAt(operations.indexOf('-') + 1);
                operations.removeAt(operations.indexOf('-'));
              }
            }
            print(operations);
            print(values);
            parenthesisHolder = values[0].toString();
            print("replacing");
            print(parenthesisHolderBackup);
            print(parenthesisHolder);
            print(userInput.indexOf(parenthesisHolderBackup) - 1);
            if (userInput.indexOf(parenthesisHolderBackup) - 1 >= 0) {
              switch (userInput[userInput.indexOf(parenthesisHolderBackup) - 1]) {
                case 's':
                  {
                    print("Calculating sine");
                    if (mode == 'DEG') {
                      parenthesisHolder =
                          sin(double.parse(parenthesisHolder) * pi / 180).toString();
                    } else if (mode == 'RAD') {
                      parenthesisHolder = sin(double.parse(parenthesisHolder)).toString();
                    } else if (mode == 'GRAD') {
                      parenthesisHolder =
                          sin(double.parse(parenthesisHolder) * pi / 200).toString();
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'c':
                  {
                    print("Calculating cosine");
                    if (mode == 'DEG') {
                      parenthesisHolder =
                          cos(double.parse(parenthesisHolder) * pi / 180).toString();
                    } else if (mode == 'RAD') {
                      parenthesisHolder = cos(double.parse(parenthesisHolder)).toString();
                    } else if (mode == 'GRAD') {
                      parenthesisHolder =
                          cos(double.parse(parenthesisHolder) * pi / 200).toString();
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 't':
                  {
                    print("Calculating tangent");
                    if (mode == 'DEG') {
                      parenthesisHolder =
                          tan(double.parse(parenthesisHolder) * pi / 180).toString();
                    } else if (mode == 'RAD') {
                      parenthesisHolder = tan(double.parse(parenthesisHolder)).toString();
                    } else if (mode == 'GRAD') {
                      parenthesisHolder =
                          tan(double.parse(parenthesisHolder) * pi / 200).toString();
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'l':
                  {
                    print("Calculating log");
                    parenthesisHolder = (log(double.parse(parenthesisHolder)) / log(10)).toString();
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'n':
                  {
                    print("Calculating ln");
                    parenthesisHolder = log(double.parse(parenthesisHolder)).toString();
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'a':
                  {
                    print("Calculating abs");
                    parenthesisHolder = (double.parse(parenthesisHolder)).abs().toString();
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'f':
                  {
                    print("Calculating factorial");
                    if (double.parse(parenthesisHolder) <= 20) {
                      if (double.parse(parenthesisHolder) % 1 == 0) {
                        print("Input number is an integer");
                        fact = 1;
                        for (int k = 1; k <= double.parse(parenthesisHolder); k++) {
                          fact *= k;
                        }
                        parenthesisHolder = fact.toString();
                      } else {
                        print("Input number is not an integer");
                        showSnackBar(jezyk
                            ? 'Uwaga: silnia z liczby niecałkowitej może nie być w pełni dokładna'
                            : 'Note: factorial of a non-integer number might not be fully accurate');
                        parenthesisHolder = (sqrt(2 * pi * double.parse(parenthesisHolder)) *
                                pow(double.parse(parenthesisHolder) / e,
                                    double.parse(parenthesisHolder)))
                            .toString();
                      }
                    } else {
                      parenthesisHolder = "Infinity";
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'i':
                  {
                    print("Calculating arc sine");
                    if (mode == 'DEG') {
                      parenthesisHolder =
                          (asin(double.parse(parenthesisHolder)) * 180 / pi).toString();
                    } else if (mode == 'RAD') {
                      parenthesisHolder = asin(double.parse(parenthesisHolder)).toString();
                    } else if (mode == 'GRAD') {
                      parenthesisHolder =
                          (asin(double.parse(parenthesisHolder)) * 200 / pi).toString();
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'j':
                  {
                    print("Calculating arc cosine");
                    if (mode == 'DEG') {
                      parenthesisHolder =
                          (acos(double.parse(parenthesisHolder)) * 180 / pi).toString();
                    } else if (mode == 'RAD') {
                      parenthesisHolder = acos(double.parse(parenthesisHolder)).toString();
                    } else if (mode == 'GRAD') {
                      parenthesisHolder =
                          (acos(double.parse(parenthesisHolder)) * 200 / pi).toString();
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
                case 'k':
                  {
                    print("Calculating arc tangent");
                    if (mode == 'DEG') {
                      parenthesisHolder =
                          (atan(double.parse(parenthesisHolder)) * 180 / pi).toString();
                    } else if (mode == 'RAD') {
                      parenthesisHolder = atan(double.parse(parenthesisHolder)).toString();
                    } else if (mode == 'GRAD') {
                      parenthesisHolder =
                          (atan(double.parse(parenthesisHolder)) * 200 / pi).toString();
                    }
                    userInput =
                        userInput.substring(0, userInput.indexOf(parenthesisHolderBackup) - 1) +
                            userInput.substring(
                                userInput.indexOf(parenthesisHolderBackup), userInput.length);
                  }
                  break;
              }
            }
            userInput = userInput.replaceAll(parenthesisHolderBackup, parenthesisHolder);
            if (userInput.contains("NaN")) {
              userInput = 'NaN';
              break;
            }
          }
          userInput = double.parse(userInput).toStringAsFixed(14);
          userInput = double.parse(userInput).toString();
          userInput = userInput.replaceAll('.', ',');
          completed = true;
          if (userInput.substring(userInput.length - 2, userInput.length) == ',0') {
            userInput = userInput.substring(0, userInput.length - 2);
          }
          if (userInput == 'Infinity') {
            userInput = "";
            showSnackBar(jezyk
                ? "Nie można dzielić przez zero lub wynik przekracza zakres zmiennej"
                : "You can't divide by zero or the result exceeds the range of the variable");
          } else if (userInput == "-Infinity" || userInput == "NaN") {
            showSnackBar(jezyk
                ? "To wyrażenie nie ma rozwiązania w liczbach rzeczywistych"
                : "This expression has no solution in real numbers");
            userInput = "";
          }
          print('Process finished with output $userInput');
        }
        if (userInput.contains(',')) {
          commable = false;
        } else {
          commable = true;
        }
        openParentheses = 0;

        //koniec algorytmu obliczania

      } else if (text == "DEG" || text == "RAD" || text == "GRAD") {
        if (text == "DEG") {
          mode = "RAD";
        } else if (text == "RAD") {
          mode = "GRAD";
        } else if (text == "GRAD") {
          mode = "DEG";
        }
        Navigator.pop(context);
        operationsDLC();
        sleep(new Duration(milliseconds: 300));
      } else if ('√|x|n!loglnsin⁻¹cos⁻¹tg⁻¹'.contains(text)) {
        if (userInput.isNotEmpty) {
          if (userInput[userInput.length - 1] == ',') {
            userInput = userInput.substring(0, userInput.length - 1);
          }
          if (!operationSigns.contains(userInput[userInput.length - 1]) &&
              userInput[userInput.length - 1] != '(') {
            if (!commable) {
              while (userInput[userInput.length - 1] == '0') {
                userInput = userInput.substring(0, userInput.length - 1);
              }
              if (userInput[userInput.length - 1] == ',') {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            }
            userInput += "×";
            commable = true;
            zeroFriendly = false;
          }
        }
        if (text == '|x|') {
          userInput += 'abs';
        } else if (text == 'n!') {
          userInput += 'fact';
        } else if (text == 'sin⁻¹') {
          userInput += 'arcsin';
        } else if (text == 'cos⁻¹') {
          userInput += 'arccos';
        } else if (text == 'tg⁻¹') {
          userInput += 'arctg';
        } else {
          userInput += text;
        }
        userInput += '(';
        openParentheses++;
      } else if (text == '⅟x') {
        if (userInput.isNotEmpty) {
          while ('+-×÷(√mod'.contains(userInput[userInput.length - 1])) {
            if (userInput[userInput.length - 1] == '(') {
              openParentheses--;
            }
            userInput = userInput.substring(0, userInput.length - 1);
          }
          while (openParentheses > 0) {
            userInput += ")";
            openParentheses--;
          }
          userInput = '(' + userInput + ')^-1';
        } else {
          userInput = "1÷";
        }
      } else if (text == '10ˣ') {
        while ('+-×÷(√mod'.contains(userInput[userInput.length - 1])) {
          if (userInput[userInput.length - 1] == '(') {
            openParentheses--;
          }
          userInput = userInput.substring(0, userInput.length - 1);
        }
        while (openParentheses > 0) {
          userInput += ")";
          openParentheses--;
        }
        userInput = '10^(' + userInput + ')';
      } else if (text == 'MS') {
        print(userInput);
        if (!userInput.contains('+') &&
            !userInput.contains('-') &&
            !userInput.contains('×') &&
            !userInput.contains('÷') &&
            !userInput.contains('^') &&
            !userInput.contains('√') &&
            !userInput.contains('(') &&
            !userInput.contains(')') &&
            !userInput.contains('abs') &&
            !userInput.contains('fact') &&
            !userInput.contains('mod') &&
            !userInput.contains('log') &&
            !userInput.contains('ln') &&
            !userInput.contains('arcsin') &&
            !userInput.contains('arccos') &&
            !userInput.contains('arctg') &&
            !userInput.contains('sin') &&
            !userInput.contains('cos') &&
            !userInput.contains('tg')) {
          print("Write that down WRITE THAT DOWN!!!");
          print(userInput);
          memory = userInput;
          print(memory);
        } else if (!userInput.substring(1, userInput.length - 1).contains('+') &&
            !userInput.substring(1, userInput.length - 1).contains('-') &&
            !userInput.substring(1, userInput.length - 1).contains('×') &&
            !userInput.substring(1, userInput.length - 1).contains('÷') &&
            !userInput.substring(1, userInput.length - 1).contains('^') &&
            !userInput.substring(1, userInput.length - 1).contains('√') &&
            !userInput.substring(1, userInput.length - 1).contains('(') &&
            !userInput.substring(1, userInput.length - 1).contains(')') &&
            !userInput.substring(1, userInput.length - 1).contains('abs') &&
            !userInput.substring(1, userInput.length - 1).contains('fact') &&
            !userInput.substring(1, userInput.length - 1).contains('mod') &&
            !userInput.substring(1, userInput.length - 1).contains('log') &&
            !userInput.substring(1, userInput.length - 1).contains('ln') &&
            !userInput.substring(1, userInput.length - 1).contains('arcsin') &&
            !userInput.substring(1, userInput.length - 1).contains('arccos') &&
            !userInput.substring(1, userInput.length - 1).contains('arctg') &&
            !userInput.substring(1, userInput.length - 1).contains('sin') &&
            !userInput.substring(1, userInput.length - 1).contains('cos') &&
            !userInput.substring(1, userInput.length - 1).contains('tg') &&
            userInput != '-') {
          print("Write that down WRITE THAT DOWN!!!");
          print(userInput);
          memory = userInput;
          print(memory);
        } else {
          showSnackBar(jezyk
              ? "Najpierw oblicz działanie, używając znaku '='"
              : "Please first calculate the result using '=' sign");
        }
      } else if (text == 'MR') {
        if (userInput.isNotEmpty) {
          if (("0)" + numbersNoZero).contains(userInput[userInput.length - 1])) {
            userInput += '×';
          }
          if (userInput[userInput.length - 1] == '0') {
            if (userInput.length >= 2) {
              if (userInput[userInput.length - 2] == '(' ||
                  operationSigns.contains(userInput[userInput.length - 2])) {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            } else {
              userInput = "";
            }
          }
        }
        userInput += memory;
        if (memory.contains('1') ||
            memory.contains('2') ||
            memory.contains('3') ||
            memory.contains('4') ||
            memory.contains('5') ||
            memory.contains('6') ||
            memory.contains('7') ||
            memory.contains('8') ||
            memory.contains('9')) {
          zeroFriendly = true;
        } else {
          zeroFriendly = false;
        }
        if (memory.contains(',')) {
          commable = false;
        } else {
          commable = true;
        }
      } else if (text == 'π' || text == 'e') {
        if (userInput.isNotEmpty) {
          if (("0)" + numbersNoZero).contains(userInput[userInput.length - 1])) {
            userInput += '×';
            zeroFriendly = false;
          }
          if (userInput[userInput.length - 1] == '0') {
            if (userInput.length >= 2) {
              if (userInput[userInput.length - 2] == '(' ||
                  operationSigns.contains(userInput[userInput.length - 2])) {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            } else {
              userInput = "";
            }
          }
        }
        if (text == 'π') {
          userInput += pi.toString();
        } else {
          userInput += e.toString();
        }
        zeroFriendly = true;
        commable = false;
      } else if (text == '(') {
        if (userInput.isNotEmpty) {
          if (userInput[userInput.length - 1] == ',') {
            userInput = userInput.substring(0, userInput.length - 1);
          }
          if (!operationSigns.contains(userInput[userInput.length - 1]) &&
              userInput[userInput.length - 1] != '(') {
            if (!commable) {
              while (userInput[userInput.length - 1] == '0') {
                userInput = userInput.substring(0, userInput.length - 1);
              }
              if (userInput[userInput.length - 1] == ',') {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            }
            userInput += "×";
            commable = true;
            zeroFriendly = false;
          }
        }
        userInput += '(';
        openParentheses++;
      } else if (text == ')') {
        if (userInput.isNotEmpty) {
          if (openParentheses > 0 && userInput[userInput.length - 1] != "(") {
            if (userInput.length >= 2) {
              print(userInput.substring(userInput.length - 2, userInput.length));
              if (userInput.substring(userInput.length - 2, userInput.length) == '(-') {
                print(userInput.substring(userInput.length - 2, userInput.length));
                showSnackBar(jezyk
                    ? "Nie możesz zamknąć nawiasu bezpośrednio po jego otwarciu. Usuń nawias klawiszem ⌫ lub najpierw wprowadź zawartość nawiasu."
                    : "You can't close parentheses directly after opening it. Please first delete it using ⌫ or input contents of parentheses.");
              } else {
                if (operationSigns.contains(userInput[userInput.length - 1])) {
                  userInput = userInput.substring(0, userInput.length - 1);
                }
                if (!commable) {
                  while (userInput[userInput.length - 1] == '0') {
                    userInput = userInput.substring(0, userInput.length - 1);
                  }
                  if (userInput[userInput.length - 1] == ',') {
                    userInput = userInput.substring(0, userInput.length - 1);
                  }
                }
                userInput += ')';
                openParentheses--;
              }
            }
          } else {
            if (userInput[userInput.length - 1] == "(") {
              showSnackBar(jezyk
                  ? "Nie możesz zamknąć nawiasu bezpośrednio po jego otwarciu. Usuń nawias klawiszem ⌫ lub najpierw wprowadź zawartość nawiasu."
                  : "You can't close parentheses directly after opening it. Please first delete it using ⌫ or input contents of parentheses");
            } else {
              showSnackBar(jezyk
                  ? "Aby zamknąć nawias, musisz go najpierw otworzyć"
                  : "In order to close parentheses, you need to first open them");
            }
          }
        } else {
          showSnackBar(jezyk
              ? "Aby zamknąć nawias, musisz go najpierw otworzyć"
              : "In order to close parentheses, you need to first open them");
        }
      } else if (text == '+' ||
          text == '-' ||
          text == '×' ||
          text == '÷' ||
          text == 'xʸ' ||
          text == 'mod') {
        if (userInput.isNotEmpty) {
          if (userInput[userInput.length - 1] != '+' &&
              userInput[userInput.length - 1] != '-' &&
              userInput[userInput.length - 1] != '×' &&
              userInput[userInput.length - 1] != '÷' &&
              userInput[userInput.length - 1] != '^' &&
              userInput[userInput.length - 1] != 'd') {
            if (userInput[userInput.length - 1] == ',') {
              userInput = userInput.substring(0, userInput.length - 1);
            }
            if (!commable) {
              while (userInput[userInput.length - 1] == '0') {
                userInput = userInput.substring(0, userInput.length - 1);
              }
              if (userInput[userInput.length - 1] == ',') {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            }
            if (userInput[userInput.length - 1] == '(') {
              if (text == '-') {
                userInput += text;
              } else {
                showSnackBar(jezyk
                    ? "Nie można wstawić znaku operacji bezpośrednio po otwarciu nawiasu. Najpierw wprowadź liczbę"
                    : "You can't input an operation sign directly after opening parentheses. Please input a number first.");
              }
            } else {
              if (text == "xʸ") {
                userInput += "^";
              } else {
                userInput += text;
              }
            }
            commable = true;
            zeroFriendly = false;
          } else if (userInput[userInput.length - 1] == '-') {
            if (userInput != '-') {
              if (userInput.length >= 2) {
                if (userInput.substring(userInput.length - 2, userInput.length) == '×-' ||
                    userInput.substring(userInput.length - 2, userInput.length) == '÷-' ||
                    userInput.substring(userInput.length - 2, userInput.length) == '^-' ||
                    userInput.substring(userInput.length - 2, userInput.length) == 'd-') {
                  //tutaj robimy żeby ×- zmieniło się w +
                  userInput = userInput.substring(0, userInput.length - 2);
                  if (userInput.length >= 2) {
                    if (userInput.substring(userInput.length - 2, userInput.length) == 'mo') {
                      userInput = userInput.substring(0, userInput.length - 2);
                    }
                  }
                  userInput += text;
                }
              }
              if (userInput[userInput.length - 2] == '(' && text != '-') {
                userInput = userInput.substring(0, userInput.length - 1);
                showSnackBar(jezyk
                    ? "Nie można wstawić znaku operacji bezpośrednio po otwarciu nawiasu. Najpierw wprowadź liczbę"
                    : "You can't input an operation sign directly after opening parentheses. Please input a number first.");
              }
            } else if (text != '-') {
              userInput = "";
            }
          } else if (text == '-' && userInput[userInput.length - 1] == '×' ||
              text == '-' && userInput[userInput.length - 1] == '÷' ||
              text == '-' && userInput[userInput.length - 1] == '^' ||
              text == '-' && userInput[userInput.length - 1] == 'd') {
            if (text == "xʸ") {
              userInput += "^";
            } else {
              userInput += text;
            }
          } else {
            userInput = userInput.substring(0, userInput.length - 1);
            if (userInput[userInput.length - 1] == '×' || userInput[userInput.length - 1] == '÷') {
              userInput = userInput.substring(0, userInput.length - 1);
            }
            if (text == "xʸ") {
              userInput += "^";
            } else {
              userInput += text;
            }
          }
        } else if (text == '-') {
          userInput += text;
        }
        //aby nie było 5+-+4
      } else if (text == ',') {
        if (commable == true) {
          if (userInput.isNotEmpty) {
            if (userInput[userInput.length - 1] != '+' &&
                userInput[userInput.length - 1] != '-' &&
                userInput[userInput.length - 1] != '×' &&
                userInput[userInput.length - 1] != '÷' &&
                userInput[userInput.length - 1] != '^' &&
                userInput[userInput.length - 1] != 'd') {
              userInput += text;
              commable = false;
            }
          }
        } else {
          showSnackBar(
              jezyk ? "Ta liczba zawiera już przecinek" : "This number already contains a comma");
        }
      } else if (text == '0') {
        if (userInput.isNotEmpty) {
          if (commable == false ||
              zeroFriendly == true ||
              !numbersNoZero.contains(userInput[userInput.length - 1]) &&
                  userInput[userInput.length - 1] != '0') {
            userInput += '0';
          }
        } else {
          userInput = '0';
        }
      } else if (numbersNoZero.contains(text)) {
        if (userInput.isNotEmpty) {
          if (userInput[userInput.length - 1] == ')') {
            userInput += '×';
            commable = true;
            zeroFriendly = false;
          }
          if (userInput[userInput.length - 1] == '0') {
            if (userInput.length >= 2) {
              if (userInput[userInput.length - 2] == '(' ||
                  operationSigns.contains(userInput[userInput.length - 2])) {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            } else {
              userInput = "";
            }
          }
        }
        userInput += text;
        zeroFriendly = true;
        //dodanie tekstu. Ciekawe, czy to w ogóle przetrwa do końca. Pewnie nie. A może jednak.
      }
      if (userInput.length >= 15) {
        scaleFactor = 2;
      } else if (userInput.length >= 10) {
        scaleFactor = 3;
      } else {
        scaleFactor = 4;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        title: Text(jezyk ? 'Kalkulator' : 'Calculator'),
        centerTitle: true,
      ),
      body: Card(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Card(
                    child: Container(
                  constraints: new BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 16,
                  ),
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.NumPadBlue),
                  ),
                  child: Text(
                    userInput,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: scaleFactor,
                  ),
                ))),
            Expanded(
              flex: 2,
              child: Row(children: <Widget>[
                Expanded(child: Button('C', setTheValue, MyColors.NumPadBlue, Colors.white)),
                Expanded(child: Button('(', setTheValue, MyColors.NumPadBlue, Colors.white)),
                Expanded(child: Button(')', setTheValue, MyColors.NumPadBlue, Colors.white)),
                Expanded(child: Button('+', setTheValue, MyColors.NumPadBlue, Colors.white))
              ], crossAxisAlignment: CrossAxisAlignment.stretch),
            ),
            Expanded(
              flex: 2,
              child: Row(children: <Widget>[
                Expanded(child: Button('1', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('2', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('3', setTheValue, MyColors.NumPadWhite, Colors.black)),
                Expanded(child: Button('-', setTheValue, MyColors.NumPadBlue, Colors.white))
              ], crossAxisAlignment: CrossAxisAlignment.stretch),
            ),
            Expanded(
                flex: 2,
                child: Row(children: <Widget>[
                  Expanded(child: Button('4', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('5', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('6', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('×', setTheValue, MyColors.NumPadBlue, Colors.white))
                ], crossAxisAlignment: CrossAxisAlignment.stretch)),
            Expanded(
                flex: 2,
                child: Row(children: <Widget>[
                  Expanded(child: Button('7', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('8', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('9', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('÷', setTheValue, MyColors.NumPadBlue, Colors.white))
                ], crossAxisAlignment: CrossAxisAlignment.stretch)),
            Expanded(
                flex: 2,
                child: Row(children: <Widget>[
                  Expanded(child: Button(',', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('0', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('⌫', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('=', setTheValue, MyColors.NumPadBlue, Colors.white))
                ], crossAxisAlignment: CrossAxisAlignment.stretch)),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {
                        operationsDLC();
                      },
                      padding: EdgeInsets.all(8.0),
                      color: MyColors.NumPadBlue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      splashColor: MyColors.SecondaryBlueBright,
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
                      child: new Icon(Icons.keyboard_arrow_up),
                    ))
              ],
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ))
          ],
        ),
      ),
    );
  }

  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jezyk = prefs.getBool('polski') ?? true;
    });
  }
}

class Sheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(onClosing: null, builder: null);
  }
}

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
      ),
    );
  }
}
