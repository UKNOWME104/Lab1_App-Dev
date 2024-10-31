import 'package:flutter/material.dart';

abstract class GeneralButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final ButtonStyle? style;
  final Alignment? alignment;

  const GeneralButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class NumberButton extends GeneralButton {
  const NumberButton({
    super.key,
    required String label,
    required void Function() onPressed,
    ButtonStyle? style,
    Alignment? alignment,
  }) : super(
      label: label,
      onPressed: onPressed,
      style: style,
      alignment: alignment);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = screenWidth * 0.75 / 4;
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF333333),
            shape: const CircleBorder(),
            // padding: const EdgeInsets.all(20),
            textStyle: const TextStyle(
              fontFamily: "SFNSDisplay",
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 39,
            ),
            fixedSize: Size(size, size),
          ),
      child: Center(
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: Text(
            style: const TextStyle(
              // height: 1.05,
            ),
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ExtraButton extends GeneralButton {
  const ExtraButton({
    super.key,
    required String label,
    required void Function() onPressed,
    ButtonStyle? style,
  }) : super(label: label, onPressed: onPressed, style: style);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = screenWidth * 0.75 / 4;

    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA5A5A5),
            shape: const CircleBorder(),
            fixedSize: Size(size, size),
          ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(
              fontFamily: "SFNSDisplay",
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 32),
        ),
      ),
    );
  }
}

class OpButton extends GeneralButton {
  const OpButton({
    super.key,
    required String label,
    required void Function() onPressed,
    ButtonStyle? style,
  }) : super(label: label, onPressed: onPressed, style: style);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double size = screenWidth * 0.75 / 4;
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9900),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            textStyle: const TextStyle(
              height: 0.89,
              fontFamily: "SFNSDisplay",
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 45,
            ),
            fixedSize: Size(size, size),
          ),
      child: Text(label),
    );
  }
}