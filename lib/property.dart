import 'package:flutter/material.dart';

import './colors.dart';
import './unit.dart';

class Property extends StatelessWidget {
  final String name;
  final List<Unit> units;
  final String image;
  final int specialLogicIndex;

  Property(this.name, this.units, this.image, [this.specialLogicIndex]);

  @override
  Widget build(BuildContext context) {
    return (Card(
      child: RaisedButton(
        child: Column(children: <Widget>[
          Image.asset(
            image,
          ),
          Text(name),
        ]),
        padding: EdgeInsets.all(8.0),
        color: MyColors.NumPadWhite,
        onPressed: () {
          Navigator.of(context).pushNamed('/exchangescreen', arguments: Property(name, units, image, specialLogicIndex));
        },
      ),
    ));
  }
//  @override
//  Widget build(BuildContext context) {
//    return (Container(
//        child: (RaisedButton(
//          color: Colors.white,
//          onPressed: () {
//            Navigator.of(context).pushNamed('/exchangescreen',
//                arguments: Property(name,units));
//          },
//          child: Container(
//            margin: EdgeInsets.all(20),
//            decoration: BoxDecoration(
//                color: MyColors.SecondaryBlueBright,
//                borderRadius: BorderRadius.all(Radius.circular(25)),
//                border: Border.all(color: MyColors.SecondaryBlue,width: 5)
//            ),
//            child: Center(child: Text(name,style:TextStyle(fontSize: 32),)),
//          ),
//        ))
//    ));
//  }
}
