
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';


class QuoteTableDetailMobile extends StatefulWidget {
  QuoteTableDetailMobile({Key? key, required this.i, required this.listener}) : super(key: key);
  int i;
  final VoidCallback listener;

  @override
  _QuoteTableDetailMobileState createState() => _QuoteTableDetailMobileState();
}

class _QuoteTableDetailMobileState extends State<QuoteTableDetailMobile> {
  late QuoteViewModel model;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  TextEditingController textEditingController = TextEditingController();
  bool opened = false;

  @override
  void initState() {
    super.initState();
    model = context.read<QuoteViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
      label: "Cotización #${model.quote.consecutive}",
      primaryColor: Theme.of(context).primaryColor.value, // This line is required
    ));
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return CustomColors.energyYellow;
      }
      return CustomColors.safeBlue;
    };
    Color headerColor = CustomColors.volcanicBlue;
    for(int b = 0; b <= model.quote.detail![widget.i].productsSuggested!.length -1; b++) {
      if (model.quote.detail![widget.i].productsSuggested![b].selected == true) {
        headerColor =  CustomColors.safeBlue;
        break;
      } else {
        headerColor = CustomColors.volcanicBlue;
      }
    }

    var productsFiltered = model.quote.detail![widget.i].productsSuggested!.where((product) => product.selected! == true).toList();

    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8 ),
        child:  Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(12), topRight: Radius.circular(12)),
                  color: headerColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:1,
                      child: Text('${(widget.i + 1).toString()}. ${model.quote.detail![widget.i].productRequested!}',
                        style: CustomStyles.styleMobileWhite500, overflow: TextOverflow.clip,
                      )
                    ),
                  ],
                ),
              ),
              for(int b = 0; b <= model.quote.detail![widget.i].productsSuggested!.length -1; b++) ...{

                if(opened || (opened == false && model.quote.detail![widget.i].productsSuggested![b].selected!)) ...{
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      //borderRadius: b == model.quote.detail![widget.i].productsSuggested!.length -1 ? (model.quote.detail![widget.i].productsSuggested!.length == 1 ? BorderRadius.only(bottomLeft:Radius.circular(12), bottomRight:Radius.circular(12)) : BorderRadius.only(bottomLeft:Radius.circular(12),)) : (opened == true ? BorderRadius.only(bottomLeft:Radius.circular(12),) : null),

                      color: model.quote.detail![widget.i].productsSuggested![b].selected == false ? Colors.white : CustomColors.blueBackground,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 36,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                child: context.read<QuoteViewModel>().version != 'original' ? Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(getColor),
                                  value: model.quote.detail![widget.i].productsSuggested![b].selected,
                                  onChanged: (bool? value) async {
                                    setState(() {
                                      model.onSelectedSku(value!, widget.i, b);
                                      _updateTotals();
                                    });
                                  },
                                ) : Container(),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ) ,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: model.quote.detail![widget.i].productsSuggested![b].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                      style: CustomStyles.styleMobileVolcanic400,
                                    ),
                                    TextSpan(text: " - ${model.quote.detail![widget.i].productsSuggested![b].brand!}",
                                      style: CustomStyles.styleMobileVolcanic700,
                                    ),
                                    if(model.quote.detail![widget.i].productsSuggested![b].subBrand != null) ...[
                                      TextSpan(text: ", ${model.quote.detail![widget.i].productsSuggested![b].subBrand!}",
                                        style: CustomStyles.styleMobileVolcanic700,
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: currencyFormat.format(model.quote.detail![widget.i].productsSuggested![b].salePrice! * model.quote.detail![widget.i].productsSuggested![b].quantity!),
                                      style: CustomStyles.styleMobileBlue700,
                                    ),
                                    TextSpan(text: " (${currencyFormat.format(model.quote.detail![widget.i].productsSuggested![b].salePrice!)} c/u)",
                                      style: CustomStyles.styleMobileBlue400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          child: _QuantityWidget(i: widget.i, b: b, listenerUpdateTotals: _updateTotals),
                        )
                      ],
                    ),
                  ),
                },
              },
              if((model.quote.detail![widget.i].productsSuggested!.length - productsFiltered.toList().length) > 0) ...{
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12), bottomRight: Radius.circular(12)),
                      color: CustomColors.volcanicBlue,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell (
                      onTap: () => {
                        setState(() {
                          opened = !opened;
                        })
                      },
                      borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(12), bottomRight: Radius.circular(12)),
                      child: FractionallySizedBox(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.4,
                          child: SizedBox(
                              width: double.infinity,
                              height: 33,
                              child: Center(child: Text(opened ? "Ocultar opciones" : (model.quote.detail![widget.i].productsSuggested!.length - productsFiltered.toList().length) >= 2 ? "${(model.quote.detail![widget.i].productsSuggested!.length - productsFiltered.toList().length).toString()} opciones más" : "${(model.quote.detail![widget.i].productsSuggested!.length - productsFiltered.toList().length).toString()} opción más",
                                style: CustomStyles.styleMobileWhite14600,),)
                          )
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        )
    );
  }

  _updateTotals() async {
    if (mounted) {
      model.calculateTotals();
      widget.listener();
    }
  }

}


class _QuantityWidget extends StatefulWidget {
  const _QuantityWidget({Key? key, required this.i, required this.b, required this.listenerUpdateTotals}) : super(key: key);
  final int i; final int b;
  final VoidCallback listenerUpdateTotals;

  @override
  _QuantityWidgetState createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<_QuantityWidget> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  late QuoteViewModel _model;

  TextEditingController textEditingController = TextEditingController();
  bool indicator = false;

  @override
  void initState() {
    super.initState();
    _model = context.read<QuoteViewModel>();
    textEditingController.addListener(() {
      if(indicator == true) {
        _model.onUpdateQuantity(
          widget.i, widget.b, int.parse(textEditingController.text),);
        widget.listenerUpdateTotals();
      }
      indicator = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(8),
      width: 90,
      child: context.read<QuoteViewModel>().version != 'original' ? NumberInputWithIncrementDecrement(
        controller: textEditingController,
        initialValue: _model.quote.detail![widget.i].productsSuggested![widget.b].quantity!,
        onIncrement: (num newlyIncrementedValue) {
          print('Newly incremented value is $newlyIncrementedValue');
          //model.saveNewQuantity(widget.i, b, newlyIncrementedValue.toInt(), model.quote.detail![widget.i]);
          _model.onUpdateQuantity(widget.i, widget.b, newlyIncrementedValue.toInt(),);
          widget.listenerUpdateTotals();
        },
        onDecrement: (num newlyDecrementedValue) {
          print('Newly decremented value is $newlyDecrementedValue');
          //model.saveNewQuantity(widget.i, b, newlyDecrementedValue.toInt(), model.quote.detail![widget.i]);
          _model.onUpdateQuantity(widget.i, widget.b, newlyDecrementedValue.toInt(),);
          widget.listenerUpdateTotals();
        },
        numberFieldDecoration: InputDecoration(
          border: InputBorder.none,
        ),
        widgetContainerDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFFF9FAFF),
          border: Border.all(
            color: Color(0xFFE6E8F2),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        separateIcons: true,
        decIconDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
          ),
        ),
        incIconDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
          ),
        ),
        incDecBgColor: Colors.transparent,
        incIcon: Icons.expand_less,
        decIcon: Icons.expand_more,
        decIconColor: CustomColors.volcanicBlue,
        incIconColor: CustomColors.volcanicBlue,
        decIconSize: 14,
        incIconSize: 14,
      ) : Text(
        _model.quote.detail![widget.i].productsSuggested![widget.b].quantity.toString(),
        style:  CustomStyles.styleMobileVolcanic400,
        textAlign: TextAlign.left,
      ),
    );
  }
}


class QuoteHeaderMobile extends StatelessWidget {
  QuoteHeaderMobile({required this.total, required this.onAcceptQuote, required this.consecutive});
  double total;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  final VoidCallback onAcceptQuote;
  String consecutive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 24),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/voltz_logo.svg',
            width: 39.69,
            height: 19.86,
          ),
          const Spacer(),
          SizedBox(width: 16,),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                const TextSpan(text: 'Cotización ',
                  style: TextStyle(
                    fontFamily: "Hellix",
                    color: CustomColors.volcanicBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,),
                ),
                TextSpan(text: "#$consecutive",
                  style: const TextStyle(
                    fontFamily: "Hellix",
                    color: CustomColors.volcanicBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class QuoteTotalsMobile extends StatefulWidget {
  const QuoteTotalsMobile({Key? key, required this.tax, required this.total, required this.subTotal,
    required this.discount, this.isSaveActive = false, required this.quoteId, required this.onAcceptQuote, required this.totalProducts}) : super(key: key, );
  final double tax;
  final double total;
  final double subTotal;
  final double discount;
  final bool isSaveActive;
  final String quoteId;
  final int totalProducts;
  final VoidCallback onAcceptQuote;

  @override
  _QuoteTotalsMobileState createState() => _QuoteTotalsMobileState();
}

class _QuoteTotalsMobileState extends State<QuoteTotalsMobile> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.volcanicBlue,
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.totalProducts} productos",
                  style: CustomStyles.styleWhiteUno,
                ),
                Text(
                  "${currencyFormat.format(widget.total)} (iva incluido)",
                  style: CustomStyles.styleWhiteUno,
                ),
              ],
            ),
          ),
          ),
          if(context.read<QuoteViewModel>().version != 'original') ...[
            Expanded(
              child: Container(
                  width: 107,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: 107,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(26),),
                            color: CustomColors.energyYellow,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(26)),
                              hoverColor: CustomColors.energyYellow,
                              onTap: (){
                                _Dialogs dialog = _Dialogs();
                                dialog.showAlertDialog(context, widget.onAcceptQuote, context.read<QuoteViewModel>().createConfirmMessage(), widget.quoteId);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                alignment: Alignment.center,
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text('Aceptar', style: CustomStyles.styleMobileVolcanicBlue18x600,)
                                  ],
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  )
              ),
            )
          ],
        ],
      ),
    );
  }
}


class _Dialogs {

  showAlertDialog(BuildContext context, VoidCallback onConfirm, String message, String quoteId) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hacer pedido"),
          titleTextStyle:
          TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,fontSize: 20),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar")
            ),
            ElevatedButton(
                onPressed: () async {
                  onConfirm();
                  Navigator.of(context).pop();
                },
                child: const Text("Confirmar")),
          ],
          content: Text(message),
        );
      },
    );
  }
}