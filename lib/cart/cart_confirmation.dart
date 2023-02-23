import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;
import 'package:maketplace/common/header.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/utils/custom_colors.dart';

class CartConfirmation extends StatefulWidget {
  const CartConfirmation({Key? key, required this.quoteId,}) : super(key: key);
  final String quoteId;

  @override
  CartConfirmationState createState() => CartConfirmationState();
}

class CartConfirmationState extends State<CartConfirmation> {
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
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Header(),
                  _Container(),
                ],
              ),
            ));
      },
      onViewModelReady: (viewModel) => viewModel.initConfirmation(widget.quoteId,),
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
          margin: const EdgeInsets.only(left: 100, right: 100),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 40),
                      child: Text('Tu cotización', style: CustomStyles.styleSafeBlue24700),
                    ),
                    const Expanded(
                      child: _CartContent(),
                    ),
                  ],
                ),
              ),
              _Resume(),
            ],
          )),
    );
  }
}

class _Resume extends StackedHookView<QuoteViewModel> {
  _Resume({Key? key}) : super(key: key, reactive: true);
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (viewModel.quote.detail != null) {
          return Container(
              padding: const EdgeInsets.only(top: 100, right: 80, left: 80),
              color: CustomColors.safeBlue,
              width: 410,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de compra',
                    style: CustomStyles.styleWhite18700,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Productos (${viewModel.quote.detail!.length.toString()})',
                        style: CustomStyles.styleWhite16400,
                      ),
                      const Spacer(),
                      SelectableText(
                        currencyFormat.format(viewModel.quote.totals!.subTotal! - viewModel.quote.totals!.discount!),
                        style: CustomStyles.styleWhite16400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'IVA (16%)',
                        style: CustomStyles.styleWhite16400,
                      ),
                      const Spacer(),
                      SelectableText(
                        currencyFormat.format(viewModel.quote.totals!.tax),
                        style: CustomStyles.styleWhite16400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Envio',
                        style: CustomStyles.styleWhite16400,
                      ),
                      const Spacer(),
                      if (viewModel.quote.shipping == null || viewModel.quote.shipping!.total == 0) ...[
                        SelectableText(
                          'Gratis',
                          style: CustomStyles.styleEnergyYellow_416x600,
                        ),
                      ] else ...[
                        SelectableText(
                          currencyFormat.format(viewModel.quote.shipping!.total),
                          style: CustomStyles.styleWhite16400,
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectableText(
                        'Total pedido',
                        style: CustomStyles.styleWhite16400,
                      ),
                      const Spacer(),
                      SelectableText(
                        '${currencyFormat.format(viewModel.quote.totals!.total)} MXN',
                        style: CustomStyles.styleWhite16400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                        color: CustomColors.energyYellow,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                          hoverColor: CustomColors.energyYellowHover,
                          onTap: () {
                            _Dialogs dialog = _Dialogs();
                            dialog.showAlertDialog(
                              context,
                              () async {
                                viewModel.onGenerateOrder(context);
                              },
                              viewModel.createConfirmMessage(),
                              viewModel.quote.id!,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Hacer pedido',
                                  textAlign: TextAlign.center,
                                  style: CustomStyles.styleVolcanic16600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        return viewModel.navigateToQuoteView();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Regresar al carrito',
                          style: CustomStyles.styleWhite16x600Underline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        return viewModel.generatePdf();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Descargar cotizacion en pdf',
                          style: CustomStyles.styleWhite16x600Underline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        } else {
          return Container(color: CustomColors.safeBlue);
        }
      },
    );
  }
}

class _CartContent extends StackedHookView<QuoteViewModel> {
  const _CartContent({
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  //
                  color: CustomColors.grayBackground_2,
                  width: 1.0,
                ),
              ),
              color: Colors.white,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: Text('Productos incluidos (${viewModel.quote.detail!.length})', style: CustomStyles.styleVolcanic20700),
          ),
          const Expanded(
            child: CartList(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Los precios pueden cambiar, sin previo aviso.",
                    style: CustomStyles.styleMuggleGray_414x400,
                  ),
                  TextSpan(
                    text: " ¡Haz tu pedido ya!",
                    style: CustomStyles.styleSafeBlue14x600,
                  ),
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
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Descuento adicional Voltz",
                    style: CustomStyles.styleMuggleGray_418x400,
                    textAlign: TextAlign.left,
                    //overflow: TextOverflow.clip,
                  ),
                  const Spacer(),
                  _LabelSavings(),
                ],
              )),
        ],
      ),
    );
  }
}

class _LabelSavings extends StackedHookView<QuoteViewModel> {
  _LabelSavings({Key? key}) : super(key: key, reactive: true);
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Builder(builder: (BuildContext context) {
      if (viewModel.quote.detail != null) {
        return SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "   -${currencyFormat.format(viewModel.quote.totals!.discount!)} ",
                style: CustomStyles.styleMuggleGray_418x400,
              ),
            ],
          ),
          textAlign: TextAlign.left,
        );
      } else {
        return Text(
          "Calculando... ",
          style: CustomStyles.styleMuggleGray_418x400,
        );
      }
    });
  }
}

class CartList extends StackedHookView<QuoteViewModel> {
  const CartList({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (model.quote.detail != null) {
          // if (defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows) {
          // html.window.history.pushState(null, 'Voltz - Cotización ${model.quote.consecutive}', '?cotz=${model.quote.id!}');
          // }
          if (kDebugMode) {
            print('Se entra a crear la lista');
          }
          return Expanded(
              child: Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
              reverse: false,
              controller: model.scrollController,
              itemCount: model.selectedProducts.length,
              itemBuilder: (context, index) {
                return CartItemView(product: model.selectedProducts[index], textEditingController: TextEditingController());
              },
            ),
          ));
        } else {
          return const Center(
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

class CartItemView extends StatelessWidget {
  const CartItemView({Key? key, required this.product, required this.textEditingController}) : super(key: key);
  final Product product;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (product.coverImage == null) ...[
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
              SizedBox(height: 50, width: 50, child: Image.network(product.coverImage!)),
            ],
            const SizedBox(
              width: 30,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(
                  product.skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                  style: CustomStyles.styleMuggleGray_414x600,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
                const SizedBox(
                  height: 3,
                ),
                SelectableText(
                  '${product.brand ?? ''} (${product.sku!})',
                  style: CustomStyles.styleMuggleGray_414x400,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    SelectableText(
                      '${product.quantity!} ${product.saleUnit!}',
                      style: CustomStyles.styleSafeBlue14x400,
                      textAlign: TextAlign.left,
                      //overflow: TextOverflow.clip,
                    ),
                    SelectableText(
                      '  x  ${currencyFormat.format(product.price!.price2!)} c/u  =  ',
                      style: CustomStyles.styleSafeBlue14x400,
                      textAlign: TextAlign.left,
                      //overflow: TextOverflow.clip,
                    ),
                    SelectableText(
                      '${currencyFormat.format(product.total!.afterDiscount!)} total',
                      style: CustomStyles.styleSafeBlue14x600,
                      textAlign: TextAlign.left,
                      //overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ],
            )),
          ],
        ));
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
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar")),
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
