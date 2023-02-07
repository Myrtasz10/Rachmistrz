import 'package:flutter/material.dart';

import './constant.dart';
import './colors.dart';
import './formula_list.dart';
import './operation.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConstantInfo extends StatefulWidget {
  // odebranie danych jakie wyslalem przez route_generator

  final Constant _constant;

  ConstantInfo(this._constant);

  @override
  _ConstantInfoState createState() => _ConstantInfoState();
}

class _ConstantInfoState extends State<ConstantInfo> {
  bool jezyk = true;
  @override
  void initState() {
    setState(() {
      readBool();
    });
    super.initState();
  }
  void readBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jezyk = prefs.getBool('polski') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        centerTitle: true,
        title: Text(widget._constant.name),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: MyColors.SecondaryBlue, width: 2), color: MyColors.NumPadWhite),
                child: Container(
                  margin: EdgeInsets.all(40),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget._constant.symbol + ' = ' + widget._constant.value.toString(),
                        style: TextStyle(fontSize: 28, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget._constant.unit,
                        style: TextStyle(fontSize: 30, color: Colors.black87),
                      ),
                      Container(height: 1, width: MediaQuery.of(context).size.width - 80)
                    ],
                  ),
                )),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(color: MyColors.SecondaryBlue, width: 2), color: MyColors.NumPadWhite),
              child: Container(
                child: Text(
                  widget._constant.shortinfo == null ? 'error' : widget._constant.shortinfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
                margin: EdgeInsets.all(30),
              ),
            ),


            IsItInAnyFormula()?
            Container(
              margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(border: Border.all(color: MyColors.SecondaryBlue, width: 2), color: MyColors.NumPadWhite),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      jezyk ? 'Występuje we Wzorach:' : 'Used in formulas:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, color: Colors.black87),
                    ),
                    Text(
                      ' ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, color: Colors.black87),
                    ),
                    Column(
                        children: FormulaList.getListOfFormulas().map((Operation op) {
                      if (op.isSomeStingHere(widget._constant.symbol)) {
                        return (Column(children: <Widget>[
                          Container(
                              child: AspectRatio(
                                  child: Container(
                                    child: GestureDetector(
                                      child: (op.operationImage == null
                                          ? (TeXView(
                                          renderingEngine: RenderingEngine.Katex,
                                          teXHTML: op.createKatexString()))
                                          : op.operationImage),
                                      onTap: () {
                                        Navigator.of(context).pushNamed('/formulas', arguments: op);
                                      },
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: MyColors.SecondaryBlue, width: 1)),
                                  ),
                                  aspectRatio: 6.8 / 2.7),
                              width: MediaQuery.of(context).size.width),
                          Container(
                            height: 10,
                          )
                        ]));
                      }
                      return (Container(
                        width: 0,
                        height: 0,
                      ));
                    }).toList())
                  ],
                ),
              ),
            ):Container(width: 0,height: 0)
          ],
        )),
      ),
    ));
  }

  bool IsItInAnyFormula(){
    bool exists = false;
    for(Operation op in FormulaList.getListOfFormulas())
      {
        if(op.getComponents().contains(widget._constant.symbol))
          {
            exists = true;
          }

      }

    return exists;

  }
}
