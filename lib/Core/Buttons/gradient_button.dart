import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const GradientButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff4338CA);
    const secondaryColor = Color(0xff6D28D9);
    const accentColor = Color(0xffffffff);

    const double borderRadius = 15;

    return DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient:
            const LinearGradient(colors: [primaryColor, secondaryColor])),
        child: ElevatedButton(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              alignment: Alignment.center,
              padding: WidgetStateProperty.all(const EdgeInsets.only(
                  right: 75, left: 75, top: 15, bottom: 15)),
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
              )),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(color: accentColor, fontSize: 16),
          ),
        ));
  }
}