import 'package:calculator/components/app_style.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String inputUser = "";
  String result = "0";

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sBackground,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(sPadding),
                  alignment: Alignment.centerRight,
                  child: Text(
                    inputUser,
                    style: const TextStyle(
                      fontSize: 30,
                      color: sWhite,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(sPadding),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: const TextStyle(
                        fontSize: 44,
                        color: sWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: sWhite),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(sPadding),
              child: GridView.builder(
                itemCount: buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(buttonList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CustomButton(String text) {
    return InkWell(
      splashColor: sBackground,
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(sBorderRadius),
          boxShadow: [
            BoxShadow(
                color: sWhite.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 0.5,
                offset: const Offset(-3, -3)),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == "/" ||
        text == "*" ||
        text == "+" ||
        text == "-" ||
        text == "C" ||
        text == "(" ||
        text == ")") {
      return sPrimary;
    }
    return sWhite;
  }

  getBgColor(String text) {
    if (text == "AC") {
      return sPrimary;
    }
    if (text == "=") {
      return sSecondary;
    }
    return sBackground;
  }

  handleButtons(String text) {
    if (text == "AC") {
      inputUser = "";
      result = "0";
      return;
    }
    if (text == "C") {
      if (inputUser.isNotEmpty) {
        inputUser = inputUser.substring(0, inputUser.length - 1);
        return;
      } else {
        return null;
      }
    }
    if (text == "=") {
      result = calculate();
      inputUser = result;

      if (inputUser.endsWith(".0")) {
        inputUser = inputUser.replaceAll(".0", "");
      }

      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
        return;
      }
    }

    inputUser = inputUser + text;
  }

  String calculate() {
    try {
      var expressions = Parser().parse(inputUser);
      var evaluation =
          expressions.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "Hata";
    }
  }
}
