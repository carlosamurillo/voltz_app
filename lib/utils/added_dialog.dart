import 'package:flutter/material.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/custom_colors.dart';

void showAddedDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierColor: CustomColors.blueVoltz.withOpacity(.7),
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(25),
      content: GeneralDialog(
        text: "¡Agregado a la cotización!",
        button1: ThirdButton(text: "Ir a la cotización", onPressed: () {}),
        button2: SecondaryButton(text: "Seguir agregando", onPressed: () => Navigator.of(context).pop()),
      ),
    ),
  );
}

void showExistDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierColor: CustomColors.blueVoltz.withOpacity(.7),
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(25),
      content: GeneralDialog(
        text: "Ya está en la cotización",
        button1: SecondaryButton(text: "Entendido", onPressed: () => Navigator.of(context).pop()),
      ),
    ),
  );
}

class GeneralDialog extends StatelessWidget {
  const GeneralDialog({Key? key, required this.text, required this.button1, this.button2}) : super(key: key);
  final String text;
  final Widget button1;
  final Widget? button2;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 360,
        minWidth: 200,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 15),
          const Icon(
            Icons.check_circle,
            color: CustomColors.blueVoltz,
            size: 72,
          ),
          const SizedBox(height: 15),
          SelectableText(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32.0,
              color: CustomColors.dark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          button1,
          if (button2 != null) const SizedBox(height: 10),
          if (button2 != null) button2!
        ],
      ),
    );
  }
}
