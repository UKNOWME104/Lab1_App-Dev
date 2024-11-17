import 'package:flutter/material.dart';

class CalculatorProvider extends ChangeNotifier {
  String _display = "0";
  double _balance = 0.0;
  String _oldOperation = "";
  String? _newOperation = "+";
  List<String> _history = [];

  String get display => _display;
  List<String> get history => _history;

  void clear() {
    _display = "0";
    _balance = 0.0;
    _oldOperation = "";
    _newOperation = "+";
    _history.clear();
    notifyListeners();
  }

  void handleNumberPressed(int number) {
    if (_newOperation != null) {
      typeNextOperand(number);
    } else {
      appendNumber(number);
    }
    notifyListeners();
  }

  void handleOperationPressed(String operation) {
    if (operation == "=") {
      double displayValue = double.parse(_display);
      _balance = calculate(_balance, _oldOperation, displayValue);
      _oldOperation = operation;
      _display = doubleToString(_balance);

      _history.add('$displayValue $_oldOperation $_balance = $_display');
    } else {
      if (_newOperation == null) {
        _balance = calculate(_balance, _oldOperation, double.parse(_display));
        _display = doubleToString(_balance);
      }
      _newOperation = operation;
    }
    notifyListeners();
  }

  void handleSpecialPressed(String special) {
    if (special == "AC") {
      clear();
    } else if (special == "±") {
      _display = _display.startsWith("-") ? _display.substring(1) : "-$_display";
    } else if (special == "%") {
      _display = doubleToString(double.parse(_display) / 100);
    } else if (special == "." && !_display.contains(".")) {
      _display += ".";
    }
    notifyListeners();
  }

  void appendNumber(int number) {
    _display = _display == "0" ? number.toString() : _display + number.toString();
    notifyListeners();
  }

  void typeNextOperand(int number) {
    _oldOperation = _newOperation!;
    _newOperation = null;
    _display = number.toString();
    notifyListeners();
  }

  double calculate(double op1, String op, double op2) {
    switch (op) {
      case "+": return op1 + op2;
      case "-": return op1 - op2;
      case "x": return op1 * op2;
      case "/": return op1 / op2;
      default: return op2;
    }
  }

  String doubleToString(double value) {
    return value == value.toInt() ? value.toInt().toString() : value.toString();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
