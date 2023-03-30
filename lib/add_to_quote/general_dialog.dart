import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maketplace/add_to_quote/add_to_quote_viewmodel.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:maketplace/utils/style.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

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

Future<void> showSuccesCreateDialog(BuildContext context, QuoteModel model) async {
  await showDialog(
    context: context,
    builder: (BuildContext context1) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(25),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: _AddToQuoteSuccessWidget(context1: context, model: model),
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
                Selector<AddToQuoteViewModel, CreateQuoteWithProductState>(
                  builder: (context, state, child) {
                    switch (state) {
                      case CreateQuoteWithProductState.initial:
                        return child!;
                      case CreateQuoteWithProductState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case CreateQuoteWithProductState.loaded:
                        final model = context.read<AddToQuoteViewModel>().quoteModel;
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.of(context).pop();
                          showSuccesCreateDialog(widget.context1, model);
                        });
                        return child!;
                      case CreateQuoteWithProductState.loadFailure:
                        //TODO poner mensaje de error
                        return child!;
                      default:
                        return child!;
                    }
                  },
                  child: PrimaryButton(
                    text: "Continuar",
                    onPressed: () {
                      if (_textController.length > 6) {
                        context.read<AddToQuoteViewModel>().createQuote(_textController.text);
                      }
                    },
                    enabled: _textController.length > 6,
                  ),
                  selector: (_, vm) => vm.createQuoteWithProductState,
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
  const _AddToQuoteSuccessWidget({Key? key, required this.context1, required this.model}) : super(key: key);
  final BuildContext context1;
  final QuoteModel model;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: (media.width < CustomStyles.mobileBreak) ? 0 : 360, maxWidth: 360),
      child: SingleChildScrollView(
        child: Center(
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
                model.alias ?? '',
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
                  context.read<AddToQuoteViewModel>().navigateToQuoteDetail(model.id!);
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
        ),
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
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
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
                  Text(
                    "Agregar a\ncotización",
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
                    maxLines: 2,
                  ),
                  const SizedBox(height: 25),
                  Selector<AddToQuoteViewModel, GetQuoteState>(
                      builder: (ctx, state, w) {
                        switch (state) {
                          case GetQuoteState.initial:
                            return const SizedBox.shrink();
                          case GetQuoteState.loading:
                            return const SizedBox.shrink();
                          case GetQuoteState.loaded:
                            final list = context.read<AddToQuoteViewModel>().quoteList;
                            if (list.isEmpty) {
                              Future.delayed(const Duration(seconds: 0), () {
                                Navigator.of(context).pop();
                                showCreateQuoteDialog(context1);
                              });
                            }
                            return _ListOfQuotesWidget(
                              context1: context1,
                              quoteList: list,
                            );
                          case GetQuoteState.loadFailure:
                            return const Text("Error al cargar");
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                      selector: (ctx, vm) => vm.getQuoteState),
                  Selector<AddToQuoteViewModel, AddProductToQuoteState>(
                      builder: (ctx, state, child) {
                        switch (state) {
                          case AddProductToQuoteState.initial:
                          case AddProductToQuoteState.loading:
                            return child!;
                          case AddProductToQuoteState.loaded:
                            final model = context.read<AddToQuoteViewModel>().quoteModel;
                            Future.delayed(const Duration(seconds: 0), () {
                              Navigator.of(context).pop();
                              showSuccesCreateDialog(context1, model);
                            });
                            return child!;
                          case AddProductToQuoteState.loadFailure:
                            Future.delayed(const Duration(seconds: 0), () {
                              //
                            });
                            return child!;
                          default:
                            return child!;
                        }
                      },
                      child: const SizedBox.shrink(),
                      selector: (ctx, vm) => vm.addProductToQuoteState),
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
            ),
          ),
          Builder(
            builder: (ctx) {
              final loading = [GetQuoteState.loading].contains(context.watch<AddToQuoteViewModel>().getQuoteState);
              if (loading) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ColoredBox(
                    color: Colors.white.withOpacity(.8),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Builder(
            builder: (ctx) {
              final loading = [AddProductToQuoteState.loading].contains(context.watch<AddToQuoteViewModel>().addProductToQuoteState);
              if (loading) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ColoredBox(
                    color: Colors.white.withOpacity(.8),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _ListOfQuotesWidget extends StatelessWidget {
  const _ListOfQuotesWidget({Key? key, required this.context1, required this.quoteList}) : super(key: key);
  final BuildContext context1;
  final List<QuoteModel> quoteList;
  @override
  Widget build(BuildContext context) {
    if (quoteList.isEmpty) {
      return const SizedBox.shrink();
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 90,
        maxHeight: 280,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: quoteList
              .map(
                (model) => _QuoteItem(context1: context1, model: model),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _QuoteItem extends StatelessWidget {
  const _QuoteItem({
    super.key,
    required this.context1,
    required this.model,
  });
  final BuildContext context1;
  final QuoteModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      decoration: BoxDecoration(
        border: Border.all(color: AppKeys().customColors!.WBYPlusOne),
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<AddToQuoteViewModel>().addProductToQuote(model);
          },
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 25),
            decoration: BoxDecoration(
              border: Border.all(color: AppKeys().customColors!.WBYPlusOne),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.alias ?? '',
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
                  "Creada: ${DateFormat.yMMMd().format(DateTime.parse(model.createdAt!.toDate().toString()))} ${DateFormat.Hm().format(DateTime.parse(model.createdAt!.toDate().toString()))}",
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
