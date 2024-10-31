
import 'package:assignment1/buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class Calculator extends StatefulWidget {
  Calculator({super.key});

  String display = "0";
  double balance = 0.0;
  String oldOperation = "";
  String? newOperation = "+";

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                backspace();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: displayArea(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: buttonGrid(context),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox displayArea() {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(right: 36, left: 28),
        child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            widget.display,
            // style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: "SFNSDisplay",
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 90,
            ),
            maxLines: 1,
            stepGranularity: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Column buttonGrid(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExtraButton(
                label: "AC",
                onPressed: () {
                  clear();
                }),
            ExtraButton(
                label: "+/-",
                onPressed: () {
                  handleSpecialPressed("±");
                }),
            ExtraButton(
                label: "%",
                onPressed: () {
                  handleSpecialPressed("%");
                }),
            OpButton(
                label: "÷",
                onPressed: () {
                  handleOperationPressed("/");
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(
                label: "7",
                onPressed: () {
                  handleNumberPressed(7);
                }),
            NumberButton(
                label: "8",
                onPressed: () {
                  handleNumberPressed(8);
                }),
            NumberButton(
                label: "9",
                onPressed: () {
                  handleNumberPressed(9);
                }),
            OpButton(
                label: "×",
                onPressed: () {
                  handleOperationPressed("x");
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(
                label: "4",
                onPressed: () {
                  handleNumberPressed(4);
                }),
            NumberButton(
                label: "5",
                onPressed: () {
                  handleNumberPressed(5);
                }),
            NumberButton(
                label: "6",
                onPressed: () {
                  handleNumberPressed(6);
                }),
            OpButton(
                label: "-",
                onPressed: () {
                  handleOperationPressed("-");
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(
                label: "1",
                onPressed: () {
                  handleNumberPressed(1);
                }),
            NumberButton(
                label: "2",
                onPressed: () {
                  handleNumberPressed(2);
                }),
            NumberButton(
                label: "3",
                onPressed: () {
                  handleNumberPressed(3);
                }),
            OpButton(
                label: "+",
                onPressed: () {
                  handleOperationPressed("+");
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(
              alignment: Alignment.centerLeft,
              label: "0",
              onPressed: () {
                handleNumberPressed(0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70),
                ),
                padding: const EdgeInsets.only(left: 28),
                fixedSize: Size(
                    MediaQuery.sizeOf(context).width * 2.4 * 0.7 / 4,
                    MediaQuery.sizeOf(context).width * 0.75 / 4),
                textStyle: const TextStyle(
                  fontFamily: "SFNSDisplay",
                  fontSize: 39,
                ),
              ),
            ),
            NumberButton(
                label: ".", onPressed: () => handleSpecialPressed(".")),
            OpButton(
              label: "=",
              onPressed: () {
                handleOperationPressed("=");
              },
            )
          ],
        ),
      ],
    );
  }

  void clear() {
    setState(() {
      widget.display = "0";
      widget.balance = 0.0;
      widget.oldOperation = "";
      widget.newOperation = "+";
    });
    printStates();
  }

  void printStates() {
    print("balance: ${widget.balance}");
    print("display: ${widget.display}");
    print("oldOperation: ${widget.oldOperation}");
    print("newOperation: ${widget.newOperation}");
  }

  String doubleToString(double value) {
    if (value.isInfinite || value.isNaN) return "NaN";

    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }

  void handleNumberPressed(int number) {
    if (widget.newOperation != null) {
      typeNextOperand(number);
    } else {
      print("append");
      appendNumber(number);
    }
    printStates();
  }

  void handleNan() {
    setState(() {
      widget.display = "NaN";
      widget.balance = 0.0;
      widget.oldOperation = "";
      widget.newOperation = "+";
    });
    printStates();
  }

  void handleOperationPressed(String operation) {
    if (operation == "=") {
      if (widget.oldOperation.startsWith("=")) {
        String oper = widget.oldOperation.substring(1, 2);
        double value = double.parse(widget.oldOperation.substring(2));
        widget.balance = calculate(widget.balance, oper, value);
        widget.newOperation = "=";

        setState(() {
          widget.display = doubleToString(widget.balance);
        });
        printStates();
        return;
      } else {
        double displayValue = double.parse(widget.display);
        widget.balance =
            calculate(widget.balance, widget.oldOperation, displayValue);
        widget.oldOperation = "=${widget.oldOperation}$displayValue";
        widget.newOperation = "=";

        setState(() {
          widget.display = doubleToString(widget.balance);
        });
        printStates();
        return;
      }
    }

    if (widget.newOperation == null) {
      widget.balance = calculate(
          widget.balance, widget.oldOperation, double.parse(widget.display));
      setState(() {
        widget.display = doubleToString(widget.balance);
      });
    }

    widget.newOperation = operation;
    printStates();
  }

  switchSign(String display) {
    if (display == "0") {
      return display;
    } else if (display[0] == "-") {
      return display.substring(1);
    } else {
      return "-$display";
    }
  }

  void handleSpecialPressed(String special) {
    switch (special) {
      case "AC":
        clear();
        break;
      case "±":
        setState(() {
          widget.display = switchSign(widget.display);
        });
        break;
      case "%":
        setState(() {
          widget.display = doubleToString(double.parse(widget.display) / 100);
        });
        widget.newOperation = "";
        break;
      case ".":
        if (widget.newOperation != null) {
          setState(() {
            widget.display = "0.";
            widget.newOperation = null;
          });
        } else if (!widget.display.contains(".")) {
          setState(() {
            widget.display += ".";
          });
        }
        break;
      default:
        break;
    }
  }

  void appendNumber(int number) {
    setState(() {
      if (widget.display == "0") {
        widget.display = number.toString();
      } else {
        widget.display += number.toString();
      }
    });
  }

  void typeNextOperand(int number) {
    setState(() {
      widget.oldOperation = widget.newOperation!;
      widget.newOperation = null;
      widget.display = number.toString();
    });
  }

  double calculate(double op1, String op, double op2) {
    if (op1.isInfinite || op1.isNaN) return op2;

    switch (op) {
      case "+":
        return op1 + op2;
      case "-":
        return op1 - op2;
      case "x":
        return op1 * op2;
      case "/":
        return op1 / op2;
      case "":
        return op2;
      case "=":
        return op2;
      default:
      // if ()
        return 0.0;
    }
  }

  void backspace() {
    if (widget.newOperation != null) {
      return;
    }

    if (widget.display.length == 1) {
      setState(() {
        widget.display = "0";
      });
      return;
    } else if (widget.display.length == 2 && widget.display[0] == "-") {
      setState(() {
        widget.display = "0";
      });
      return;
    }
    setState(() {
      widget.display = widget.display.substring(0, widget.display.length - 1);
    });
  }
}