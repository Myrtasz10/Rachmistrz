import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  AppSettings settings = new AppSettings();
  var langs = ['Polski', 'English'];
  var langss = ['English', 'Polski'];
  var langSelected;

  @override
  void initState() {
    super.initState();

    readBool('polski');
    readBool('Notation');
    readInt('PNUE');
    readInt('PNF');
    if (settings.precisionNumberFormulas == null) {
      settings.precisionNumberFormulas = 3;
      readInt('PNF');
    }
    if (settings.precisionNumberUE == null) {
      settings.precisionNumberUE = 3;
      readInt('PNUE');
    }
    if (settings.allwaysUseNotation == null) {
      settings.allwaysUseNotation = false;
      readBool('Notation');
    }
    if (settings.polski == null) {
      settings.polski = true;
      readBool('polski');
    }
    langSelected = settings.polski ? 'Polski' : 'English';
  }

  @override
  @override
  Widget build(BuildContext context) {
    setState(() {
      getLastSettings();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        title: Text(settings.polski ? "Ustawienia" : "Settings"),
        centerTitle: true,
      ),
      body: Card(
        child: Column(children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Text(
                settings.polski ? 'Zamiana jednostek' : 'Unit conversion',
                textAlign: TextAlign.center,
                textScaleFactor: 3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(children: <Widget>[
                Text(
                  settings.polski ? 'Zawsze używaj notacji wykładniczej' : 'Always use exponential notation',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                ),
                Switch(
                    value: settings.allwaysUseNotation,
                    onChanged: (newVal) {
                      setState(() {
                        settings.allwaysUseNotation = newVal;
                        wirteBool('Notation', newVal);
                      });
                    })
              ], mainAxisAlignment: MainAxisAlignment.center),
              Text(
                settings.polski ? 'Ilość liczb po przecinku ${settings.precisionNumberUE}' : 'Number of digits after decimal point ${settings.precisionNumberUE}',
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
              ),
              Slider(
                value: settings.precisionNumberUE.toDouble(),
                onChanged: (newValue) {
                  setState(() {
                    settings.precisionNumberUE = newValue.toInt();
                    writeInt('PNUE', settings.precisionNumberUE);
                  });
                },
                min: 1,
                max: 10,
                divisions: 9,
              ),
              Text(
                settings.polski ? 'Wzory' : 'Formulas',
                textAlign: TextAlign.center,
                textScaleFactor: 3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                settings.polski ? 'Ilość liczb po przecinku ${settings.precisionNumberFormulas}' : 'Number of digits after decimal point ${settings.precisionNumberFormulas}',
                textScaleFactor: 1.4,
                textAlign: TextAlign.center,
              ),
              Slider(
                value: settings.precisionNumberFormulas.toDouble(),
                onChanged: (newValue) {
                  setState(() {
                    settings.precisionNumberFormulas = newValue.toInt();
                    writeInt('PNF', settings.precisionNumberFormulas);
                  });
                },
                min: 1,
                max: 10,
                divisions: 9,
              ),
              Text(
                'Język/language',
                textAlign: TextAlign.center,
                textScaleFactor: 3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                items: langs.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem)
                  );
                }).toList(),
                onChanged: (String newValueSelected) {
                    setState(() {
                      this.langSelected = newValueSelected;
                      (langSelected == 'Polski') ? settings.polski = true : settings.polski = false;
                      wirteBool('polski', settings.polski);
                    });

                },
                value: settings.polski ? langs[0] : langs[1]
              )
            ],
          )),
        ]),
      ),
    );
  }

  void getLastSettings() {
    readInt('PNUE');
    readInt('PNF');
    readBool('Notation');
    readBool('polski');
  }

  void writeInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  void wirteBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void readInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (key == 'PNUE') {
        settings.precisionNumberUE = prefs.getInt(key) ?? 4;
      } else if (key == 'PNF') {
        settings.precisionNumberFormulas = prefs.getInt(key) ?? 4;
      }
    });
  }

  void readBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(key == 'Notation') {
        settings.allwaysUseNotation = prefs.getBool(key) ?? false;
      } else if (key == 'polski') {
        settings.polski = prefs.getBool(key) ?? true;
        print(prefs.getBool(key));
      }
    });
  }
}
//setstate przy zmianie, pierwszy argument
class AppSettings {
  bool allwaysUseNotation;
  int precisionNumberUE;
  int precisionNumberFormulas;
  bool polski;

  AppSettings({this.allwaysUseNotation, this.precisionNumberUE, this.precisionNumberFormulas, this.polski});
}
