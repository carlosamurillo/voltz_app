import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/utils/custom_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GeneralButton(
      text: text,
      onPressed: onPressed,
      textColor: CustomColors.white,
      buttonColor: CustomColors.blueVoltz,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GeneralButton(
      text: text,
      onPressed: onPressed,
      textColor: CustomColors.dark,
      buttonColor: Colors.transparent,
      borderColor: CustomColors.dark,
    );
  }
}

class ThirdButton extends StatelessWidget {
  const ThirdButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GeneralButton(text: text, onPressed: onPressed, textColor: CustomColors.white, buttonColor: CustomColors.dark);
  }
}

class GeneralButton extends StatelessWidget {
  const GeneralButton({Key? key, required this.text, required this.onPressed, required this.textColor, required this.buttonColor, this.borderColor}) : super(key: key);

  final String text;
  final Function() onPressed;
  final Color textColor;
  final Color buttonColor;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(200.0)),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(200)),
            hoverColor: buttonColor.withOpacity(.8),
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
  }
}
