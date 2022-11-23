
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:stacked_hooks/stacked_hooks.dart';
import '../quote/quote_model.dart';
import '../quote/quote_viewmodel.dart';
import '../utils/custom_colors.dart';
import '../utils/inputText.dart';
import '../utils/shimmer.dart';
import '../utils/style.dart';
import 'cart_view.dart';
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
              return
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    reverse: false,
                    controller: viewModel.scrollController,
                    itemCount: viewModel.quote.detail!.length + 1,
                    itemBuilder: (context, index) {
                      if (index < viewModel.quote.detail!.length) {
                        return CartItemView(viewModel: viewModel, i: index,);
                      } else {
                        return ComebackLater(totalProducts: viewModel.quote.pendingProducts!.length,);
                      }
                    },
                  ),
                );
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

class CartItemView extends StatefulWidget {
  CartItemView({Key? key, required this.i, required this.viewModel,}) : super(key: key);
  int i;
  QuoteViewModel viewModel;

  @override
  _CartItemState createState() => _CartItemState();
}
class _CartItemState extends State<CartItemView>  {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();
  late ProductsSuggested product;
  late int b;
  @override
  void initState() {
    super.initState();
    int i = 0;
    widget.viewModel.quote.detail![widget.i].productsSuggested?.forEach((element) {
      if(element.selected == true) {
        product = element;
        b = i;
        return;
      }
      i = i +1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30,),
        height: 221,
        child:  Row (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(product.coverImage == null) ...[
                  SvgPicture.asset(
                    'assets/svg/no_image_ico.svg',
                    width: 150,
                    height: 150,
                  ),
                ] else ...[
                  Image.network(product.coverImage!)
                ]
              ],
            ),
            const SizedBox(width: 20,),
            Padding(
              padding: EdgeInsets.only(top: 35, bottom: 35, right: 35,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SelectableText(
                            product.skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                            style: CustomStyles.styleVolcanicBlueUno,
                            textAlign: TextAlign.left,
                            //overflow: TextOverflow.clip,
                          ),
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: product.brand,
                                  style: CustomStyles.styleVolcanicBlueUno,),
                                TextSpan(text: " | ${product.sku!}",
                                  style: CustomStyles.styleVolcanic14x400,)
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "${currencyFormat.format(product.price!.pricePublic!)}",
                              style: CustomStyles.styleMuggleGray_416x600Tachado,),
                            TextSpan(text: "   ${currencyFormat.format(product.price!.price1!)} ${product.saleUnit}",
                              style: CustomStyles.styleSafeBlue16x600,),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            const SizedBox(width: 50,),
            _QuantityCalculatorWidget(i: widget.i, b: b, viewModel: widget.viewModel,)
          ],
        )
    );
  }
}

class _QuantityCalculatorWidget extends StatefulWidget {
  const _QuantityCalculatorWidget({Key? key, required this.i, required this.b,
    required this.viewModel,}) : super(key: key);
  final int i; final int b;
  final QuoteViewModel viewModel;
  @override
  _QuantityCalculatorWidgetState createState() => _QuantityCalculatorWidgetState();
}

class _QuantityCalculatorWidgetState extends State<_QuantityCalculatorWidget> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.viewModel.quote.detail![widget.i].productsSuggested![widget.b].quantity!.toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textEditingController.dispose();
    super.dispose();
  }

  /// Estos proceso de poner en Cola los Future debe ir por el hilo principal para evitar que
  /// se desordenen, y se ejecuten en orden inesperado **/
  ///

  Future<double> _onTextQtyChanged(String value) async {
    widget.viewModel.loading();
    double qty = double.tryParse(value) ?? 1;
    if(value.isEmpty){
      textEditingController.text = qty.toString();
      textEditingController.selection =
          TextSelection.collapsed(offset: textEditingController.text.length);
    }
    widget.viewModel.setQuantity(widget.i, widget.b, qty);
    return qty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: CustomColors.muggleGray_4,
        ), padding: const EdgeInsets.all(20),
        width: 272,
        child: Column(
        children: [
          InputTextV2(
            margin: const EdgeInsets.all(0),
            textStyle: CustomStyles.styleWhite26x400,
            textAlign: TextAlign.center,
            controller: textEditingController,
            onChanged: (value) async {
              await _onTextQtyChanged(value);
              widget.viewModel.onUpdateQuote();
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
            inputFormatters: <TextInputFormatter>[
              // for below version 2 use this
              //FilteringTextInputFormatter.deny(RegExp(r'^\\s+$'), replacementString: 1.toString()),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]+')),
              FilteringTextInputFormatter.deny(RegExp(r'^0+')), //users can't type 0 at 1st position),
              // for version 2 and greater youcan also use this
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              SelectableText(
                'Dcto.',
                style: CustomStyles.styleWhite14x400,
                textAlign: TextAlign.left,
                //overflow: TextOverflow.clip,
              ),
              const Spacer(),
              Shimmer(
                linearGradient: widget.viewModel.shimmerGradient2,
                child: ShimmerLoading(
                  isLoading: widget.viewModel.isLoading,
                  shimmerEmptyBox: const ShimmerEmptyBox(width: 100, height: 15,),
                  child: widget.viewModel.isLoading ? Container() :  SelectableText(
                    currencyFormat.format(widget.viewModel.quote.detail![widget.i].productsSuggested![widget.b].total!.discount),
                    style: CustomStyles.styleWhite14x400,
                    textAlign: TextAlign.left,
                    //overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              SelectableText(
                'Subtotal.',
                style: CustomStyles.styleWhite14x400,
                textAlign: TextAlign.left,
                //overflow: TextOverflow.clip,
              ),
              const Spacer(),
              Shimmer(
                linearGradient: widget.viewModel.shimmerGradient2,
                child: ShimmerLoading(
                  isLoading: widget.viewModel.isLoading,
                  shimmerEmptyBox: const ShimmerEmptyBox(width: 100, height: 15,),
                  child: widget.viewModel.isLoading ? Container() :  SelectableText(
                    currencyFormat.format(widget.viewModel.quote.detail![widget.i].productsSuggested![widget.b].total!.afterDiscount!),
                    style: CustomStyles.styleWhite14x400,
                    textAlign: TextAlign.left,
                    //overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
              width: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6),),
                color: Colors.white,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  hoverColor: CustomColors.muggleGray,
                  onTap: () async {
                    await widget.viewModel.onDeleteSku(widget.viewModel.quote.detail![widget.i]);
                    return widget.viewModel.notifyListeners();
                  },
                  child: Container(
                    width: 232,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    alignment: Alignment.center,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/discarded_item_icon.svg',
                          width: 24.0,
                          height: 24.0,
                        ),
                        const SizedBox(width: 15),
                        const Text('Descartar',)
                      ],
                    ),
                  ),
                ),
              )
          ),
        ]
      )
    );
  }
}