import 'package:flutter/material.dart';

import './route_generator.dart';
import './colors.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rachmistrz',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

//Początkowy Ekran
class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  bool jezyk;

  @override
  void initState() {
    setState(() {
      readBool();
    });
    super.initState();
    print(jezyk);
  }

  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jezyk = prefs.getBool('polski') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      readBool();
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.MainOrange,
        centerTitle: true,
        title: Text('Rachmistrz'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          )
        ],
      ),
      body: Column(
        //Przyciski
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: RaisedButton(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset('images/stale.png'),
                            flex: 6,
                          ),
                          Container(height: 10),
                          Expanded(
                            child: Text(jezyk ? 'stałe' : 'constants'),
                            flex: 1,
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      padding: EdgeInsets.all(8.0),
                      color: MyColors.MenuButton,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/constants');
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Card(
                  child: RaisedButton(
                    child:Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset('images/wzory.png'),
                          flex: 6,
                        ),
                        Container(height: 10),
                        Expanded(
                          child: Text(jezyk ? 'wzory' : 'formulas'),
                          flex: 1,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    padding: EdgeInsets.all(8.0),
                    color: MyColors.MenuButton,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/formula_list');
                    },
                  ),
                ))
              ],
            ),
          ),
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: RaisedButton(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset('images/Kalkulator.png'),
                          flex: 6,
                        ),
                        Container(height: 10),
                        Expanded(
                          child: Text(jezyk ? 'kalkulator' : 'calculator'),
                          flex: 1,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    padding: EdgeInsets.all(8.0),
                    color: MyColors.MenuButton,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/calculator');
                    },
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                child: RaisedButton(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset('images/Zamiana.png'),
                        flex: 6,
                      ),
                      Container(height: 10),
                      Expanded(
                        child: Text(jezyk ? 'zamiana jednostek' : 'unit conversion'),
                        flex: 1,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.all(8.0),
                  color: MyColors.MenuButton,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/unit_exchange');
                  },
                ),
              ))
            ],
          )),
          Expanded(
              child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: RaisedButton(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset('images/funkcja.png'),
                          flex: 6,
                        ),
                        Container(height: 10),
                        Expanded(
                          child: Text(jezyk ? 'funkcje' : 'functions'),
                          flex: 1,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    padding: EdgeInsets.all(8.0),
                    color: MyColors.MenuButton,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/graph');
                    },
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                child: RaisedButton(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset('images/rownanie.png'),
                        flex: 6,
                      ),
                      Container(height: 10),
                      Expanded(
                        child: Text(jezyk ? 'rozwiązywanie równań' : 'equation solver'),
                        flex: 1,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.all(8.0),
                  color: MyColors.MenuButton,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/equation_solver');
                  },
                ),
              ))
            ],
          )),
        ],
      ),
    );
  }
}
