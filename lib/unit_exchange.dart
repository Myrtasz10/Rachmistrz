import 'package:flutter/material.dart';

import './colors.dart';
import './property.dart';
import './unit.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UnitExchange extends StatefulWidget {

  @override
  _UnitExchangeState createState() => _UnitExchangeState();
}

class _UnitExchangeState extends State<UnitExchange> {

  List<Property> properties;
  bool jezyk = true;

  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jezyk = prefs.getBool('polski') ?? true;
      print("$jezyk JD");
      if (jezyk) {
        properties = [
          Property(
              'Masa',
              [
                Unit('gram', 1, 'g'),
                Unit('elektronowolt', 1.783E-36, 'eV'),
                Unit('jednostka masy atomowej', 1.66E24, 'u'),
                Unit('funt', 453.592, 'lb'),
                Unit('uncja', 28.34, 'oz')
              ],
              "images/Masa.png"),
          Property(
              'Odleglość',
              [
                Unit('metr', 1, 'm'),
                Unit('cal', 0.0254, 'in'),
                Unit('stopa', 0.3048, 'ft'),
                Unit('jard', 0.9144, 'yd'),
                Unit('mila', 1609.344, 'mila'),
                Unit('mila morska', 1852, 'mila morska'),
                Unit('jednostka astronomiczna', 149597870700, 'au'),
                Unit('rok świetlny', 9.4607E15, 'ly')
              ],
              "images/Odleglosc.png"),
          Property(
              'Energia',
              [
                Unit('dżul', 1, 'J'),
                Unit('elektronowolt', 1.60210E-19, 'eV'),
                Unit('kaloria', 4.184, 'cal'),
                Unit('watogodzina', 3600, 'Wh')
              ],
              "images/energia.png"),
          Property(
              'Czas',
              [
                Unit('sekunda', 1, 's'),
                Unit('minuta', 60, 'min'),
                Unit('godzina', 3600, 'h'),
                Unit('dzień', 86400, 'd'),
                Unit('tydzień', 604800, 'tyg'),
                Unit('miesiąc', 2628000, 'mies'),
                Unit('rok', 31536000, 'y')
              ],
              'images/czas.png'),
          Property(
              'cisnienie',
              [
                Unit('paskal', 1, 'Pa'),
                Unit('atmosfera fizyczna', 1.01325E5, 'atm'),
                Unit('atmosfera techniczna', 9.80665E4, 'at'),
                Unit('bar', 10E5, 'bar'),
                Unit('tor', 133.332, 'Tr')
              ],
              'images/cisnienie.png'),
          Property(
            'powierzchnia',
            [
              Unit('metr kwadratowy', 1, 'm²'),
              Unit('cal kwadratowy', 0.0254 * 0.0254, 'in²'),
              Unit('stopa kwadratowa', 0.3048 * 0.3048, 'ft²'),
              Unit('jard kwadrtatowy', 0.9144 * 0.9144, 'yd²'),
              Unit('mila kwadratowa', 1609.344 * 1609.344, 'mila²'),
              Unit('mila morska kwadratowa', 1852.0 * 1852, 'mila morska²'),
              Unit('jednostka astronomiczna kwadratowa', 149597870700 * 149597870700.0, 'au²'),
              Unit('rok świetlny kwadratowy', 9.4607E15 * 9.4607E15, 'ly²'),
              Unit('Ar', 100, 'a'),
            ],
            "images/pole.png",
          ),
          Property(
            'objetosc',
            [
              Unit('metr sześcienny', 1, 'm³'),
              Unit('cal sześcienny', 0.0254 * 0.0254 * 0.0254, 'in³'),
              Unit('stopa sześcienna', 0.3048 * 0.3048 * 0.3048, 'ft³'),
              Unit('jard sześcienny', 0.9144 * 0.9144 * 0.9144, 'yd³'),
              Unit('mila sześcienna', 1609.344 * 1609.344 * 1609.344, 'mila³'),
              Unit('mila morska sześcienna', 1852 * 1852.0 * 1852, 'mila morska³'),
              Unit('jednostka astronomiczna sześcienna',
                  149597870700 * 149597870700 * 149597870700.0,
                  'au³'),
              Unit('rok świetlny sześcienny', 9.4607E15 * 9.4607E15 * 9.4607E15, 'ly³'),
              Unit('litr', 0.001, 'l'),
              Unit('Galon', 0.0045, 'gal'),
            ],
            'images/objetosc.png',
          ),
          Property(
              'prędkość',
              [
                Unit('metr na sekundę', 1, 'm/s'),
                Unit('metr na minutę', 1 / 60, 'm/min'),
                Unit('metr na godzinę', 1 / 3600, 'm/h'),
                Unit('mila na godzinę', (1 / 3600) * 1609.334, 'mph'),
                Unit('węzeł', 0.515, 'kts')
              ],
              'images/predkosc.png'),
          Property(
              'temperatura',
              [Unit('Celsjusz', 1, 'C'), Unit('Kelwin', 1, 'K'), Unit('Fahrenheit', 1, 'F')],
              'images/temperatura.png',
              1)
        ];
      } else {
        properties = [
          Property(
              'mass',
              [
                Unit('gram', 1, 'g'),
                Unit('electron Volt', 1.783E-36, 'eV'),
                Unit('unified atomic mass unit', 1.66E24, 'u'),
                Unit('pound', 453.592, 'lb'),
                Unit('ounce', 28.34, 'oz')
              ],
              "images/Masa.png"),
          Property(
              'distance',
              [
                Unit('meter', 1, 'm'),
                Unit('inch', 0.0254, 'in'),
                Unit('foot', 0.3048, 'ft'),
                Unit('yard', 0.9144, 'yd'),
                Unit('mile', 1609.344, 'mile'),
                Unit('nautical mile', 1852, 'nautical mile'),
                Unit('astronomical unit', 149597870700, 'au'),
                Unit('light year', 9.4607E15, 'ly')
              ],
              "images/Odleglosc.png"),
          Property(
              'energy',
              [
                Unit('joule', 1, 'J'),
                Unit('electron Volt', 1.60210E-19, 'eV'),
                Unit('calorie', 4.184, 'cal'),
                Unit('watt-hour', 3600, 'Wh')
              ],
              "images/energia.png"),
          Property(
              'time',
              [
                Unit('second', 1, 's'),
                Unit('minute', 60, 'min'),
                Unit('hour', 3600, 'h'),
                Unit('day', 86400, 'd'),
                Unit('week', 604800, 'week'),
                Unit('month', 2628000, 'mth'),
                Unit('year', 31536000, 'y')
              ],
              'images/czas.png'),
          Property(
              'pressure',
              [
                Unit('pascal', 1, 'Pa'),
                Unit('standard atmosphere', 1.01325E5, 'atm'),
                Unit('technical atmosphere', 9.80665E4, 'at'),
                Unit('bar', 10E5, 'bar'),
                Unit('torr', 133.332, 'Torr')
              ],
              'images/cisnienie.png'),
          Property(
            'area',
            [
              Unit('square meter', 1, 'm²'),
              Unit('square inch', 0.0254 * 0.0254, 'in²'),
              Unit('square foot', 0.3048 * 0.3048, 'ft²'),
              Unit('square yard', 0.9144 * 0.9144, 'yd²'),
              Unit('square mile', 1609.344 * 1609.344, 'mile²'),
              Unit('square nautical mile', 1852.0 * 1852, 'nautical mile²'),
              Unit('square astronomical unit', 149597870700 * 149597870700.0, 'au²'),
              Unit('square light year', 9.4607E15 * 9.4607E15, 'ly²'),
              Unit('Are', 100, 'a'),
            ],
            "images/pole.png",
          ),
          Property(
            'volume',
            [
              Unit('cubic meter', 1, 'm³'),
              Unit('cubic inch', 0.0254 * 0.0254 * 0.0254, 'in³'),
              Unit('cubic foot', 0.3048 * 0.3048 * 0.3048, 'ft³'),
              Unit('cubic yard', 0.9144 * 0.9144 * 0.9144, 'yd³'),
              Unit('cubic mile', 1609.344 * 1609.344 * 1609.344, 'mile³'),
              Unit('cubic nautical mile', 1852 * 1852.0 * 1852, 'nautical mile³'),
              Unit('cubic astronomical unit', 149597870700 * 149597870700 * 149597870700.0,
                  'au³'),
              Unit('cubic light year', 9.4607E15 * 9.4607E15 * 9.4607E15, 'ly³'),
              Unit('liter', 0.001, 'l'),
              Unit('gallon', 0.0045, 'gal'),
            ],
            'images/objetosc.png',
          ),
          Property(
              'speed',
              [
                Unit('meter per second', 1, 'm/s'),
                Unit('meter per minute', 1 / 60, 'm/min'),
                Unit('meter per hour', 1 / 3600, 'm/h'),
                Unit('mile per hour', (1 / 3600) * 1609.334, 'mph'),
                Unit('knot', 0.515, 'kts')
              ],
              'images/predkosc.png'),
          Property(
              'temperature',
              [Unit('Celsius', 1, 'C'), Unit('Kelvin', 1, 'K'), Unit('Fahrenheit', 1, 'F')],
              'images/temperatura.png',
              1)
        ];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      readBool();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.MainOrange,
          centerTitle: true,
          title: Text(jezyk ? 'Zamiana jednostek' : 'Unit exchange'),
        ),
        body: SingleChildScrollView(
            child: AspectRatio(
          aspectRatio: 1.8 / 5,
          child: Column(children: <Widget>[
            Expanded(
                child: Row(children: <Widget>[
              Expanded(child: properties[0]),
              Expanded(child: properties[1])
            ])),
            Expanded(
                child: Row(children: <Widget>[
              Expanded(child: properties[2]),
              Expanded(child: properties[3])
            ])),
            Expanded(
                child: Row(children: <Widget>[
              Expanded(child: properties[4]),
              Expanded(child: properties[5])
            ])),
            Expanded(
                child: Row(children: <Widget>[
              Expanded(child: properties[6]),
              Expanded(child: properties[7])
            ])),
            Expanded(
                child: Row(children: <Widget>[
                  Expanded(child: properties[8]),
                  Expanded(child: Container())
                ],
                )),
          ]),
        )));
  }
}
