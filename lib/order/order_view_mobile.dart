
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/order/order_viewmodel.dart';


class OrderTableDetailMobile extends StatefulWidget {
  OrderTableDetailMobile({Key? key, required this.i,}) : super(key: key);
  int i;

  @override
  _OrderTableDetailMobileState createState() => _OrderTableDetailMobileState();
}

class _OrderTableDetailMobileState extends State<OrderTableDetailMobile> {
  late OrderViewModel model;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = context.read<OrderViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
      label: "Pedido #${model.order!.consecutive.toString()}",
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
    Color headerColor = CustomColors.safeBlue;

    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4 ),
        child:  Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
                  color: headerColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex:1,
                        child: SelectableText( model.order!.detail![widget.i].productRequested!,
                          style: CustomStyles.styleMobileWhite500, //overflow: TextOverflow.clip,
                        )
                    ),
                  ],
                ),
              ),
              for(int b = 0; b <= model.order!.detail![widget.i].productsOrdered!.length -1; b++) ...{
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: b == model.order!.detail![widget.i].productsOrdered!.length -1 ? const BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)) : null,
                    color: CustomColors.blueBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: model.order!.detail![widget.i].productsOrdered![b].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                    style: CustomStyles.styleMobileVolcanic400,
                                  ),
                                  TextSpan(text: " - ${model.order!.detail![widget.i].productsOrdered![b].brand!}",
                                    style: CustomStyles.styleMobileVolcanic700,
                                  ),

                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SelectableText.rich(
                              TextSpan(
                                children: [

                                  TextSpan(text: currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].total!.afterDiscount!),
                                    style: CustomStyles.styleMobileBlue700,
                                  ),
                                  TextSpan(text: " (${currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].price!.price2!)} c/u)",
                                    style: CustomStyles.styleMobileBlue400,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: SelectableText(
                          model.order!.detail![widget.i].productsOrdered![b].quantity.toString(),
                          style: CustomStyles.styleVolcanicBlueDos,
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ),
              }
            ],
          ),
        )
    );
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

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(8),
      width: 90,
      child: SelectableText(
        _model.quote.detail![widget.i].productsSuggested![widget.b].quantity.toString(),
        style:  CustomStyles.styleMobileVolcanic400,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class OrderHeaderMobile extends StatelessWidget {
  const OrderHeaderMobile({super.key, required this.total, required this.consecutive});
  final double total;
  final String consecutive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
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
          const SizedBox(width: 16,),
          SelectableText.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Pedido ',
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
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class OrderTotalsMobile extends StatefulWidget {
  const OrderTotalsMobile({Key? key, required this.tax, required this.total, required this.subTotal,
    required this.shippingTotal, required this.quoteId, required this.totalProducts}) : super(key: key, );
  final double tax;
  final double total;
  final double subTotal;
  final double? shippingTotal;
  final String quoteId;
  final int totalProducts;

  @override
  _OrderTotalsMobileState createState() => _OrderTotalsMobileState();
}

class _OrderTotalsMobileState extends State<OrderTotalsMobile> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.volcanicBlue,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    "${widget.totalProducts} productos",
                    style: CustomStyles.styleWhiteUno,
                  ),
                  SelectableText(
                    "${currencyFormat.format(widget.total)} (iva incluido)",
                    style: CustomStyles.styleWhiteUno,
                  ),
                ],
              ),
            ),
          ),
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
          title: const SelectableText("Hacer pedido"),
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
                child: const SelectableText("Cancelar")
            ),
            ElevatedButton(
                onPressed: () async {
                  onConfirm();
                  Navigator.of(context).pop();
                },
                child: const SelectableText("Confirmar")),
          ],
          content: SelectableText(message),
        );
      },
    );
  }
}