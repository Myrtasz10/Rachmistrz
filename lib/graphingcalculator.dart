import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testapp/calculator.dart';

import './colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphingCalculator extends StatefulWidget {
  @override
  _GraphingCalculatorState createState() => _GraphingCalculatorState();
}

class _GraphingCalculatorState extends State<GraphingCalculator> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar = new SnackBar(
      content: new Text(popText),
      duration: new Duration(seconds: 3),
    );
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
                  Expanded(child: Button('=', setTheValue, MyColors.NumPadWhite, Colors.black)),
                  Expanded(child: Button('none', setTheValue, MyColors.NumPadWhite, Colors.black)),
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

  List<FunctionOutput> functionsOutput = new List<FunctionOutput>();
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
      if (!operationSigns.contains(text) && completed == true) {
        userInput = "";
        commable = true;
        zeroFriendly = false;
      }
      completed = false;
      //po wykonaniu działania czyścimy userInput
      if (text == 'C') {
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

        } //backspace, w dwóch warunkach aby nie powodować wyjątków a zarazem nie wrzucać backspace do tekstu

        //algorytm obliczenia
      } else if (text == '=') {
          calcualte();
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

        if(!(text=='x'))
          {
            userInput += '(';
            openParentheses++;

          }


      } else if (text == '⅟x') {
        if(userInput.isNotEmpty) {
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
      }
      else if (text == 'π' || text == 'e') {
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

              if (userInput.substring(userInput.length - 2, userInput.length) == '(-') {

                showSnackBar(jezyk ?
                    "Nie możesz zamknąć nawiasu bezpośrednio po jego otwarciu. Usuń nawias klawiszem ⌫ lub najpierw wprowadź zawartość nawiasu." :
                "You can't close parentheses directly after opening it. Please first delete it using ⌫ or input contents of parentheses.");
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
              showSnackBar(jezyk ?
                  "Nie możesz zamknąć nawiasu bezpośrednio po jego otwarciu. Usuń nawias klawiszem ⌫ lub najpierw wprowadź zawartość nawiasu." :
                  "You can't close parentheses directly after opening it. Please first delete it using ⌫ or input contents of parentheses");
            } else {
              showSnackBar(jezyk ? "Aby zamknąć nawias, musisz go najpierw otworzyć" : "In order to close parentheses, you need to first open them");
            }
          }
        } else {
          showSnackBar(jezyk ? "Aby zamknąć nawias, musisz go najpierw otworzyć" : "In order to close parentheses, you need to first open them");
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
                showSnackBar(jezyk ?
                    "Nie można wstawić znaku operacji bezpośrednio po otwarciu nawiasu. Najpierw wprowadź liczbę" : "You can't input an operation sign directly after opening parentheses. Please input a number first.");
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
                showSnackBar(
                    jezyk ?
                    "Nie można wstawić znaku operacji bezpośrednio po otwarciu nawiasu. Najpierw wprowadź liczbę" : "You can't input an operation sign directly after opening parentheses. Please input a number first.");
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
          showSnackBar(jezyk ? "Ta liczba zawiera już przecinek" : "This number already contains a comma");
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
  void calcualte(){

    for(int i = -20000; i<=20000;i++)
      {

        String newuserInput = userInput.replaceAll('x', (double.parse(i.toString())/100).toString());


        double newscaleFactor = scaleFactor;
        bool newcommable = commable;
        bool newzeroFriendly = zeroFriendly;
        int newopenParentheses = openParentheses;

        String newmode = mode;

        List<double> newvalues = values;
        List<String> newoperations = operations;

        int newclosingParenthesis = closingParenthesis;

        int newwalkinIndex = walkinIndex; //dis index be walkin'
        int newmaxDepth = maxDepth;
        int newcurrentDepth = currentDepth;
        int newissueIndex = issueIndex;
        String newparenthesisHolder = parenthesisHolder; //pretty self-explanatory
        String newparenthesisHolderBackup = parenthesisHolderBackup;
        bool newinterpretable = interpretable;
        int newi = i;
        int newfact = fact;

        bool newcompleted = completed; //aby kasować wszystko po wciśnięciu czegoś po "="
        int newyeetIndex = yeetIndex; //jak duża jest liczba, jaką należy yeetnąć?

        int newidxAdd = idxAdd;
        int newidxSubtract = idxSubtract;
        int newidxMultiply = idxMultiply;
        int newidxDivide = idxDivide;
        int newidxExponentiation = idxExponentiation;
        int newidxModulo = idxModulo;








        newinterpretable = true;
        newuserInput = newuserInput.replaceAll(',', '.');
        try {
          while (operationSigns.contains(newuserInput[newuserInput.length - 1]) ||
              newuserInput[newuserInput.length - 1] == '(' ||
              newuserInput[newuserInput.length - 1] == ',') {
            if (newuserInput[newuserInput.length - 1] == '(') {
              newopenParentheses--;
            }
            newuserInput = newuserInput.substring(0, newuserInput.length - 1);
          }
        } catch (e) {

         continue;
        }
        if (!newuserInput.contains('+') &&
            !newuserInput.contains('-') &&
            !newuserInput.contains('×') &&
            !newuserInput.contains('÷') &&
            !newuserInput.contains('^') &&
            !newuserInput.contains('√') &&
            !newuserInput.contains('abs') &&
            !newuserInput.contains('fact') &&
            !newuserInput.contains('mod') &&
            !newuserInput.contains('log') &&
            !newuserInput.contains('ln') &&
            !newuserInput.contains('arcsin') &&
            !newuserInput.contains('arccos') &&
            !newuserInput.contains('arctg') &&
            !newuserInput.contains('sin') &&
            !newuserInput.contains('cos') &&
            !newuserInput.contains('tg')) {
          newinterpretable = false;
          functionsOutput.add(new FunctionOutput(double.parse(i.toString())/100, double.parse(newuserInput.replaceAll(',', '.'))));
        }
        if (newinterpretable) {
          //kompilacja
          if (newuserInput[0] == '-') {
            newuserInput = "0" + newuserInput; //obejście minusa na początku przez dodanie zera XD
          }
          if (operationSigns.contains(newuserInput[newuserInput.length - 1])) {
            newuserInput = newuserInput.substring(0, newuserInput.length - 1);
          }
          while (newopenParentheses > 0) {
            newuserInput += ")";
            newopenParentheses--;
          }
          newwalkinIndex = 0;
          newuserInput = newuserInput.replaceAll('abs', 'a');
          newuserInput = newuserInput.replaceAll('fact', 'f');
          newuserInput = newuserInput.replaceAll('mod', '%');
          newuserInput = newuserInput.replaceAll('log', 'l');
          newuserInput = newuserInput.replaceAll('ln', 'n');
          newuserInput = newuserInput.replaceAll('arcsin', 'i');
          newuserInput = newuserInput.replaceAll('arccos', 'j');
          newuserInput = newuserInput.replaceAll('arctg', 'k');
          newuserInput = newuserInput.replaceAll('sin', 's');
          newuserInput = newuserInput.replaceAll('cos', 'c');
          newuserInput = newuserInput.replaceAll('tg', 't');

          while (newuserInput.contains('√')) {
            newi = newuserInput.indexOf('√') + 1;
            do {

              if (newuserInput[newi] == '(') {
                newwalkinIndex++;
              } else if (newuserInput[newi] == ')') {
                newwalkinIndex--;
              }
              newi++;
            } while (newwalkinIndex > 0);


            newuserInput = newuserInput.replaceAll(newuserInput.substring(newuserInput.indexOf('√'), i),
                newuserInput.substring(newuserInput.indexOf('√') + 1, i) + "^0.5");
          }
          newuserInput = "(" + newuserInput + ")";
          //koniec kompilacji
          while (newuserInput.contains('(')) {

            newoperations.clear();
            newvalues.clear();
            newwalkinIndex = 0;
            newcurrentDepth = 0;
            newmaxDepth = 0;
            newissueIndex = 0;

            newuserInput = newuserInput.replaceAll('--', '+');
            newuserInput = newuserInput.replaceAll('(+', '(');

            while (newuserInput.length > newwalkinIndex) {
              if (newuserInput[newwalkinIndex] == '(') {
                newcurrentDepth++;
                if (newcurrentDepth > newmaxDepth) {
                  newmaxDepth = newcurrentDepth;
                  newissueIndex = newwalkinIndex;
                }
              } else if (newuserInput[newwalkinIndex] == ')') {
                newcurrentDepth--;
              }
              newwalkinIndex++;
            }

            newparenthesisHolder = newuserInput.substring(
                newissueIndex,
                newuserInput.substring(newissueIndex, newuserInput.length).indexOf(')') +
                    newuserInput.substring(0, newissueIndex).length +
                    1);

            newparenthesisHolderBackup = newparenthesisHolder;
            newparenthesisHolder = newparenthesisHolder.substring(1, newparenthesisHolder.length - 1);
            if (newparenthesisHolder[0] == '-') {
              newparenthesisHolder = '0' + newparenthesisHolder;
            }

            while (newparenthesisHolder.isNotEmpty) {

              //upewnienie się, że userInput posiada prawidłowe działanie
              if (newparenthesisHolder.contains('+') &&
                  !operationSigns.contains(newparenthesisHolder[newparenthesisHolder.length - 1]) ||
                  newparenthesisHolder.contains('-') &&
                      newparenthesisHolder[0] != '-' &&
                      !operationSigns.contains(newparenthesisHolder[newparenthesisHolder.length - 1]) ||
                  newparenthesisHolder.contains('×') &&
                      !operationSigns.contains(newparenthesisHolder[newparenthesisHolder.length - 1]) ||
                  newuserInput.contains('÷') &&
                      !operationSigns.contains(newparenthesisHolder[newparenthesisHolder.length - 1]) ||
                  newuserInput.contains('^') &&
                      !operationSigns.contains(newparenthesisHolder[newparenthesisHolder.length - 1]) ||
                  newuserInput.contains('%') &&
                      !operationSigns.contains(newparenthesisHolder[newparenthesisHolder.length - 1])) {
                //sprawdzanie, który znak jest pierwszy
                if (newparenthesisHolder.contains('+')) {
                  newidxAdd = newparenthesisHolder.indexOf('+');
                } else {
                  newidxAdd = 16777216;
                }
                //próba obejścia interpretacji znaku "-" jako operacji
                if (newparenthesisHolder.contains('-')) {
                  newidxSubtract = newparenthesisHolder.indexOf('-');
                  if (newidxSubtract == 0) {
                    if (newparenthesisHolder.length > 1) {
                      if (newparenthesisHolder.substring(1, newparenthesisHolder.length).contains('-')) {
                        newidxSubtract =
                            newparenthesisHolder.substring(1, newparenthesisHolder.length).indexOf('-');
                      } else {
                        newidxSubtract = 16777216;
                      }
                    } else {
                      newidxSubtract = 16777216;
                    }
                  }
                } else {
                  newidxSubtract = 16777216;
                }
                if (newparenthesisHolder.contains('×')) {
                  newidxMultiply = newparenthesisHolder.indexOf('×');
                } else {
                  newidxMultiply = 16777216;
                }
                if (newparenthesisHolder.contains('÷')) {
                  newidxDivide = newparenthesisHolder.indexOf('÷');
                } else {
                  newidxDivide = 16777216;
                }
                if (newparenthesisHolder.contains('^')) {
                  newidxExponentiation = newparenthesisHolder.indexOf('^');
                } else {
                  newidxExponentiation = 16777216;
                }
                if (newparenthesisHolder.contains('%')) {
                  newidxModulo = newparenthesisHolder.indexOf('%');
                } else {
                  newidxModulo = 16777216;
                }
                if (newidxAdd < newidxSubtract &&
                    newidxAdd < newidxMultiply &&
                    newidxAdd < newidxDivide &&
                    newidxAdd < newidxExponentiation &&
                    newidxAdd < newidxModulo) {
                  newyeetIndex = newidxAdd;
                } else if (newidxSubtract < newidxAdd &&
                    newidxSubtract < newidxMultiply &&
                    newidxSubtract < newidxDivide &&
                    newidxSubtract < newidxExponentiation &&
                    newidxSubtract < newidxModulo) {
                  newyeetIndex = newidxSubtract;
                } else if (newidxMultiply < newidxAdd &&
                    newidxMultiply < newidxSubtract &&
                    newidxMultiply < newidxDivide &&
                    newidxMultiply < newidxExponentiation &&
                    newidxMultiply < newidxModulo) {
                  newyeetIndex = newidxMultiply;
                } else if (newidxDivide < newidxAdd &&
                    newidxDivide < newidxSubtract &&
                    newidxDivide < newidxMultiply &&
                    newidxDivide < newidxExponentiation &&
                    newidxDivide < newidxModulo) {
                  newyeetIndex = newidxDivide;
                } else if (newidxExponentiation < newidxAdd &&
                    newidxExponentiation < newidxSubtract &&
                    newidxExponentiation < newidxMultiply &&
                    newidxExponentiation < newidxDivide &&
                    newidxExponentiation < newidxModulo) {
                  newyeetIndex = newidxExponentiation;
                } else if (newidxModulo < newidxAdd &&
                    newidxModulo < newidxSubtract &&
                    newidxModulo < newidxMultiply &&
                    newidxModulo < newidxDivide &&
                    newidxModulo < newidxExponentiation) {
                  newyeetIndex = newidxModulo;
                } else {

                  newyeetIndex = newparenthesisHolder.length;
                }

                newvalues.add(double.parse(newparenthesisHolder.substring(0, newyeetIndex)));
                newparenthesisHolder =
                    newparenthesisHolder.substring(newyeetIndex, newparenthesisHolder.length);
                if (newparenthesisHolder.isNotEmpty) {
                  if (newparenthesisHolder.contains('+') ||
                      newparenthesisHolder.contains('-') ||
                      newparenthesisHolder.contains('×') ||
                      newparenthesisHolder.contains('÷') ||
                      newparenthesisHolder.contains('^') ||
                      newparenthesisHolder.contains('%')) {

                    newoperations.add(newparenthesisHolder[0]);
                    newparenthesisHolder = newparenthesisHolder.substring(1, newparenthesisHolder.length);
                  }
                }
              } else {

                newvalues.add(double.parse(newparenthesisHolder));
                newparenthesisHolder = "";

              }
            }
            //Uzyskaliśmy wszystkie informacje w postaci list. Pora obliczyć wynik.
            while (newoperations.contains('^')) {

              newidxExponentiation = newoperations.indexOf("^");

              if (newoperations.indexOf('^') - 1 >= 0) {
                if ((1 / newvalues[newoperations.indexOf('^') + 1] / 2) % 1 == 0 &&
                    newoperations[newoperations.indexOf('^') - 1] == '-') {
                  newvalues[newoperations.indexOf('^')] = log(-1);
                } else {
                  newvalues[newoperations.indexOf('^')] =
                      pow(newvalues[newoperations.indexOf('^')], newvalues[newoperations.indexOf('^') + 1]);
                }
              } else {
                newvalues[newoperations.indexOf('^')] =
                    pow(newvalues[newoperations.indexOf('^')], newvalues[newoperations.indexOf('^') + 1]);
              }
              newvalues.removeAt(newoperations.indexOf('^') + 1);
              newoperations.removeAt(newoperations.indexOf('^'));
            }
            while (
            newoperations.contains('×') || newoperations.contains('÷') || newoperations.contains('%')) {

              if (newoperations.contains('×')) {
                newidxMultiply = newoperations.indexOf('×');
              } else {
                newidxMultiply = 16777216;
              }
              if (newoperations.contains('÷')) {
                newidxDivide = newoperations.indexOf('÷');
              } else {
                newidxDivide = 16777216;
              }
              if (newoperations.contains('%')) {
                newidxModulo = newoperations.indexOf('%');
              } else {
                newidxModulo = 16777216;
              }
              if (newidxMultiply < newidxDivide && newidxMultiply < newidxDivide) {

                newvalues[newoperations.indexOf('×')] =
                    newvalues[newoperations.indexOf('×')] * newvalues[newoperations.indexOf('×') + 1];
                newvalues.removeAt(newoperations.indexOf('×') + 1);
                newoperations.removeAt(newoperations.indexOf('×'));
              } else if (newidxDivide < newidxMultiply && newidxDivide < newidxModulo) {

                newvalues[newoperations.indexOf('÷')] =
                    newvalues[newoperations.indexOf('÷')] / newvalues[newoperations.indexOf('÷') + 1];
                newvalues.removeAt(newoperations.indexOf('÷') + 1);
                newoperations.removeAt(newoperations.indexOf('÷'));
              } else {

                newvalues[newoperations.indexOf('%')] =
                    newvalues[newoperations.indexOf('%')] % newvalues[newoperations.indexOf('%') + 1];
                newvalues.removeAt(newoperations.indexOf('%') + 1);
                newoperations.removeAt(newoperations.indexOf('%'));
              }
            }
            while (newoperations.contains('+') || newoperations.contains('-')) {

              if (newoperations.contains('+')) {
                newidxAdd = newoperations.indexOf('+');
              } else {
                newidxAdd = 16777216;
              }
              if (newoperations.contains('-')) {
                newidxSubtract = newoperations.indexOf('-');
              } else {
                newidxSubtract = 16777216;
              }
              if (newidxAdd < newidxSubtract) {

                newvalues[newoperations.indexOf('+')] =
                    newvalues[newoperations.indexOf('+')] + newvalues[newoperations.indexOf('+') + 1];
                newvalues.removeAt(newoperations.indexOf('+') + 1);
                newoperations.removeAt(newoperations.indexOf('+'));
              } else {

                newvalues[newoperations.indexOf('-')] =
                    newvalues[newoperations.indexOf('-')] - newvalues[newoperations.indexOf('-') + 1];
                newvalues.removeAt(newoperations.indexOf('-') + 1);
                newoperations.removeAt(newoperations.indexOf('-'));
              }
            }

            newparenthesisHolder = newvalues[0].toString();

            if (newuserInput.indexOf(newparenthesisHolderBackup) - 1 >= 0) {
              switch (newuserInput[newuserInput.indexOf(newparenthesisHolderBackup) - 1]) {
                case 's':
                  {

                    if (newmode == 'DEG') {
                      newparenthesisHolder =
                          sin(double.parse(newparenthesisHolder) * pi / 180).toString();
                    } else if (newmode == 'RAD') {
                      newparenthesisHolder = sin(double.parse(newparenthesisHolder)).toString();
                    } else if (newmode == 'GRAD') {
                      newparenthesisHolder =
                          sin(double.parse(newparenthesisHolder) * pi / 200).toString();
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'c':
                  {

                    if (newmode == 'DEG') {
                      newparenthesisHolder =
                          cos(double.parse(newparenthesisHolder) * pi / 180).toString();
                    } else if (newmode == 'RAD') {
                      newparenthesisHolder = cos(double.parse(newparenthesisHolder)).toString();
                    } else if (newmode == 'GRAD') {
                      newparenthesisHolder =
                          cos(double.parse(newparenthesisHolder) * pi / 200).toString();
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 't':
                  {

                    if (newmode == 'DEG') {
                      newparenthesisHolder =
                          tan(double.parse(newparenthesisHolder) * pi / 180).toString();
                    } else if (newmode == 'RAD') {
                      newparenthesisHolder = tan(double.parse(newparenthesisHolder)).toString();
                    } else if (newmode == 'GRAD') {
                      newparenthesisHolder =
                          tan(double.parse(newparenthesisHolder) * pi / 200).toString();
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'l':
                  {

                    newparenthesisHolder = (log(double.parse(newparenthesisHolder)) / log(10)).toString();
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'n':
                  {

                    newparenthesisHolder = log(double.parse(newparenthesisHolder)).toString();
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'a':
                  {

                    newparenthesisHolder = (double.parse(newparenthesisHolder)).abs().toString();
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'f':
                  {
                    if (double.parse(newparenthesisHolder) <= 20) {

                      if (double.parse(newparenthesisHolder) % 1 == 0) {

                        newfact = 1;
                        for (int k = 1; k <= double.parse(newparenthesisHolder); k++) {
                          newfact *= k;

                        }
                        newparenthesisHolder = newfact.toString();
                      } else {


                        newparenthesisHolder = (sqrt(2 * pi * double.parse(newparenthesisHolder)) *
                            pow(double.parse(newparenthesisHolder) / e,
                                double.parse(newparenthesisHolder)))
                            .toString();
                      }
                    } else {
                      newparenthesisHolder = 'Infinity';
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'i':
                  {

                    if (newmode == 'DEG') {
                      newparenthesisHolder =
                          (asin(double.parse(newparenthesisHolder)) * 180 / pi).toString();
                    } else if (newmode == 'RAD') {
                      newparenthesisHolder = asin(double.parse(newparenthesisHolder)).toString();
                    } else if (newmode == 'GRAD') {
                      newparenthesisHolder =
                          (asin(double.parse(newparenthesisHolder)) * 200 / pi).toString();
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'j':
                  {

                    if (newmode == 'DEG') {
                      newparenthesisHolder =
                          (acos(double.parse(newparenthesisHolder)) * 180 / pi).toString();
                    } else if (newmode == 'RAD') {
                      newparenthesisHolder = acos(double.parse(newparenthesisHolder)).toString();
                    } else if (newmode == 'GRAD') {
                      newparenthesisHolder =
                          (acos(double.parse(newparenthesisHolder)) * 200 / pi).toString();
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
                case 'k':
                  {

                    if (newmode == 'DEG') {
                      newparenthesisHolder =
                          (atan(double.parse(newparenthesisHolder)) * 180 / pi).toString();
                    } else if (newmode == 'RAD') {
                      newparenthesisHolder = atan(double.parse(newparenthesisHolder)).toString();
                    } else if (newmode == 'GRAD') {
                      newparenthesisHolder =
                          (atan(double.parse(newparenthesisHolder)) * 200 / pi).toString();
                    }
                    newuserInput =
                        newuserInput.substring(0, newuserInput.indexOf(newparenthesisHolderBackup) - 1) +
                            newuserInput.substring(
                                newuserInput.indexOf(newparenthesisHolderBackup), newuserInput.length);
                  }
                  break;
              }
            }
            newuserInput = newuserInput.replaceAll(newparenthesisHolderBackup,newparenthesisHolder);
            if (newuserInput.contains("NaN")) {
              newuserInput = 'NaN';
              break;
            }
          }
          newuserInput = double.parse(newuserInput).toStringAsFixed(14);
          newuserInput = double.parse(newuserInput).toString();
          newuserInput = newuserInput.replaceAll('.', ',');
          newcompleted = true;
          if (newuserInput.substring(newuserInput.length - 2, newuserInput.length) == ',0') {
            newuserInput = newuserInput.substring(0, newuserInput.length - 2);
          }
          if (newuserInput == 'Infinity') {
            newuserInput = "";
            showSnackBar(jezyk ? "Nie można dzielić przez zero lub wynik przekracza zakres zmiennej" : "You can't divide by zero or the result exceeds the range of the variable");
          } else if (newuserInput == "-Infinity" || newuserInput == "NaN") {
           continue;
          }

         functionsOutput.add(new FunctionOutput(double.parse(i.toString())/100, double.tryParse(newuserInput.replaceAll(',', '.'))));

        }
        if (newuserInput.contains(',')) {
          newcommable = false;
        } else {
          newcommable = true;
        }
        newopenParentheses = 0;





      }

      Navigator.of(context).pushNamed('/graph_view',arguments: functionsOutput);
      functionsOutput = new List<FunctionOutput>();

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
                        minWidth: MediaQuery.of(context).size.width-16,
                      ),
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.NumPadBlue),
              ),
              child: Text(
                "f(x)=" + userInput,
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
                  Expanded(child: Button('x', setTheValue, MyColors.NumPadBlue, Colors.white))
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

class FunctionOutput{
  double x;
  double y;

  FunctionOutput(double input,double output){

    x = input;
    y = output;


  }







}
