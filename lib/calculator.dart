import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buttons.dart';
import 'calculator_provider.dart';

class Calculator extends StatelessWidget {
  Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 85), // Space above the display area
          displayArea(provider),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: buttonGrid(context, provider),
            ),
          ),
        ],
      ),
    );
  }

  // Display area for history and the current number
  Widget displayArea(CalculatorProvider provider) {
    return SizedBox(
      height: 300, // Adjust the height to fit history and current display
      child: Column(
        children: [
          // History area with scrollable text
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: provider.history
                    .map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    entry,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
          const Divider(color: Colors.white), // Divider between history and current display
          // Current display area
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              provider.display,
              style: const TextStyle(
                  color: Colors.white, fontSize: 90, fontWeight: FontWeight.w300),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Button grid layout
  Column buttonGrid(BuildContext context, CalculatorProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end, // Keep buttons aligned at the bottom
      children: [
        // Space above the first row of buttons
        const SizedBox(height: 0), // Space above the buttons

        // First row of buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ExtraButton(label: "AC", onPressed: provider.clear),
            ExtraButton(label: "+/-", onPressed: () => provider.handleSpecialPressed("±")),
            ExtraButton(label: "%", onPressed: () => provider.handleSpecialPressed("%")),
            OpButton(label: "÷", onPressed: () => provider.handleOperationPressed("/")),
          ],
        ),
        const SizedBox(height: 15), // Increased vertical spacing

        // Second row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(label: "7", onPressed: () => provider.handleNumberPressed(7)),
            NumberButton(label: "8", onPressed: () => provider.handleNumberPressed(8)),
            NumberButton(label: "9", onPressed: () => provider.handleNumberPressed(9)),
            OpButton(label: "×", onPressed: () => provider.handleOperationPressed("x")),
          ],
        ),
        const SizedBox(height: 15), // Increased vertical spacing

        // Third row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(label: "4", onPressed: () => provider.handleNumberPressed(4)),
            NumberButton(label: "5", onPressed: () => provider.handleNumberPressed(5)),
            NumberButton(label: "6", onPressed: () => provider.handleNumberPressed(6)),
            OpButton(label: "-", onPressed: () => provider.handleOperationPressed("-")),
          ],
        ),
        const SizedBox(height: 15), // Increased vertical spacing

        // Fourth row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(label: "1", onPressed: () => provider.handleNumberPressed(1)),
            NumberButton(label: "2", onPressed: () => provider.handleNumberPressed(2)),
            NumberButton(label: "3", onPressed: () => provider.handleNumberPressed(3)),
            OpButton(label: "+", onPressed: () => provider.handleOperationPressed("+")),
          ],
        ),
        const SizedBox(height: 15), // Increased vertical spacing

        // Fifth row with zero, decimal, and equal buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberButton(
              label: "0",
              onPressed: () => provider.handleNumberPressed(0),
              alignment: Alignment.centerLeft,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70),
                ),
                padding: const EdgeInsets.only(left: 28),
                fixedSize: Size(
                  MediaQuery.of(context).size.width * 2.4 * 0.7 / 4 * 1.1, // Set button size to 1.1
                  MediaQuery.of(context).size.width * 0.75 / 4 * 1.1, // Set button size to 1.1
                ),
                textStyle: const TextStyle(
                  fontFamily: "SFNSDisplay",
                  fontSize: 42, // Match the font size of NumberButton
                ),
              ),
            ),
            NumberButton(label: ".", onPressed: () => provider.handleSpecialPressed(".")),
            OpButton(label: "=", onPressed: () => provider.handleOperationPressed("=")),
          ],
        ),
        const SizedBox(height: 50), // Increased space at the bottom for a more balanced layout
      ],
    );
  }
}
