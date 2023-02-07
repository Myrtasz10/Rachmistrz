import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import './colors.dart';
import './operation.dart';

class AdditionalFormulaList extends StatelessWidget {
  final AFLValueStorage possibleFormulas;

  AdditionalFormulaList(this.possibleFormulas);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wzory'),
        centerTitle: true,
        backgroundColor: MyColors.MainOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: possibleFormulas.opList.map((Operation op) {
            print('ACL op: ${op.printOperation()}');
            return Card(
              child: (op.operationImage == null
                  ? (Column(
                children: <Widget>[
                  TeXView(renderingEngine: RenderingEngine.Katex, teXHTML: op.createKatexString()),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/formulas', arguments: Operation(Operations.equal, null, possibleFormulas.baseOp.op.secondOperation, op.reformOperation(possibleFormulas.baseOp.str).secondOperation));
                    },
                    child: Text('Select'),
                  )
                ],
              ))
                  :  Column(children: <Widget>[
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
                              Navigator.of(context).pushNamed('/formulas', arguments: Operation(Operations.equal, null, possibleFormulas.baseOp.op.secondOperation, op.reformOperation(possibleFormulas.baseOp.str).secondOperation));
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
              ])),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AFLValueStorage {
  List<Operation> opList;
  TestClass baseOp;

  AFLValueStorage(this.opList, this.baseOp);
}
