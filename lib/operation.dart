import 'dart:math';

import 'package:flutter/cupertino.dart';

class Operation {
  Operation firstOperation;
  Operation secondOperation;
  String type;
  String value;
  double numericValue;
  Widget operationImage;

  Operation(this.type, this.value, this.firstOperation, this.secondOperation, {double num, Widget image}) {
    numericValue = num;
    operationImage = image;
    if (type == Operations.single) {
      firstOperation = null;
      secondOperation = null;
    } else {
      value = null;
    }
  }

  Operation newOperation(String str) {
    return reformOperation(str).simplify();
  }

  Operation reformOperation(String str) {
    String whatIsItEqualTo = str;
    int triesCounter = 0;
    Operation newFormula = this;

    while (!(newFormula.firstOperation.value == whatIsItEqualTo || triesCounter > 20)) {
      triesCounter++;

      if (newFormula.secondOperation.type == Operations.single) {
        newFormula = Operation(Operations.equal, null, newFormula.secondOperation, newFormula.firstOperation);
      }

      if (newFormula.firstOperation == null) {
        continue;
      }

      if (newFormula.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
        if (newFormula.firstOperation.type == Operations.addition) {
          if (newFormula.firstOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.firstOperation, Operation(Operations.subtraction, null, newFormula.secondOperation, newFormula.firstOperation.secondOperation));
            continue;
          } else {
            if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
              newFormula = Operation(Operations.equal, null, newFormula.firstOperation.secondOperation, Operation(Operations.subtraction, null, newFormula.secondOperation, newFormula.firstOperation.firstOperation));
              continue;
            }
          }
        } else if (newFormula.firstOperation.type == Operations.subtraction) {
          if (newFormula.firstOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.firstOperation, Operation(Operations.addition, null, newFormula.secondOperation, newFormula.firstOperation.secondOperation));
            continue;
          } else if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.secondOperation, Operation(Operations.subtraction, null, newFormula.firstOperation.firstOperation, newFormula.secondOperation));
            continue;
          }
        } else if (newFormula.firstOperation.type == Operations.multiplication) {
          if (newFormula.firstOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.firstOperation, Operation(Operations.division, null, newFormula.secondOperation, newFormula.firstOperation.secondOperation));
            continue;
          } else if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.secondOperation, Operation(Operations.division, null, newFormula.secondOperation, newFormula.firstOperation.firstOperation));
            continue;
          }
        } else if (newFormula.firstOperation.type == Operations.division) {
          if (newFormula.firstOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.firstOperation, Operation(Operations.multiplication, null, newFormula.secondOperation, newFormula.firstOperation.secondOperation));
            continue;
          } else if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.secondOperation, Operation(Operations.division, null, newFormula.firstOperation.firstOperation, newFormula.secondOperation));
            continue;
          }
        } else if (newFormula.firstOperation.type == Operations.exponentiation) {
          if (newFormula.firstOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.firstOperation, Operation(Operations.root, null, newFormula.secondOperation, newFormula.firstOperation.secondOperation));
            continue;
          } else if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            print('ToDo:logarytmy');
            return (newFormula);
          }
        } else if (newFormula.firstOperation.type == Operations.root) {
          if (newFormula.firstOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, newFormula.firstOperation.firstOperation, Operation(Operations.exponentiation, null, newFormula.secondOperation, newFormula.firstOperation.secondOperation));
            continue;
          }
          if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            print('ToDo: logarytmy');
            return (newFormula);
          }
        }
      }

      if (newFormula.secondOperation == null) {
        continue;
      }

      if (newFormula.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
        if (newFormula.secondOperation.type == Operations.addition) {
          if (newFormula.secondOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.subtraction, null, newFormula.firstOperation, newFormula.secondOperation.secondOperation), newFormula.secondOperation.firstOperation);
            continue;
          }
          if (newFormula.secondOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.subtraction, null, newFormula.firstOperation, newFormula.secondOperation.firstOperation), newFormula.secondOperation.secondOperation);
            continue;
          }
        } else if (newFormula.secondOperation.type == Operations.subtraction) {
          if (newFormula.secondOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.addition, null, newFormula.firstOperation, newFormula.secondOperation.secondOperation), newFormula.secondOperation.firstOperation);
            continue;
          }
          if (newFormula.secondOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.subtraction, null, newFormula.secondOperation.firstOperation, newFormula.firstOperation), newFormula.secondOperation.secondOperation);
            continue;
          }
        } else if (newFormula.secondOperation.type == Operations.multiplication) {
          if (newFormula.secondOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.division, null, newFormula.firstOperation, newFormula.secondOperation.secondOperation), newFormula.secondOperation.firstOperation);
            continue;
          } else if (newFormula.secondOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.division, null, newFormula.firstOperation, newFormula.secondOperation.firstOperation), newFormula.secondOperation.secondOperation);
            continue;
          }
        } else if (newFormula.secondOperation.type == Operations.division) {
          if (newFormula.secondOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.multiplication, null, newFormula.firstOperation, newFormula.secondOperation.secondOperation), newFormula.secondOperation.firstOperation);
            continue;
          } else if (newFormula.secondOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.division, null, newFormula.secondOperation.firstOperation, newFormula.firstOperation), newFormula.secondOperation.secondOperation);
            continue;
          }
        } else if (newFormula.secondOperation.type == Operations.exponentiation) {
          if (newFormula.secondOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.root, null, newFormula.firstOperation, newFormula.secondOperation.secondOperation), newFormula.secondOperation.firstOperation);
            continue;
          } else if (newFormula.firstOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            print('ToDo:logarytmy');
            return (newFormula);
          }
        } else if (newFormula.secondOperation.type == Operations.root) {
          if (newFormula.secondOperation.firstOperation.isSomeStingHere(whatIsItEqualTo)) {
            newFormula = Operation(Operations.equal, null, Operation(Operations.exponentiation, null, newFormula.firstOperation, newFormula.secondOperation.secondOperation), newFormula.secondOperation.firstOperation);
            continue;
          }
          if (newFormula.secondOperation.secondOperation.isSomeStingHere(whatIsItEqualTo)) {
            print('ToDo: logarytmy');
            return (newFormula);
          }
        }
      }
    }

    return (newFormula);
  }

  String printOperation() {
    if (type == Operations.single) {
      if (value == null) {
        return "error";
      } else {
        return (value);
      }
    } else if (type == Operations.multiplication || type == Operations.division) {
      if (firstOperation.type == Operations.addition || firstOperation.type == Operations.subtraction) {
        return ('(' + firstOperation.printOperation() + ')' + type + (secondOperation.type == Operations.addition || secondOperation.type == Operations.subtraction ? '(' + secondOperation.printOperation() + ')' : secondOperation.printOperation()));
      } else {
        return (firstOperation.printOperation() + type + (secondOperation.type == Operations.addition || secondOperation.type == Operations.subtraction ? '(' + secondOperation.printOperation() + ')' : secondOperation.printOperation()));
      }
    } else if (type == Operations.subtraction) {
      if (secondOperation.type == Operations.addition) {
        return (firstOperation.printOperation() + type + '(' + secondOperation.printOperation() + ')');
      }
    } else if (type == Operations.exponentiation || type == Operations.root) {
      if (firstOperation.type == Operations.single) {
        return (firstOperation.printOperation() + type + (type == Operations.exponentiation ? '(' : '') + secondOperation.printOperation() + ')');
      } else {
        return ('[' + firstOperation.printOperation() + ']' + type + (type == Operations.exponentiation ? '(' : '') + secondOperation.printOperation() + ')');
      }
    } else {
      return (firstOperation.printOperation() + type + secondOperation.printOperation());
    }

    return ('error');
  }

  String createKatexString() {
    Operation op = this;
    String strToReturn = '';
    if (op.type == Operations.equal) {
      strToReturn = r'$$';
      if (!(op.firstOperation.type == Operations.single)) {
        op = op.reformOperation(op.getComponents().elementAt(0));
      }
      strToReturn += op.firstOperation.value + '=';
      strToReturn += op.secondOperation.createKatexString();
      strToReturn += r'$$';
    } else if (op.type == Operations.single) {
      return op.value;
    } else if (op.type == Operations.addition) {
      return op.firstOperation.createKatexString() + '+' + op.secondOperation.createKatexString();
    } else if (op.type == Operations.subtraction) {
      return op.firstOperation.createKatexString() + '-' + op.secondOperation.createKatexString();
    } else if (op.type == Operations.division) {
      return r'\' + 'frac{' + op.firstOperation.createKatexString() + '}{' + op.secondOperation.createKatexString() + '}';
    } else if (op.type == Operations.multiplication) {
      String s;
      if (op.firstOperation.type == Operations.addition || op.firstOperation.type == Operations.subtraction) {
        s = '(' + op.firstOperation.createKatexString() + ')';
      } else {
        s = op.firstOperation.createKatexString();
      }
      if (op.secondOperation.type == Operations.addition || op.secondOperation.type == Operations.subtraction) {
        s += '(' + op.secondOperation.createKatexString() + ')';
      } else {
        s += op.secondOperation.createKatexString();
      }
      return s;
    } else if (op.type == Operations.exponentiation) {
      String s;
      if (firstOperation.type == Operations.single) {
        s = firstOperation.value.replaceAll(RegExp(r'.0'), "") + '^';
      } else {
        s = '(' + firstOperation.createKatexString() + ')^';
      }
      if (secondOperation.type == Operations.single) {
        s += '{' + secondOperation.value.replaceAll(RegExp(r'.0'), "") + '}';
      } else {
        s += '{' + secondOperation.createKatexString() + '}';
      }

      return s;
    } else if (op.type == Operations.root) {
      String s = r'\sqrt';
      if (!(op.secondOperation.numericValue == 2)) {
        s += '[' + op.secondOperation.createKatexString() + ']';
      }
      s += '{' + op.firstOperation.createKatexString() + '}';

      return s;
    }

    return strToReturn;
  }

  bool isSomeStingHere(String searched) {
    if (type == Operations.single) {
      if (value == searched) {
        return (true);
      } else {
        return (false);
      }
    } else if (firstOperation.isSomeStingHere(searched) == true || secondOperation.isSomeStingHere(searched) == true) {
      return (true);
    } else {
      return (false);
    }
  }

  List<String> getComponents() {
    List<String> elements = new List<String>();
    if (type == Operations.single) {
      if (value == null) {
        print("getComponents Error");
        return elements;
      } else {
        if (elements == null) {
          elements.add(value);
        } else if (!(elements.contains(value))) {
          elements.add(value);
        }
      }
    } else {
      for (int i = 0; i < firstOperation.getComponents().length; i++) {
        if (elements == null) {
          elements.add(firstOperation.getComponents().elementAt(i));
        } else if (!(elements.contains(firstOperation.getComponents().elementAt(i)))) {
          elements.add(firstOperation.getComponents().elementAt(i));
        }
      }
      for (int i = 0; i < secondOperation.getComponents().length; i++) {
        if (elements == null) {
          elements.add(secondOperation.getComponents().elementAt(i));
        } else if (!(elements.contains(secondOperation.getComponents().elementAt(i)))) {
          elements.add(secondOperation.getComponents().elementAt(i));
        }
      }
    }
    for (int i = 0; i < elements.length; i++) {
      if (isNumeric(elements.elementAt(i))) {
        elements.removeAt(i);
      }
    }
    elements.sort();
    return (elements);
  }

  void setNumericValueOf(String str, double val) {
    if (type == Operations.single && value == str) {
      numericValue = val;
    } else {
      if (firstOperation.isSomeStingHere(str)) {
        firstOperation.setNumericValueOf(str, val);
      }
      if (secondOperation.isSomeStingHere(str)) {
        secondOperation.setNumericValueOf(str, val);
      }
    }
  }

  double calculate() {
    if (type == Operations.single && !(numericValue == null)) {
      return numericValue;
    } else if (type == Operations.addition) {
      return firstOperation.calculate() + secondOperation.calculate();
    } else if (type == Operations.subtraction) {
      return firstOperation.calculate() - secondOperation.calculate();
    } else if (type == Operations.multiplication) {
      return firstOperation.calculate() * secondOperation.calculate();
    } else if (type == Operations.division) {
      return firstOperation.calculate() / secondOperation.calculate();
    } else if (type == Operations.exponentiation) {
      return pow(firstOperation.calculate(), secondOperation.calculate());
    } else if (type == Operations.root) {
      return pow(firstOperation.calculate(), 1 / secondOperation.calculate());
    }

    return 0;
  }

  Operation changeValueToOperation(String val, Operation op) {
    newOperation(val);
    if (firstOperation.type == Operations.single) {
      return (Operation(Operations.equal, null, op, secondOperation));
    } else {
      print('error');
      return this;
    }
  }

  Operation removeStringFromOperation(String str) {
    Operation opToReturn = this;

    print("STARTED REMOVEING $str from ${opToReturn.printOperation()}");

    if (opToReturn.type == Operations.single) {
      if (opToReturn.value == str) {
        opToReturn = Operation(Operations.single, '1', null, null, num: 1);
      } else {
        return (opToReturn);
      }
    } else if (opToReturn.type == Operations.addition || opToReturn.type == Operations.subtraction) {
      if (opToReturn.firstOperation.type == Operations.single && opToReturn.firstOperation.value == str) {
        opToReturn.firstOperation = Operation(Operations.single, '0', null, null, num: 0);
      } else if (!(opToReturn.firstOperation.type == Operations.single)) {
        if ((opToReturn.firstOperation.type == Operations.exponentiation || opToReturn.firstOperation.type == Operations.root) && opToReturn.firstOperation.firstOperation.value == str) {
          opToReturn.firstOperation = Operation(Operations.single, '0', null, null, num: 0);
        } else {
          opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);
          opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
        }
      } else if (opToReturn.secondOperation.type == Operations.single && opToReturn.secondOperation.value == str) {
        opToReturn.secondOperation = Operation(Operations.single, '0', null, null, num: 0);
      } else if (!(opToReturn.secondOperation.type == Operations.single)) {
        if ((opToReturn.secondOperation.type == Operations.exponentiation || opToReturn.secondOperation.type == Operations.root) && opToReturn.secondOperation.firstOperation.value == str) {
          opToReturn.secondOperation = Operation(Operations.single, '0', null, null, num: 0);
        } else {
          opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);
          opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
        }
      } else {
        opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);
        opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
      }
    } else if (opToReturn.type == Operations.multiplication || opToReturn.type == Operations.division) {
      if (opToReturn.firstOperation.type == Operations.single && opToReturn.firstOperation.value == str) {
        opToReturn.firstOperation = Operation(Operations.single, '1', null, null, num: 1);
      } else if (!(opToReturn.firstOperation.type == Operations.single)) {
        if ((opToReturn.firstOperation.type == Operations.exponentiation || opToReturn.firstOperation.type == Operations.root) && opToReturn.firstOperation.firstOperation.value == str) {
          opToReturn.firstOperation = Operation(Operations.single, '1', null, null, num: 1);
        } else {
          opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);
          opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
        }
      } else if (opToReturn.secondOperation.type == Operations.single && opToReturn.secondOperation.value == str) {
        opToReturn.secondOperation = Operation(Operations.single, '1', null, null, num: 1);
      } else if (!(opToReturn.secondOperation.type == Operations.single)) {
        if ((opToReturn.secondOperation.type == Operations.exponentiation || opToReturn.secondOperation.type == Operations.root) && opToReturn.secondOperation.firstOperation.value == str) {
          opToReturn.secondOperation = Operation(Operations.single, '1', null, null, num: 1);
        } else {
          opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);
          opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
        }
      } else {
        opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);
        opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
      }
    } else if (opToReturn.type == Operations.equal) {
      opToReturn.firstOperation = opToReturn.firstOperation.removeStringFromOperation(str);

      opToReturn.secondOperation = opToReturn.secondOperation.removeStringFromOperation(str);
    } else {
      print("nie powinno mnie tu być ${opToReturn.type}");
    }

    if (opToReturn.isSomeStingHere(str)) {
      print("Removed with success ${opToReturn.printOperation()}");
    } else {
      print("Removed without succes ${opToReturn.printOperation()}");
    }

    return (opToReturn);
  }

  Operation mergeDivisions() {
    Operation opToReturn = new Operation(Operations.division, null, Operation(Operations.single, '1', null, null, num: 1), Operation(Operations.single, '1', null, null, num: 1));
    Operation givenOperation = this;
    int i = 0;
    print('NEW mergeDivisions got: ${givenOperation.printOperation()}');

    if (givenOperation.firstOperation.typesOfOperations().contains(Operations.division)) {
      while (givenOperation.firstOperation.type == Operations.multiplication) {
        if (givenOperation.firstOperation.secondOperation.typesOfOperations().contains(Operations.division)) {
          if (opToReturn.firstOperation.printOperation() == '1') {
            opToReturn.firstOperation = givenOperation.firstOperation.firstOperation;
          } else {
            opToReturn.firstOperation = new Operation(Operations.multiplication, null, opToReturn.firstOperation, givenOperation.firstOperation.firstOperation);
          }
          givenOperation = new Operation(Operations.division, null, givenOperation.firstOperation.secondOperation, givenOperation.secondOperation);
        } else if (givenOperation.firstOperation.firstOperation.typesOfOperations().contains(Operations.division)) {
          if (opToReturn.firstOperation.printOperation() == '1') {
            opToReturn.firstOperation = givenOperation.firstOperation.secondOperation;
          } else {
            opToReturn.firstOperation = new Operation(Operations.multiplication, null, opToReturn.firstOperation, givenOperation.firstOperation.secondOperation);
          }
          givenOperation = new Operation(Operations.division, null, givenOperation.firstOperation.firstOperation, givenOperation.secondOperation);
        }
      }

      if (givenOperation.firstOperation.type == Operations.division) {
        opToReturn.firstOperation = Operation(Operations.multiplication, null, opToReturn.firstOperation, givenOperation.firstOperation.firstOperation);
        opToReturn.secondOperation = Operation(Operations.multiplication, null, opToReturn.secondOperation, givenOperation.firstOperation.secondOperation);
        opToReturn.secondOperation = Operation(Operations.multiplication, null, opToReturn.secondOperation, givenOperation.secondOperation);
      } else {
        opToReturn.firstOperation = Operation(Operations.multiplication, null, givenOperation.firstOperation, opToReturn.firstOperation);
        opToReturn.secondOperation = Operation(Operations.multiplication, null, givenOperation.secondOperation, opToReturn.secondOperation);
      }
    } else if (givenOperation.secondOperation.typesOfOperations().contains(Operations.division)) {
      print('@@ before while opTORET: ${opToReturn.printOperation()} givenOp: ${givenOperation.printOperation()}');
      while (givenOperation.secondOperation.type == Operations.multiplication) {
        print('@@ $i time in while opTORET: ${opToReturn.printOperation()} givenOp: ${givenOperation.printOperation()}');
        if (givenOperation.secondOperation.secondOperation.typesOfOperations().contains(Operations.division)) {
          if (opToReturn.secondOperation.printOperation() == '1') {
            opToReturn.secondOperation = givenOperation.secondOperation.firstOperation;
          } else {
            opToReturn.secondOperation = new Operation(Operations.multiplication, null, opToReturn.secondOperation, givenOperation.secondOperation.firstOperation);
          }
          givenOperation = new Operation(Operations.division, null, givenOperation.firstOperation, givenOperation.secondOperation.secondOperation);
        } else if (givenOperation.secondOperation.firstOperation.typesOfOperations().contains(Operations.division)) {
          if (opToReturn.secondOperation.printOperation() == '1') {
            opToReturn.secondOperation = givenOperation.secondOperation.secondOperation;
          } else {
            opToReturn.secondOperation = new Operation(Operations.multiplication, null, opToReturn.secondOperation, givenOperation.secondOperation.secondOperation);
          }
          givenOperation = new Operation(Operations.division, null, givenOperation.firstOperation, givenOperation.secondOperation.firstOperation);
          print('@@ $i time end while opTORET: ${opToReturn.printOperation()} givenOp: ${givenOperation.printOperation()}');
          print('@@ $i time 2nd op: ${givenOperation.secondOperation.printOperation()}');
        }
      }
      print('@@ after while opTORET: ${opToReturn.printOperation()} givenOp: ${givenOperation.printOperation()}');
      if (givenOperation.secondOperation.type == Operations.division) {
        opToReturn.firstOperation = Operation(Operations.multiplication, null, opToReturn.firstOperation, givenOperation.firstOperation);
        opToReturn.firstOperation = Operation(Operations.multiplication, null, opToReturn.firstOperation, givenOperation.secondOperation.secondOperation);
        opToReturn.secondOperation = Operation(Operations.multiplication, null, opToReturn.secondOperation, givenOperation.secondOperation.firstOperation);
      } else {
        opToReturn.firstOperation = Operation(Operations.multiplication, null, givenOperation.firstOperation, opToReturn.firstOperation);
        opToReturn.secondOperation = Operation(Operations.multiplication, null, givenOperation.secondOperation, opToReturn.secondOperation);
      }
    }

    print('NEW mergeDIv returned: ${opToReturn.printOperation()}');
    return (opToReturn);
  }

  Operation simplifyDoubleDivision() {
    Operation opToReturn = this;

    print('simplifyDoubleDiv got this: ${opToReturn.printOperation()}');
    if (opToReturn.type == Operations.single) {
      return opToReturn;
    } else if (opToReturn.type == Operations.division && (opToReturn.firstOperation.typesOfOperations().contains(Operations.division) || opToReturn.secondOperation.typesOfOperations().contains(Operations.division))) {
      opToReturn = opToReturn.mergeDivisions().mergeOperationsBasic();
    } else {
      opToReturn.secondOperation = opToReturn.secondOperation.simplifyDoubleDivision();
      opToReturn.firstOperation = opToReturn.firstOperation.simplifyDoubleDivision();
    }
    print('simplifyDoubleDiv returned this: ${opToReturn.printOperation()}');
    return opToReturn;
  }

  List<String> typesOfOperations() {
    List<String> types = new List<String>();
    if (type == Operations.single) {
      types.add(type);
    } else {
      types.add(type);
      types += secondOperation.typesOfOperations();
      types += firstOperation.typesOfOperations();
    }

    return types;
  }
  Operation simplify() {
    Operation simplyfiedOperation = this;
    Operation testOperation = this;

    List<String> elemnetsOfOperation = testOperation.getComponents();
    List<String> stringsToRemove = new List<String>();
    print('simplifiedOP got this: ${simplyfiedOperation.printOperation()}');
    print(simplyfiedOperation.printOperation() + simplyfiedOperation.secondOperation.calculate().toString());
    for (int i = 0; i < elemnetsOfOperation.length; i++) {
      testOperation = testOperation.reformOperation(elemnetsOfOperation.elementAt(i));
      for (int indexOfNumberThatIsChecked = 0; indexOfNumberThatIsChecked < elemnetsOfOperation.length; indexOfNumberThatIsChecked++) {
        if (indexOfNumberThatIsChecked == i) {
          continue;
        } else {
          for (int x = 0; x < elemnetsOfOperation.length; x++) {
            if (x == indexOfNumberThatIsChecked) {
              continue;
            } else {
              testOperation.setNumericValueOf(elemnetsOfOperation.elementAt(x), Random().nextInt(1000).toDouble());
            }
          }
          List<double> results = new List<double>(3);

          if (testOperation.firstOperation.isSomeStingHere(elemnetsOfOperation.elementAt(indexOfNumberThatIsChecked))) {
            if (!testOperation.secondOperation.isSomeStingHere(elemnetsOfOperation.elementAt(indexOfNumberThatIsChecked))) {
              testOperation = new Operation(Operations.equal, null, testOperation.secondOperation, testOperation.firstOperation);
            }
          }

          for (int x = 0; x < 3; x++) {
            testOperation.setNumericValueOf(elemnetsOfOperation.elementAt(indexOfNumberThatIsChecked), Random().nextInt(1000).toDouble());
            results[x] = testOperation.secondOperation.calculate();
          }
          if (results[0] == results[1] && results[1] == results[2]) {
            stringsToRemove.add(elemnetsOfOperation.elementAt(indexOfNumberThatIsChecked));
          }
        }
      }
    }
    for (int i = 0; i < stringsToRemove.length; i++) {
      simplyfiedOperation.removeStringFromOperation(stringsToRemove.elementAt(i));
    }
    print(simplyfiedOperation.printOperation() + simplyfiedOperation.secondOperation.calculate().toString());
    for (int i = 0; i < simplyfiedOperation.getComponents().length; i++) {
      double num = double.tryParse(simplyfiedOperation.getComponents().elementAt(i));

      if (num == null) {
        simplyfiedOperation.setNumericValueOf(simplyfiedOperation.getComponents().elementAt(i), null);
      }
    }

    print(simplyfiedOperation.printOperation() + simplyfiedOperation.secondOperation.calculate().toString());

    print('simplyfied OP1: ${simplyfiedOperation.printOperation()}');
    simplyfiedOperation = simplyfiedOperation.simplifyDoubleDivision();
    print('simplyfied OP2: ${simplyfiedOperation.printOperation()}');

    simplyfiedOperation = simplyfiedOperation.mergeOperationsBasic();
    print('simplyfied OP3: ${simplyfiedOperation.printOperation()}');

    print('simplyfied OP4: ${simplyfiedOperation.printOperation()}');
    return (simplyfiedOperation);
  }

  double getExponentOfString(String str) {
    String searched = str;
    Operation operation = this;
    double exponent = 0;

    if (operation.type == Operations.single && operation.value == searched) {
      exponent += 1;
    } else if (operation.type == Operations.single) {
      return exponent;
    } else if (operation.firstOperation.type == Operations.addition || operation.firstOperation.type == Operations.subtraction) {
      if (operation.secondOperation.type == Operations.addition || operation.secondOperation.type == Operations.subtraction) {
        return exponent;
      } else {
        if (operation.secondOperation.type == Operations.multiplication) {
          return exponent + operation.secondOperation.firstOperation.getExponentOfString(searched) + operation.secondOperation.secondOperation.getExponentOfString(searched);
        } else if (operation.secondOperation.type == Operations.division) {
          return exponent - operation.secondOperation.secondOperation.getExponentOfString(searched) + operation.secondOperation.firstOperation.getExponentOfString(searched);
        } else if (operation.secondOperation.type == Operations.exponentiation || operation.secondOperation.type == Operations.root) {
          if (operation.secondOperation.firstOperation.getComponents().contains(searched)) {
            if (!(operation.secondOperation.firstOperation.typesOfOperations().contains(Operations.addition) || operation.secondOperation.firstOperation.typesOfOperations().contains(Operations.subtraction))) {
              exponent += operation.secondOperation.secondOperation.numericValue;

              return exponent;
            }
          }
        }
      }
    } else if (operation.secondOperation.type == Operations.addition || operation.secondOperation.type == Operations.subtraction) {
      if (operation.firstOperation.type == Operations.addition || operation.firstOperation.type == Operations.subtraction) {
        return exponent;
      } else {
        if (operation.secondOperation.type == Operations.multiplication) {
          return exponent + operation.secondOperation.firstOperation.getExponentOfString(searched) + operation.secondOperation.secondOperation.getExponentOfString(searched);
        } else if (secondOperation.type == Operations.division) {
          return exponent - operation.secondOperation.secondOperation.getExponentOfString(searched) + operation.secondOperation.firstOperation.getExponentOfString(searched);
        } else if (secondOperation.type == Operations.exponentiation || secondOperation.type == Operations.root) {
          if (secondOperation.firstOperation.getComponents().contains(searched)) {
            if (!(secondOperation.firstOperation.typesOfOperations().contains(Operations.addition) || secondOperation.firstOperation.typesOfOperations().contains(Operations.subtraction))) {
              exponent += secondOperation.secondOperation.numericValue;

              return exponent;
            }
          }
        }
      }
    } else if (operation.type == Operations.multiplication) {
      return exponent + operation.firstOperation.getExponentOfString(searched) + operation.secondOperation.getExponentOfString(searched);
    } else if (operation.type == Operations.division) {
      return exponent + operation.firstOperation.getExponentOfString(searched) - operation.secondOperation.getExponentOfString(searched);
    } else if (operation.type == Operations.exponentiation || operation.type == Operations.root) {
      if (operation.firstOperation.getComponents().contains(searched)) {
        if (!(operation.firstOperation.typesOfOperations().contains(Operations.addition) || operation.firstOperation.typesOfOperations().contains(Operations.subtraction))) {
          exponent += operation.secondOperation.numericValue;

          return exponent;
        }
      }
    }

    double willThisWork = exponent;
    exponent = 0;

    return willThisWork;
  }

  Operation mergeSpecificString(String string) {
    Operation opToReturn = this;
    String stringToMerge = string;
    double exponentOfString = opToReturn.getExponentOfString(stringToMerge);
    print('MergeSpecyficString:${opToReturn.printOperation()} string: $stringToMerge exponent:$exponentOfString');

    opToReturn = opToReturn.removeStringFromOperation(stringToMerge);

    if (exponentOfString < 0) {
      if (opToReturn.type == Operations.division) {
        if (exponentOfString == 1) {
          opToReturn.secondOperation = Operation(Operations.multiplication, null, opToReturn.secondOperation, Operation(Operations.single, stringToMerge, null, null));
        } else {
          opToReturn.secondOperation =
              Operation(Operations.multiplication, null, opToReturn.secondOperation, Operation(Operations.exponentiation, null, Operation(Operations.single, stringToMerge, null, null), Operation(Operations.single, (-exponentOfString).toString(), null, null, num: -exponentOfString)));
        }
      } else {
        if (exponentOfString == 1) {
          opToReturn.secondOperation = Operation(Operations.division, null, opToReturn.secondOperation, Operation(Operations.single, stringToMerge, null, null));
        } else {
          opToReturn.secondOperation =
              Operation(Operations.division, null, opToReturn.secondOperation, Operation(Operations.exponentiation, null, Operation(Operations.single, stringToMerge, null, null), Operation(Operations.single, (-exponentOfString).toString(), null, null, num: -exponentOfString)));
        }
      }
    } else if (exponentOfString > 0) {
      /*
      if (exponentOfString == 1) {
        opToReturn.firstOperation = Operation(Operations.multiplication, null, opToReturn.firstOperation, Operation(Operations.single, stringToMerge, null, null));
      } else {
        opToReturn.firstOperation =
            Operation(Operations.multiplication, null, opToReturn.firstOperation, Operation(Operations.exponentiation, null, Operation(Operations.single, stringToMerge, null, null), Operation(Operations.single, exponentOfString.toString(), null, null, num: exponentOfString)));
      }
      */
      if (exponentOfString == 1) {
        opToReturn = Operation(Operations.multiplication, null, opToReturn, Operation(Operations.single, stringToMerge, null, null));
      } else {
        opToReturn = Operation(Operations.multiplication, null, opToReturn, Operation(Operations.exponentiation, null, Operation(Operations.single, stringToMerge, null, null), Operation(Operations.single, exponentOfString.toString(), null, null, num: exponentOfString)));
      }
    }
    print('MegreSpecificString returned: ${opToReturn.printOperation()}');
    return opToReturn;
  }

  Operation mergeOperationsAdvanced() {
    Operation opToReturn = this;

    print('mergeOpAd: ${opToReturn.printOperation()}');

    if (opToReturn.type == Operations.single) {
      return opToReturn;
    } else if (opToReturn.type == Operations.multiplication || opToReturn.type == Operations.division) {
      if (opToReturn.typesOfOperations().contains(Operations.addition) || opToReturn.typesOfOperations().contains(Operations.subtraction)) {
        opToReturn.firstOperation = opToReturn.firstOperation.mergeOperationsAdvanced();
        opToReturn.secondOperation = opToReturn.secondOperation.mergeOperationsAdvanced();
      } else {
        List<String> valuesToMerge = new List<String>();
        for (int x = 0; x < opToReturn.firstOperation.getComponents().length; x++) {
          for (int y = 0; y < opToReturn.secondOperation.getComponents().length; y++) {
            if (opToReturn.firstOperation.getComponents().elementAt(x) == opToReturn.secondOperation.getComponents().elementAt(y)) {
              if (!valuesToMerge.contains(firstOperation.getComponents().elementAt(x))) {
                valuesToMerge.add(firstOperation.getComponents().elementAt(x));
              }
            }
          }
        }
        for (int i = 0; i < valuesToMerge.length; i++) {
          print('### opTOMERGE: ${opToReturn.printOperation()}');
          opToReturn = opToReturn.mergeSpecificString(valuesToMerge.elementAt(i));
          print('### returned: ${opToReturn.printOperation()}');
        }
      }
    } else {
      opToReturn.firstOperation = opToReturn.firstOperation.mergeOperationsAdvanced();
      opToReturn.secondOperation = opToReturn.secondOperation.mergeOperationsAdvanced();
    }
    print('MergeOPAd returned: ${opToReturn.printOperation()}');
    return opToReturn;
  }

  Operation mergeOperationsBasic() {
    Operation finalOperation = this;

    print('mergeOpBa: ${finalOperation.printOperation()} ');

    if (finalOperation.type == Operations.equal) {
      finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
      finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
    } else if (finalOperation.type == Operations.single) {
      return (finalOperation);
    } else if (finalOperation.type == Operations.multiplication) {
      if (finalOperation.firstOperation.printOperation() == finalOperation.secondOperation.printOperation()) {
        finalOperation = new Operation(Operations.exponentiation, null, firstOperation, Operation(Operations.single, "2", null, null, num: 2));
      } else if (finalOperation.firstOperation.value == "1" || finalOperation.secondOperation.value == "1") {
        finalOperation = finalOperation.firstOperation.value == "1" ? secondOperation : firstOperation;
      } else if (finalOperation.firstOperation.value == "0" || finalOperation.secondOperation.value == "0") {
        finalOperation = new Operation(Operations.single, "0", null, null, num: 0);
      } else if (finalOperation.firstOperation.type == Operations.exponentiation || finalOperation.secondOperation.type == Operations.exponentiation) {
        if (finalOperation.firstOperation.type == Operations.exponentiation) {
          if (finalOperation.firstOperation.firstOperation.printOperation() == finalOperation.secondOperation.printOperation()) {
            finalOperation = new Operation(Operations.exponentiation, null, finalOperation.secondOperation, Operation(Operations.single, (finalOperation.firstOperation.secondOperation.numericValue + 1).toString(), null, null, num: finalOperation.firstOperation.secondOperation.numericValue + 1));
          } else {
            finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
            finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
          }
        } else if (finalOperation.secondOperation.type == Operations.exponentiation) {
          if (finalOperation.secondOperation.firstOperation.printOperation() == finalOperation.firstOperation.printOperation()) {
            finalOperation = new Operation(Operations.exponentiation, null, finalOperation.firstOperation, Operation(Operations.single, (finalOperation.secondOperation.secondOperation.numericValue + 1).toString(), null, null, num: finalOperation.secondOperation.secondOperation.numericValue + 1));
          } else {
            finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
            finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
          }
        } else if (finalOperation.firstOperation.type == Operations.exponentiation && finalOperation.secondOperation.type == Operations.exponentiation) {
          if (finalOperation.firstOperation.firstOperation.printOperation() == finalOperation.secondOperation.firstOperation.printOperation()) {
            finalOperation = new Operation(
                Operations.exponentiation,
                null,
                finalOperation.firstOperation.firstOperation,
                Operation(Operations.single, (finalOperation.firstOperation.secondOperation.numericValue + finalOperation.secondOperation.secondOperation.numericValue).toString(), null, null,
                    num: finalOperation.firstOperation.secondOperation.numericValue + finalOperation.secondOperation.secondOperation.numericValue));
          } else {
            finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
            finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
          }
        } else {
          finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
          finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        }
      } else {
        finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
      }
    } else if (finalOperation.type == Operations.division) {
      if (finalOperation.firstOperation.printOperation() == finalOperation.secondOperation.printOperation()) {
        finalOperation = new Operation(Operations.single, "1", null, null, num: 1);
      } else if (finalOperation.secondOperation.value == "1") {
        finalOperation = finalOperation.firstOperation;
      } else if (finalOperation.firstOperation.type == Operations.exponentiation) {
        if (finalOperation.firstOperation.firstOperation.printOperation() == finalOperation.secondOperation.printOperation()) {
          finalOperation = new Operation(Operations.exponentiation, null, finalOperation.secondOperation, Operation(Operations.single, (finalOperation.firstOperation.secondOperation.numericValue - 1).toString(), null, null, num: finalOperation.firstOperation.secondOperation.numericValue - 1));
        } else {
          finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
          finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        }
      } else if (finalOperation.secondOperation.type == Operations.exponentiation) {
        if (finalOperation.secondOperation.firstOperation.printOperation() == finalOperation.firstOperation.printOperation()) {
          finalOperation = new Operation(Operations.exponentiation, null, finalOperation.firstOperation, Operation(Operations.single, (finalOperation.secondOperation.secondOperation.numericValue - 1).toString(), null, null, num: finalOperation.secondOperation.secondOperation.numericValue - 1));
        } else {
          finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
          finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        }
      } else if (finalOperation.secondOperation.type == Operations.exponentiation && finalOperation.secondOperation.type == Operations.exponentiation) {
        if (finalOperation.secondOperation.firstOperation.printOperation() == finalOperation.firstOperation.firstOperation.printOperation()) {
          finalOperation = new Operation(
              Operations.exponentiation,
              null,
              finalOperation.firstOperation.firstOperation,
              Operation(Operations.single, (finalOperation.firstOperation.secondOperation.numericValue - finalOperation.secondOperation.secondOperation.numericValue).toString(), null, null,
                  num: finalOperation.firstOperation.secondOperation.numericValue - finalOperation.secondOperation.secondOperation.numericValue));
        } else {
          finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
          finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        }
      } else {
        finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
      }
    } else if (finalOperation.type == Operations.subtraction) {
      if (finalOperation.firstOperation.printOperation() == finalOperation.secondOperation.printOperation()) {
        finalOperation = new Operation(Operations.single, "0", null, null, num: 0);
      } else {
        finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
      }
    } else if (finalOperation.type == Operations.addition) {
      if (finalOperation.firstOperation.value == "0" || finalOperation.secondOperation.value == "0") {
        finalOperation = finalOperation.firstOperation.value == "0" ? finalOperation.secondOperation : finalOperation.firstOperation;
      } else {
        finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
        finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
      }
    } else {
      finalOperation.firstOperation = finalOperation.firstOperation.mergeOperationsBasic();
      finalOperation.secondOperation = finalOperation.secondOperation.mergeOperationsBasic();
    }

    print('megreOPBA gave:  ${finalOperation.printOperation()} to AD');

    return (finalOperation.mergeOperationsAdvanced());
  }
}

class Operations {
  static String single = ' ';
  static String equal = '=';
  static String division = '/';
  static String multiplication = '*';
  static String addition = '+';
  static String subtraction = '-';
  static String exponentiation = '^';
  static String root = '^(1/';
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

class TestClass {
  Operation op;
  String str;

  TestClass(this.op, this.str);
}
