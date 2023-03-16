import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/pet_voltz_path.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, required this.onPressed, this.enabled = true, this.icon}) : super(key: key);

  final String text;
  final Function() onPressed;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      text: text,
      onPressed: onPressed,
      textColor: AppKeys().customColors!.white,
      buttonColor: AppKeys().customColors!.blueVoltz,
      icon: icon,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({Key? key, required this.text, required this.onPressed, this.icon}) : super(key: key);

  final String text;
  final Function() onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      text: text,
      onPressed: onPressed,
      textColor: AppKeys().customColors!.dark,
      buttonColor: Colors.white,
      borderColor: AppKeys().customColors!.dark,
      icon: icon,
    );
  }
}

class ThirdButton extends StatelessWidget {
  const ThirdButton({Key? key, required this.text, required this.onPressed, this.icon}) : super(key: key);

  final String text;
  final Function() onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return BaseButton(text: text, onPressed: onPressed, textColor: AppKeys().customColors!.white, buttonColor: AppKeys().customColors!.dark, icon: icon);
  }
}

class GeneralButton extends StatelessWidget {
  const GeneralButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.textColor,
    required this.buttonColor,
    this.borderColor,
    this.enabled = true,
    this.icon,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final Color textColor;
  final Color buttonColor;
  final Color? borderColor;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: enabled ? buttonColor : buttonColor.withOpacity(.8),
          borderRadius: const BorderRadius.all(Radius.circular(200.0)),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(200)),
            hoverColor: buttonColor.withOpacity(.3),
            onTap: enabled ? onPressed : null,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 24,
                        color: textColor,
                      )
                    ],
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      text,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
          ),
        ));
  }
}

class BaseButton extends StatelessWidget {
  const BaseButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.textColor,
    required this.buttonColor,
    this.borderColor,
    this.enabled = true,
    this.icon,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final Color textColor;
  final Color buttonColor;
  final Color? borderColor;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    VoltzPetPath path = VoltzPetPath();
    //path.paint(canvas, Size(10, 10));

    //final splashFactory = PathSplash.splashFactory();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.1,
        surfaceTintColor: AppKeys().customColors!.yellowVoltz,
        disabledBackgroundColor: buttonColor.withOpacity(0.6),
        backgroundColor: buttonColor,
        side: borderColor == null
            ? null
            : BorderSide(
                width: 1.0,
                color: borderColor!,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200),
        ),
        alignment: Alignment.center,
        //splashFactory: splashFactory,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: textColor),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key, required this.onPressed, required this.buttonColor, required this.backGroundColor, this.enabled = true, required this.icon, required this.borderColor})
      : super(key: key);

  final Function() onPressed;
  final Color buttonColor;
  final Color backGroundColor;
  final bool enabled;
  final IconData icon;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(border: Border.all(color: borderColor), color: enabled ? buttonColor : buttonColor.withOpacity(.8), shape: BoxShape.circle),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            hoverColor: buttonColor.withOpacity(.8),
            onTap: enabled ? onPressed : null,
            child: Ink(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              height: 40,
              width: 40,
              child: Icon(
                icon,
                color: backGroundColor,
              ),
            ),
          ),
        ));
  }
}
