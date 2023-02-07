import 'package:flutter/material.dart';

import './constant.dart';
import './colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants extends StatefulWidget {
  static List<Constant> constantsPL = [
    // tablica ze stalymi mozna latwo do niej cos dodac najlepiej jak kazda czesc by tak wygladala (0 hardcodowania)
    Constant('Stała grawitacji', 'G', 6.6742868E-11, 'm³/kg*s²', 'Służy do opisu pola grawitacyjnego.'),
    Constant('Prędkość światła w próżni', 'c', 299792458, 'm/s²', 'Prędkość z jaką światło porusza się w próżni'),
    Constant('Ładunek elementarny', 'e', 1.602176634E-19, 'C', 'Wartość ładunku elektrycznego niesionego przez proton'),
    Constant('Pi', 'π', 3.14159265359, '', 'Stosunek obwodu do średnicy koła'),
    Constant('Liczba Eulera', 'e', 2.718281828459, '', 'Podstawa logarytmu naturalnego'),
    Constant('Złota liczba', 'φ', 1.6180339887, '', 'Stosunek długości odcinka do długości jego krótszej części tak, że jest on równy stosunkowi długości dłuższej części do długości krótszej'),
    Constant('Stała Plancka', 'h', 6.626070040E-34, 'J*s', 'Stała używana w mechanice kwantowej'),
    Constant('Zredukowana stała Plancka', 'ħ', 1.05571800E-34, 'J*s', 'Stała Plancka podzielona przez 2π'),
  ];
  static List<Constant> constantsEN = [
    // tablica ze stalymi mozna latwo do niej cos dodac najlepiej jak kazda czesc by tak wygladala (0 hardcodowania)
    Constant('Gravitational constant', 'G', 6.6742868E-11, 'm³/kg*s²', 'Used in calculation of gravitational effects.'),
    Constant('Light speed in vacuum', 'c', 299792458, 'm/s²', 'Speed at which light travels in vacuum'),
    Constant('Elementary charge', 'e', 1.602176634E-19, 'C', 'The electric charge carried by a single proton'),
    Constant('Pi', 'π', 3.14159265359, '', "The ratio of a circle's circumference to its diameter"),
    Constant("Euler's number" , 'e', 2.718281828459, '', 'Base of natural logarithm'),
    Constant('Golden ratio', 'φ', 1.6180339887, '', 'ratio between the long and the short part of a line divided so that the long part divided by the short part is also equal to the whole length divided by the long part'),
    Constant("Planck constant", 'h', 6.626070040E-34, 'J*s', 'A constant used in quantum physics'),
    Constant("Reduced Planck constant", 'ħ', 1.05571800E-34, 'J*s', "Planck constant divided by 2π"),
  ];

  @override
  _ConstantsState createState() => _ConstantsState();
}

class _ConstantsState extends State<Constants> {
  bool jezyk = true;
  @override
  void initState() {
    readBool();
    super.initState();
  }
  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jezyk = prefs.getBool('polski') ?? true;
    });
  }
  @override //generowanie ekranu ze stalymi
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        centerTitle: true,
        title: Text('Stałe'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: jezyk ? Constants.constantsPL : Constants.constantsEN,
        ),
      ),
    );
  }
}

bool isItAConstant(String str) {
  bool valueToReturn = false;
  for (int i = 0; i < Constants.constantsPL.length; i++) {
    if (Constants.constantsPL.elementAt(i).symbol == str) {
      return true;
    }
  }

  return valueToReturn;
}

double getValueOfAConst(String srt) {
  for (int i = 0; i < Constants.constantsPL.length; i++) {
    if (srt == Constants.constantsPL.elementAt(i).symbol) {
      return Constants.constantsPL.elementAt(i).value;
    }
  }
  return 0;
}

//bool isItAConstant(String str) {
//  bool valueToReturn = false;
//  for (int i = 0; i < (_ConstantsState().jezyk ? Constants.constantsPL.length : Constants.constantsEN.length); i++) {
//    if (_ConstantsState().jezyk ? Constants.constantsPL.elementAt(i).symbol : Constants.constantsEN.elementAt(i).symbol == str) {
//      return true;
//    }
//  }
//  return valueToReturn;
//}
//
//double getValueOfAConst(String srt) {
//  for (int i = 0; i < (_ConstantsState().jezyk ? Constants.constantsPL.length : Constants.constantsEN.length); i++) {
//    if (srt == (_ConstantsState().jezyk ? Constants.constantsPL.elementAt(i).symbol : Constants.constantsPL.elementAt(i).symbol)) {
//      return (_ConstantsState().jezyk ? Constants.constantsPL.elementAt(i).value : Constants.constantsPL.elementAt(i).value);
//    }
//  }
//  return 0;
//}
