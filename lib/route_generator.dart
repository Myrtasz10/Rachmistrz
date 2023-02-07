import 'package:flutter/material.dart';



//importujesz tu wszystkie pliki ktore maja w sobie widget ktory jest nowym ekranem
import './calculator.dart';
import './constant_info.dart';
import './constants.dart';
import './formulas.dart';
import './main.dart';
import './unit_exchange.dart';
import './exchangescreen.dart';
import './property.dart';
import './operation.dart';
import './formula_list.dart';
import './additional_choise_formula.dart';
import './constant.dart';
import './settings.dart';
import './graphingcalculator.dart';
import './graph_view.dart';
import './equation_solver.dart';


//jak chcesz zmienic ekran uzywajac kody piszesz 'Navigator.of(context).pushNamed('/nazwa_sciezki',arguments : to co chcesz przekazac);'



class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {                // tutaj dodajesz jaki ekran ma sie odpalic po jakiej sciezce
      case '/':
        return MaterialPageRoute(builder: (_) => BaseScreen());
      case '/constants':
        return MaterialPageRoute(builder: (_) => Constants());
      case '/formulas':
        if (args is Operation)
          {
            return MaterialPageRoute(builder: (_) => FormulaScreen(args));
          }
          return _errorRoute();
      case '/formula_list':
        return MaterialPageRoute(builder: (_) => FormulaList());
      case '/additional_choise':
        if(args is TestClass)
          {
            List<Operation> possibleFormulas = new List<Operation>();
            for(int i = 0 ;i<FormulaList.getListOfFormulas().length;i++)
            {
              if(FormulaList.getListOfFormulas().elementAt(i).isSomeStingHere(args.op.firstOperation.value))
                {
                  print(args.str);
                  print(FormulaList.getListOfFormulas().elementAt(i).reformOperation(args.str).printOperation());
                 // possibleFormulas.add(FormulaList.getListOfFormulas().elementAt(i).reformOperation(args.str));
                  possibleFormulas.add(FormulaList.getListOfFormulas().elementAt(i));
                }
            }

            return MaterialPageRoute(builder: (_) =>AdditionalFormulaList(AFLValueStorage(possibleFormulas,args)));
          }
        return _errorRoute();
      case '/calculator':
        return MaterialPageRoute(builder: (_) => Calculator());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/unit_exchange':
        return MaterialPageRoute(builder: (_) => UnitExchange());
      case '/constant_info':
        if (args is Constant) {
          return MaterialPageRoute(builder: (_) => ConstantInfo(args)); //tak wysylasz argumenty
        }
        return _errorRoute();
      case'/exchangescreen':
        if(args is Property){
          return MaterialPageRoute(builder: (_) => ExchangeScreen(args));
        }
        return _errorRoute();
      case'/graph':
        return MaterialPageRoute(builder: (_) => GraphingCalculator());
      case'/graph_view':
        if(args is List<FunctionOutput>)
          {

            return MaterialPageRoute(builder: (_) => GraphView(args));

          }
        return _errorRoute();
      case '/equation_solver':
        return MaterialPageRoute(builder: (_) => EquationSolver());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
