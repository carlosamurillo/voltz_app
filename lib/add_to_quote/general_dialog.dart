import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:maketplace/utils/style.dart';
import 'package:pinput/pinput.dart';

Future<void> showAddQuoteDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context1) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(25),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: _GeneralDialogContent(context1: context),
      );
    },
  );
}

Future<void> showCreateQuoteDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context1) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(25),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: _CreateQuoteWidget(context1: context),
      );
    },
  );
}

Future<void> showSuccesCreateDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context1) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(25),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: _AddToQuoteSuccessWidget(context1: context),
      );
    },
  );
}

class _CreateQuoteWidget extends StatefulWidget {
  const _CreateQuoteWidget({Key? key, required this.context1}) : super(key: key);
  final BuildContext context1;
  @override
  State<_CreateQuoteWidget> createState() => _CreateQuoteWidgetState();
}

class _CreateQuoteWidgetState extends State<_CreateQuoteWidget> {
  final _formKey = GlobalKey<FormState>();
  bool autovalidate = false;
  bool enableButton = false;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: (media.width < CustomStyles.mobileBreak) ? 0 : 360, maxWidth: 360),
      child: Form(
        key: _formKey,
        autovalidateMode: autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.black,
                    onPressed: () => Navigator.of(context).pop(),
                    iconSize: 24,
                  ),
                ),
                const SizedBox(height: 40),
                SelectableText(
                  "Crea una cotización",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: AppKeys().customColors!.dark,
                      height: 1.1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SelectableText(
                  "Nombre del\nproyecto",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: AppKeys().customColors!.dark,
                      height: 1.1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InputText(
                  hintText: "Nombre para identificarla",
                  margin: const EdgeInsets.symmetric(vertical: 7.5),
                  controller: _textController,
                  onChanged: (v) {
                    autovalidate = true;
                    setState(() {});
                  },
                ),
                if (autovalidate && _textController.text.length < 6)
                  const Text(
                    "Nombre incorrecto, se requieren 6 caracteres.",
                    style: TextStyle(fontSize: 12, color: Colors.red),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 50),
                PrimaryButton(
                  text: "Continuar",
                  onPressed: () {
                    if (_textController.length > 6) {
                      Navigator.of(context).pop();
                      showSuccesCreateDialog(widget.context1);
                    }
                  },
                  enabled: _textController.length > 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddToQuoteSuccessWidget extends StatelessWidget {
  const _AddToQuoteSuccessWidget({Key? key, required this.context1}) : super(key: key);
  final BuildContext context1;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: (media.width < CustomStyles.mobileBreak) ? 0 : 360, maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 24,
            ),
          ),
          const SizedBox(height: 40),
          Icon(
            Icons.check_circle,
            color: AppKeys().customColors!.blueVoltz,
            size: 72,
          ),
          const SizedBox(height: 15),
          SelectableText(
            "Agregado a\ncotización",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32.0,
              color: AppKeys().customColors!.dark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            "ALIAS_24CARACTERES_MAXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                color: AppKeys().customColors!.dark,
                height: 1.1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 50),
          ThirdButton(
            text: "Ir a la cotización",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: "Seguir agregando",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _GeneralDialogContent extends StatelessWidget {
  const _GeneralDialogContent({Key? key, required this.context1}) : super(key: key);
  final BuildContext context1;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: (media.width < CustomStyles.mobileBreak) ? 0 : 360, maxWidth: 360),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 24,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "Agregar a cotización",
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
                color: AppKeys().customColors!.dark,
                height: 1.1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 25),
          _ListOfQuotesWidget(context1: context1),
          const SizedBox(height: 25),
          PrimaryButton(
            text: "Nueva cotizacion",
            icon: Icons.add_box_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              showCreateQuoteDialog(context1);
            },
          ),
        ],
      ),
    );
  }
}

class _ListOfQuotesWidget extends StatelessWidget {
  const _ListOfQuotesWidget({Key? key, required this.context1}) : super(key: key);
  final BuildContext context1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _QuoteItem(context1: context1),
        const SizedBox(height: 15),
        _QuoteItem(context1: context1),
        const SizedBox(height: 15),
        _QuoteItem(context1: context1),
      ],
    );
  }
}

class _QuoteItem extends StatelessWidget {
  const _QuoteItem({
    super.key,
    required this.context1,
  });
  final BuildContext context1;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppKeys().customColors!.WBYPlusOne),
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            showSuccesCreateDialog(context1);
          },
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 25),
            decoration: BoxDecoration(
              border: Border.all(color: AppKeys().customColors!.WBYPlusOne),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "ALIAS_24CARACTERES_MAXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: AppKeys().customColors!.dark,
                      height: 1.1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "Dirección de entrega",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                      color: AppKeys().customColors!.dark,
                      height: 1.1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
