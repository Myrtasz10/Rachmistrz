import 'package:flutter/material.dart';
import './colors.dart';

class EquationSolver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.MainOrange,
          title: Text("Rozwiązywanie równań"),
          centerTitle: true,
        ),
        body: Center(
            child: Text("Nothing to see here...",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)))
    );
  }
}
