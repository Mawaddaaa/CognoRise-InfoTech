import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor, Color textColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      decoration: BoxDecoration(
        color: buttonColor,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: textColor, // Text color
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 70,
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize, color: Colors.white), // White text
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize, color: Colors.white), // White text
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("⌫", 1,Colors.grey[850]!, Colors.greenAccent),
                      buildButton("C", 1, Colors.grey[850]!, Colors.greenAccent),
                      buildButton("÷", 1, Colors.grey[850]!, Colors.greenAccent),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Colors.grey[850]!, Colors.white),
                      buildButton("8", 1, Colors.grey[850]!, Colors.white),
                      buildButton("9", 1, Colors.grey[850]!, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Colors.grey[850]!, Colors.white),
                      buildButton("5", 1, Colors.grey[850]!, Colors.white),
                      buildButton("6", 1, Colors.grey[850]!, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Colors.grey[850]!, Colors.white),
                      buildButton("2", 1, Colors.grey[850]!, Colors.white),
                      buildButton("3", 1, Colors.grey[850]!, Colors.white),
                    ]),
                    TableRow(children: [
                      buildButton("00", 1, Colors.grey[850]!, Colors.white),
                      buildButton("0", 1, Colors.grey[850]!, Colors.white),
                      buildButton(".", 1, Colors.grey[850]!, Colors.white),
                    ]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("×", 1, Colors.grey[850]!, Colors.greenAccent),
                    ]),
                    TableRow(children: [
                      buildButton("-", 1, Colors.grey[850]!, Colors.greenAccent),
                    ]),
                    TableRow(children: [
                      buildButton("+", 1, Colors.grey[850]!, Colors.greenAccent),
                    ]),
                    TableRow(children: [
                      buildButton("=", 2, Colors.grey[850]!, Colors.greenAccent),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
