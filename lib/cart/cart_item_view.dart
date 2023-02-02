import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/cart/cart_expandable_view.dart';
import 'package:maketplace/cart/product_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../quote/quote_model.dart';
import '../quote/quote_viewmodel.dart';
import '../utils/custom_colors.dart';
import '../utils/inputText.dart';
import '../utils/shimmer.dart';
import '../utils/style.dart';
import 'cart_item_viewmodel.dart';
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
          html.window.history.pushState(
              null,
              'Voltz - Cotización ${viewModel.quote.consecutive}',
              '?cotz=${viewModel.quote.id!}');
          return Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              reverse: false,
              controller: viewModel.scrollController,
              itemCount: viewModel.quote.detail!.length + 1,
              itemBuilder: (context, index) {
                if (index < viewModel.quote.detail!.length) {
                 /* return CartItemView(
                    i: index,
                  );*/
                  return ProductCard(
                    i: index,
                  );
                } else if (viewModel.quote.pendingProducts!.isNotEmpty) {
                  return ComebackLater(
                    totalProducts: viewModel.quote.pendingProducts!.length,
                  );
                } else {
                  return Container();
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
  CartItemView({
    Key? key,
    required this.i,
  }) : super(key: key);
  int i;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItemView> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartItemViewModel>.nonReactive(
        viewModelBuilder: () => CartItemViewModel(),
        onModelReady: (viewModel) => viewModel.initCartView(cartIndex: widget.i),
        fireOnModelReadyOnce: false,
        disposeViewModel: true,
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                  ),
                  height: 198,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _CartItemDetail(),
                      _QuantityCalculatorWidget()
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          );
        });
  }
}

class _CartItemDetail extends HookViewModelWidget<CartItemViewModel> {
  const _CartItemDetail({Key? key,})
      : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context,
      CartItemViewModel viewModel,) {
    return Expanded(
      child: MouseRegion(
        cursor: viewModel.product.source != "manual" ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: viewModel.product.source != "manual" ? () {
            openProductDetail(context, viewModel.product.productId!, viewModel);
          } : null,
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (viewModel.product.coverImage == null) ...[
                      SvgPicture.asset(
                        'assets/svg/no_image.svg',
                        width: 150,
                        height: 150,
                      ),
                    ] else ...[
                      Container(
                          width: 150,
                          height: 150,
                          child: Image.network(
                            viewModel.product.coverImage!,
                            height: 150,
                            width: 150,
                          ))
                    ]
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SelectableText(
                            viewModel.product.skuDescription!
                                .replaceAll("<em>", "")
                                .replaceAll("<\/em>", ""),
                            style: CustomStyles.styleVolcanic16600,
                            textAlign: TextAlign.left,
                            //overflow: TextOverflow.clip,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: viewModel.product.brand,
                                  style: CustomStyles.styleVolcanicBlueUno,
                                ),
                                TextSpan(
                                  text: " | ${viewModel.product.sku!}",
                                  style: CustomStyles.styleVolcanic14x400,
                                )
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              SelectableText(
                                "${viewModel.currencyFormat.format(viewModel.product.pricePublic!)}   ",
                                style:
                                CustomStyles.styleMuggleGray_416x600Tachado,
                              ),
                              if(viewModel.product.price!.dollarConversion != null && viewModel.product.price!.dollarConversion!.date != null) ...[
                                Tooltip(
                                  message: 'Precio originalmente en USD. Actualizado el ${viewModel.product.price!.dollarConversion!.date!.toDate()}',
                                  child: SelectableText(
                                    "${viewModel.currencyFormat.format(viewModel.product.price!.price1!)} ${viewModel.product.saleUnit}",
                                    style: CustomStyles.styleSafeBlue16x600Underline,
                                  ),
                                ),
                              ] else ... [
                                SelectableText(
                                  "${viewModel.currencyFormat.format(viewModel.product.price!.price1!)} ${viewModel.product.saleUnit}",
                                  style: CustomStyles.styleSafeBlue16x600,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  openProductDetail(BuildContext context, String productId, QuoteViewModel viewModel){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return getDialogDetailProduct(productId);
        });
  }

  Dialog getDialogDetailProduct(String productId){
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.limeAccent,
      //insetPadding: const EdgeInsets.symmetric(horizontal: 330, vertical: 100),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)),
      child: ProductView(productId: productId,),
    );
  }
}

class _QuantityCalculatorWidget extends HookViewModelWidget<CartItemViewModel> {
  const _QuantityCalculatorWidget({Key? key,}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      CartItemViewModel viewModel,
      ) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: CustomColors.muggleGray_4,
        ),
        padding: const EdgeInsets.all(20),
        width: 272,
        child: Column(children: [
          FocusScope(
            onFocusChange: (focused) {
              print('FocusScope: Input Has Focus:  ${viewModel.focusNodeInput.hasFocus}');
              print('FocusScope: Button has Focus:  ${viewModel.focusNodeButton.hasFocus}');
              print('FocusScope: Input has Primary Focus:  ${viewModel.focusNodeInput.hasPrimaryFocus}');
              print('FocusScope: Button has Primary Focus:  ${viewModel.focusNodeButton.hasPrimaryFocus}');
              print('FocusScope: Parent has Primary Focus:  ${viewModel.focusNodeInput.parent!.hasPrimaryFocus}');
              print('--------------------------------------');
            },
            child: Row(
              children: [
                Expanded(
                  child: InputTextV2(
                    focusNode: viewModel.focusNodeInput,
                    paddingContent: const EdgeInsets.only(
                        bottom: 5, top: 10, left: 15),
                    margin: const EdgeInsets.all(0),
                    textStyle: CustomStyles.styleWhite26x400,
                    textAlign: TextAlign.start,
                    controller: viewModel.textEditingController,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        topLeft: Radius.circular(6)),
                    onTap: () {
                      viewModel.lastValue = double.tryParse(
                          viewModel.textEditingController.text)!;
                    },
                    onChanged: (value) async {
                      await viewModel.onTextQtyChanged(value);
                    },
                    keyboardType:
                    const TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    inputFormatters: <TextInputFormatter>[
                      // for below version 2 use this
                      //FilteringTextInputFormatter.deny(RegExp(r'^\\s+$'), replacementString: 1.toString()),
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]+')),
                      FilteringTextInputFormatter.deny(RegExp(
                          r'^0+')), //users can't type 0 at 1st position),
                      // for version 2 and greater youcan also use this
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: viewModel.notifier,
                  builder: (BuildContext context, bool value,
                      Widget? child) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                        color: CustomColors.muggleGray_3,
                      ),
                      width: 100,
                      height: 38,
                      child: viewModel.notifier.value
                          ? TextFieldTapRegion(
                          child: TextButton(
                            focusNode: viewModel.focusNodeButton,
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty
                                  .resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  return CustomColors
                                      .muggleGray_3;
                                },
                              ),
                              backgroundColor:
                              MaterialStateProperty
                                  .resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  return CustomColors
                                      .muggleGray_3;
                                },
                              ),
                            ),
                            onPressed: () {
                              print('Se dio clic en Button');
                              viewModel.onPressCalculate(context);
                            },
                            child: Text(
                              'calcular',
                              style: CustomStyles
                                  .styleEnergyYellow14x500Underline,
                              textAlign: TextAlign.right,
                            ),
                          ),
                      ) : Container(),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SelectableText(
                'Precio x cantidad',
                style: CustomStyles.styleWhite14x400,
                textAlign: TextAlign.left,
                //overflow: TextOverflow.clip,
              ),
              const Spacer(),
              Shimmer(
                linearGradient: viewModel.shimmerGradientDarkBackground,
                child: ShimmerLoading(
                  isLoading:
                  viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals,
                  shimmerEmptyBox: const ShimmerEmptyBox(
                    width: 100,
                    height: 15,
                  ),
                  child: viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals
                      ? Container()
                      : SelectableText(
                    viewModel.currencyFormat.format(viewModel
                        .quote
                        .detail![viewModel.cartIndex]
                        .productsSuggested![viewModel.suggestedIndex]
                        .price!
                        .price2 ??
                        ''),
                    style: viewModel
                        .quote
                        .detail![viewModel.cartIndex]
                        .productsSuggested![viewModel.suggestedIndex]
                        .price!
                        .price1 !=
                        viewModel
                            .quote
                            .detail![viewModel.cartIndex]
                            .productsSuggested![viewModel.suggestedIndex]
                            .price!
                            .price2
                        ? CustomStyles.styleEnergyYellow14x400
                        : CustomStyles.styleWhite14x400,
                    textAlign: TextAlign.left,
                    //overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SelectableText(
                'Total',
                style: CustomStyles.styleWhite14x400,
                textAlign: TextAlign.left,
                //overflow: TextOverflow.clip,
              ),
              const Spacer(),
              Shimmer(
                linearGradient: viewModel.shimmerGradientDarkBackground,
                child: ShimmerLoading(
                  isLoading:
                  viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals,
                  shimmerEmptyBox: const ShimmerEmptyBox(
                    width: 100,
                    height: 15,
                  ),
                  child: viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals
                      ? Container()
                      : SelectableText(
                    viewModel.currencyFormat.format(viewModel
                        .quote
                        .detail![viewModel.cartIndex]
                        .productsSuggested![viewModel.suggestedIndex]
                        .total!
                        .afterDiscount!),
                    style: CustomStyles.styleWhite14x400,
                    textAlign: TextAlign.left,
                    //overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                await viewModel.onDeleteSku(
                    viewModel.quote.detail![viewModel.cartIndex]);
                return viewModel.notifyListeners();
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Quitar este producto',
                  style:
                  CustomStyles.styleMuggleGray_214x400Underline,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          /*Container(
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
                        const Text('No lo quiero',)
                      ],
                    ),
                  ),
                ),
              )
          ),*/
        ]));
  }
}
