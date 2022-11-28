
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../common/header.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';

class CartConfirmation extends StatefulWidget {
  const CartConfirmation({Key? key, required this.quoteId, required this.version}) : super(key: key);
  final String quoteId;
  final String? version;

  @override
  _CartConfirmationState createState() => _CartConfirmationState();
}

class _CartConfirmationState extends State<CartConfirmation> {
  late QuoteViewModel model;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteViewModel>.nonReactive(
      viewModelBuilder: () => QuoteViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
            backgroundColor: CustomColors.grayBackground,
            body: Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Header(),
                  _Container(),
                ],
              ),
            )
        );
      },
      onModelReady: (viewModel) => viewModel.initConfirmation(widget.quoteId, widget.version),
    );
  }
}

class _Container extends StatelessWidget {
  @override
  Widget build(
      BuildContext context,
      ) {
    return Expanded(
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 100, right: 100),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 40),
                      child: Text('Tu cotización', style: CustomStyles.styleSafeBlue24700),),
                    Expanded(child: _CartContent(),),
                  ],
                ),
              ),
              _Resume(),
            ],
          )
      ),
    );
  }
}

class _Resume extends HookViewModelWidget<QuoteViewModel> {
  _Resume({Key? key}) : super(key: key, reactive: true);
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    return Builder(
      builder: (BuildContext context) {
        if ( viewModel.quote.detail != null) {
          return Container(
              padding: const EdgeInsets.only(top: 100, right: 80, left: 80),
              color: CustomColors.safeBlue,
              width: 410,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de compra', style: CustomStyles.styleWhite18700,),
                  const SizedBox(height: 10,),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Productos (${viewModel.quote.detail!.length.toString()})', style: CustomStyles.styleWhite16400,),
                      const Spacer(),
                      SelectableText(
                        currencyFormat.format(viewModel.quote.totals!.subTotal),
                        style: CustomStyles.styleWhite16400,),
                    ],
                  ),
                  const SizedBox(height: 7,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'IVA (16%)', style: CustomStyles.styleWhite16400,),
                      const Spacer(),
                      SelectableText(
                        currencyFormat.format(viewModel.quote.totals!.tax),
                        style: CustomStyles.styleWhite16400,),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Envio', style: CustomStyles.styleWhite16400,),
                      const Spacer(),
                      if (viewModel.quote.shipping == null ||
                          viewModel.quote.shipping!.total == 0)...[
                        SelectableText('Gratis',
                          style: CustomStyles.styleEnergyYellow_416x600,),
                      ] else
                        ...[
                          SelectableText(currencyFormat.format(
                              viewModel.quote.shipping!.total),
                            style: CustomStyles.styleWhite16400,),
                        ]
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Total pedido', style: CustomStyles.styleWhite16400,),
                      const Spacer(),
                      SelectableText(
                        '${currencyFormat.format(viewModel.quote.totals!.total)} MXN',
                        style: CustomStyles.styleWhite16400,),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6),),
                        color: CustomColors.energyYellow,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          hoverColor: CustomColors.energyYellowHover,
                          onTap: (){
                            _Dialogs dialog = _Dialogs();
                            dialog.showAlertDialog(
                                context,
                                  () async {viewModel.onGenerateOrder(context);},
                                viewModel.createConfirmMessage(),
                                viewModel.quote.id!,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            alignment: Alignment.center,
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Hacer pedido', textAlign: TextAlign.center , style: CustomStyles.styleVolcanic16600,),
                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 30,),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        return viewModel.navigateToQuoteView();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('Regresar al carrito', style: CustomStyles.styleWhite16x600Underline, textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                ],
              )
          );
        } else {
          return Container(color: CustomColors.safeBlue);
        }
      },
    );
  }

}

class _CartContent extends HookViewModelWidget<QuoteViewModel> {
  _CartContent({Key? key,}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    return  Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Text('Productos incluidos (${viewModel.quote.detail!.length})', style: CustomStyles.styleVolcanic20700 ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          ),
          Expanded(child: CartList(), ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Los precios pueden cambiar, sin previo aviso.",
                    style: CustomStyles.styleMuggleGray_414x400,),
                  TextSpan(text: " ¡Haz tu pedido ya!",
                    style: CustomStyles.styleSafeBlue14x600,),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: CustomColors.energyYellow_20,
            margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 0),
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(
                    'assets/svg/prime_voltz_ico.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  "Total ahorro",
                  style: CustomStyles.styleMuggleGray_418x400,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
                const Spacer(),
                _LabelSavings(),
              ],
            )
          ),
        ],
      ),
    );
  }
}

class _LabelSavings extends HookViewModelWidget<QuoteViewModel> {
  _LabelSavings({Key? key}) : super(key: key, reactive: true);
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget buildViewModelWidget(BuildContext context,
      QuoteViewModel viewModel,) {
    return Builder(
        builder: (BuildContext context) {
          if (viewModel.quote.detail != null) {
            return SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: "   -${currencyFormat.format(viewModel.quote.totals!.saving!)} ",
                    style: CustomStyles.styleMuggleGray_418x400,),
                ],
              ),
              textAlign: TextAlign.left,
            );
          } else {
            return Text("Calculando... ",
              style: CustomStyles.styleMuggleGray_418x400,);
          }
        }
    );
  }
}


class CartList extends HookViewModelWidget<QuoteViewModel> {
  const CartList({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    return Builder(
      builder: (BuildContext context) {
        if (viewModel.quote.detail != null) {
          html.window.history.pushState(null, 'Voltz - Cotización ${viewModel.quote.consecutive}', '?cotz=${viewModel.quote.id!}');
          print('Se entra a crear la lista');
          return
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 30),
                  reverse: false,
                  controller: viewModel.scrollController,
                  itemCount: viewModel.selectedProducts.length,
                  itemBuilder: (context, index) {
                    return _CartItemView(product: viewModel.selectedProducts[index]);
                  },
                ),
              )
            );
        } else {
          return
          const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class _CartItemView extends StatefulWidget {
  _CartItemView({Key? key, required this.product}) : super(key: key);
  ProductsSuggested product;

  @override
  _CartItemState createState() => _CartItemState();
}
class _CartItemState extends State<_CartItemView>  {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(widget.product.coverImage == null) ...[
              SizedBox(
                height: 50,
                width: 50,
                child: SvgPicture.asset(
                  'assets/svg/no_image_ico.svg',
                  width: 50,
                  height: 50,
                ),
              )

            ] else ...[
              SizedBox(
                height: 50,
                width: 50,
                child: Image.network(widget.product.coverImage!)
              ),
            ],
            const SizedBox(width: 30,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      widget.product.skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                      style: CustomStyles.styleMuggleGray_414x600,
                      textAlign: TextAlign.left,
                      //overflow: TextOverflow.clip,
                    ),
                    SelectableText(
                      '${widget.product.brand ?? ''} (${widget.product.sku!})',
                      style: CustomStyles.styleMuggleGray_414x400,
                      textAlign: TextAlign.left,
                      //overflow: TextOverflow.clip,
                    ),
                    Row(
                      children: [
                        SelectableText(
                          '${widget.product.quantity!} ${widget.product.saleUnit!}',
                          style: CustomStyles.styleSafeBlue14x400,
                          textAlign: TextAlign.left,
                          //overflow: TextOverflow.clip,
                        ),
                        SelectableText(
                          '  x  ${currencyFormat.format(widget.product.price!.price2!)} c/u  =  ',
                          style: CustomStyles.styleSafeBlue14x400,
                          textAlign: TextAlign.left,
                          //overflow: TextOverflow.clip,
                        ),
                        SelectableText('${currencyFormat.format(widget.product.total!.afterDiscount!)} total',
                          style: CustomStyles.styleSafeBlue14x600,
                          textAlign: TextAlign.left,
                          //overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ],
                )
            ),
          ],
        )
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
                child: const Text("Cancelar")
            ),
            ElevatedButton(
                onPressed: () async {
                  onConfirm();
                  Navigator.of(context).pop();
                },
                child: const Text("Confirmar")),
          ],
          content: SelectableText(message),
        );
      },
    );
  }
}