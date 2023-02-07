import 'package:flutter/material.dart';

import './operation.dart';
import './colors.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormulaList extends StatefulWidget {

  static List<Operation> getListOfFormulas() {

    return [
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'E', null, null),
          Operation(
              Operations.division,
              null,
              Operation(
                  Operations.multiplication,
                  null,
                  Operation(Operations.single, 'm', null, null),
                  Operation(
                      Operations.exponentiation,
                      null,
                      Operation(Operations.single, 'v', null, null),
                      Operation(Operations.single, '2', null, null, num: 2))),
              Operation(Operations.single, '2', null, null, num: 2)),
          image: FormulaImage('images/emv22.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'E', null, null),
          Operation(
              Operations.multiplication,
              null,
              Operation(Operations.single, 'm', null, null, num: 2),
              Operation(
                  Operations.exponentiation,
                  null,
                  Operation(Operations.single, 'c', null, null),
                  Operation(Operations.single, '2', null, null, num: 2))),
          image: FormulaImage('images/emc2.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, "F", null, null),
          Operation(
              Operations.division,
              null,
              Operation(
                  Operations.multiplication,
                  null,
                  Operation(Operations.single, "m", null, null),
                  Operation(
                      Operations.exponentiation,
                      null,
                      Operation(Operations.single, "v", null, null),
                      Operation(Operations.single, "2", null, null, num: 2))),
              Operation(Operations.single, "r", null, null)),
          image: FormulaImage('images/fmv2r.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, "F", null, null),
          Operation(
              Operations.division,
              null,
              Operation(
                  Operations.multiplication,
                  null,
                  Operation(Operations.single, "G", null, null),
                  Operation(
                      Operations.multiplication,
                      null,
                      Operation(Operations.single, "m", null, null),
                      Operation(Operations.single, "M", null, null))),
              Operation(
                  Operations.exponentiation,
                  null,
                  Operation(Operations.single, "r", null, null),
                  Operation(Operations.single, "2", null, null, num: 2))),
          image: FormulaImage('images/fgmmr2.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'S', null, null),
          Operation(
              Operations.multiplication,
              null,
              Operation(Operations.single, 'π', null, null),
              Operation(
                  Operations.exponentiation,
                  null,
                  Operation(Operations.single, 'r', null, null),
                  Operation(Operations.single, '2', null, null, num: 2))),
          image: FormulaImage('images/Spir2.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'l', null, null),
          Operation(
              Operations.multiplication,
              null,
              Operation(Operations.single, '2', null, null, num: 2),
              Operation(
                  Operations.multiplication,
                  null,
                  Operation(Operations.single, 'π', null, null),
                  Operation(Operations.single, 'r', null, null))),
          image: FormulaImage(
            'images/l2pir.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'V', null, null),
          Operation(
              Operations.multiplication,
              null,
              Operation(
                  Operations.division,
                  null,
                  Operation(Operations.single, '4', null, null, num: 4),
                  Operation(Operations.single, '3', null, null, num: 3)),
              Operation(
                  Operations.multiplication,
                  null,
                  Operation(Operations.single, 'π', null, null),
                  Operation(
                      Operations.exponentiation,
                      null,
                      Operation(Operations.single, 'r', null, null),
                      Operation(Operations.single, '3', null, null, num: 3)))),
          image: FormulaImage('images/v43pir3.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'ρ', null, null),
          Operation(Operations.division, null, Operation(Operations.single, 'm', null, null),
              Operation(Operations.single, 'V', null, null)),
          image: FormulaImage('images/romv.png')),
      Operation(Operations.equal, null, Operation(Operations.single, 'm', null, null),
          Operation(Operations.single, 'M', null, null),
          image: FormulaImage('images/mm.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'ω', null, null),
          Operation(
              Operations.multiplication,
              null,
              Operation(Operations.single, 'π', null, null),
              Operation(
                  Operations.multiplication,
                  null,
                  Operation(Operations.single, '2', null, null, num: 2),
                  Operation(Operations.single, 'f', null, null))),
          image: FormulaImage('images/omegapi2f.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'a', null, null),
          Operation(
              Operations.division,
              null,
              Operation(
                  Operations.exponentiation,
                  null,
                  Operation(Operations.single, 'v', null, null),
                  Operation(Operations.single, '2', null, null, num: 2)),
              Operation(Operations.single, 'r', null, null)),
          image: FormulaImage('images/av2r.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'γ', null, null),
          Operation(Operations.division, null, Operation(Operations.single, 'F', null, null),
              Operation(Operations.single, 'm', null, null)),
          image: FormulaImage('images/gammafm.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'E', null, null),
          Operation(Operations.multiplication, null, Operation(Operations.single, 'h', null, null),
              Operation(Operations.single, 'f', null, null)),
          image: FormulaImage(
            'images/ehf.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'p', null, null),
          Operation(Operations.division, null, Operation(Operations.single, 'h', null, null),
              Operation(Operations.single, 'λ', null, null)),
          image: FormulaImage('images/phlambda.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'f', null, null),
          Operation(Operations.division, null, Operation(Operations.single, 'c', null, null),
              Operation(Operations.single, 'λ', null, null)),
          image: FormulaImage(
            'images/fclambda.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'T', null, null),
          Operation(
              Operations.division,
              null,
              Operation(Operations.single, '1', null, null, num: 1),
              Operation(Operations.single, 'f', null, null)),
          image: FormulaImage('images/T1f.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'v', null, null),
          Operation(Operations.multiplication, null, Operation(Operations.single, 'ω', null, null),
              Operation(Operations.single, 'r', null, null)),
          image: FormulaImage(
            'images/vomegar.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'F', null, null),
          Operation(Operations.multiplication, null, Operation(Operations.single, 'm', null, null),
              Operation(Operations.single, 'a', null, null)),
          image: FormulaImage(
            'images/Fma.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'p', null, null),
          Operation(Operations.multiplication, null, Operation(Operations.single, 'm', null, null),
              Operation(Operations.single, 'v', null, null)),
          image: FormulaImage(
            'images/pmv.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'W', null, null),
          Operation(Operations.multiplication, null, Operation(Operations.single, 'F', null, null),
              Operation(Operations.single, 's', null, null)),
          image: FormulaImage(
            'images/Wfs.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'P', null, null),
          Operation(
              Operations.division,
              null,
              Operation(Operations.single, 'W', null, null, num: 1),
              Operation(Operations.single, 't', null, null)),
          image: FormulaImage(
            'images/PWt.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'v', null, null),
          Operation(
              Operations.root,
              null,
              Operation(
                  Operations.division,
                  null,
                  Operation(
                      Operations.multiplication,
                      null,
                      Operation(Operations.single, 'G', null, null),
                      Operation(Operations.single, 'M', null, null)),
                  Operation(Operations.single, 'r', null, null)),
              Operation(Operations.single, '2', null, null, num: 2)),
          image: FormulaImage(
            'images/vGMr.png',
          )),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'p', null, null),
          Operation(
              Operations.division,
              null,
              Operation(Operations.single, 'F', null, null, num: 1),
              Operation(Operations.single, 'S', null, null)),
          image: FormulaImage('images/pFS.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'I', null, null),
          Operation(
              Operations.division,
              null,
              Operation(Operations.single, 'Q', null, null, num: 1),
              Operation(Operations.single, 't', null, null)),
          image: FormulaImage('images/IQt.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'P', null, null),
          Operation(Operations.multiplication, null, Operation(Operations.single, 'U', null, null),
              Operation(Operations.single, 'I', null, null)),
          image: FormulaImage('images/PUI.png')),
      Operation(
          Operations.equal,
          null,
          Operation(Operations.single, 'I', null, null),
          Operation(
              Operations.division,
              null,
              Operation(Operations.single, 'U', null, null, num: 1),
              Operation(Operations.single, 'R', null, null)),
          image: FormulaImage('images/IUR.png')),
    ];
  }

  @override
  _FormulaListState createState() => _FormulaListState();
/*
  Operation(Operations.division,null,Operation(Operations.single,'1',null,null,num:1),Operation(Operations.single,'T',null,null)) dzielenie
  Operation(Operations.multiplication, null, Operation(Operations.single, 'h', null, null), Operation(Operations.single, 'f', null, null)) mnożenie

   */
}

class _FormulaListState extends State<FormulaList> {
  String currentString = '';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.MainOrange,
        centerTitle: true,
        title: Text(jezyk ? 'Wzory' : 'Formulas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.SecondaryBlue, width: 2),
                  color: MyColors.NumPadWhite),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none, hintText: (jezyk ? 'Wyszukaj...' : 'Search...')),
                onChanged: (String newStr) {
                  setState(() {
                    currentString = newStr;
                  });
                },
              ),
              padding: EdgeInsets.all(10.0),
            ),
            Container(
                child: Column(
              children: FormulaList.getListOfFormulas().map((Operation op) {
                return isThisFormulaValid(op.getComponents())
                    ? Column(children: <Widget>[
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
                                ),
                                aspectRatio: 6.8 / 2.7),
                            width: MediaQuery.of(context).size.width),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(width: 1.0, color: MyColors.SecondaryBlue))),
                        )
                      ])
                    : Container(
                        height: 0,
                        width: 0,
                      );
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }

  bool isThisFormulaValid(List<String> formulaComponents) {
    int maxScore = currentString.length;
    int score = 0;
    for (int i = 0; i < maxScore; i++) {
      if (formulaComponents.contains(currentString[i]) ||
          formulaComponents.contains(currentString[i].toUpperCase())) {
        score++;
      }
    }
    if (score == maxScore) {
      return true;
    } else {
      return false;
    }
  }
}

class FormulaImage extends StatelessWidget {
  final String image;

  FormulaImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Image.asset(image);
  }
}
