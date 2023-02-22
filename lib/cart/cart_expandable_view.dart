import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

import '../product/product_views.dart';
import '../quote/quote_viewmodel.dart';
import '../utils/inputText.dart';
import '../utils/shimmer.dart';
import '../utils/style.dart';
import 'cart_expandible_viewmodel.dart';
import 'cart_item_viewmodel.dart';
import 'cart_view.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({Key? key})
      : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GridViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      builder: (context, viewModel, child) {
        var media = MediaQuery.of(context).size;
        if (viewModel.selectedProducts.isEmpty) {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        print('Se ejecuta renderizado de la vista reactiva de GridViewModel');
        html.window.history.pushState(null, 'Voltz - Cotización ${viewModel.quote.consecutive}', '?cotz=${viewModel.quote.id!}');
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: media.width >= CustomStyles.mobileBreak ? media.height - CustomStyles.desktopHeaderHeight : media.height - CustomStyles.mobileHeaderHeight,
              width: media.width >= CustomStyles.mobileBreak ? (media.width - 310) : media.width,
              child: CustomScrollView(
                slivers: <Widget>[
                  if (media.width >= CustomStyles.desktopBreak) ...[
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                    ),
                  ],
                  const SliverToBoxAdapter(
                    child: CustomerInfo(),
                  ),
                  if (media.width >= CustomStyles.desktopBreak) ...[
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                    ),
                  ],
                  SliverPadding(
                    padding: media.width >= CustomStyles.mobileBreak ? const EdgeInsets.only(right: 25, left: 25) : const EdgeInsets.only(right: 0, left: 0),
                    sliver: SliverMasonryGrid.count(
                      //maxCrossAxisExtent: 362,
                      childCount: viewModel.quote.pendingProducts != null && viewModel.quote.pendingProducts!.isNotEmpty
                          ? viewModel.selectedProducts.length + 1
                          : viewModel.selectedProducts.length,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      itemBuilder: (context, index) {
                        if (index < viewModel.selectedProducts.length) {
                          return ProductCard(
                            i: index,
                          );
                        } else if (viewModel.quote.pendingProducts != null && viewModel.quote.pendingProducts!.isNotEmpty) {
                          return const PendingCard();
                        } else {
                          return Container();
                        }
                      },
                      crossAxisCount: ((media.width - 310 - 25) / 387).truncateToDouble().toInt() != 0 ? ((media.width - 310 - 25) / 387).truncateToDouble().toInt() : 1,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 25,
                    ),
                  ),
                  if (media.width < CustomStyles.mobileBreak) ...[
                    const SliverToBoxAdapter(
                      child: Resume(),
                    ),
                  ]
                ],
              ),
            )
          ],
        );
      },
      viewModelBuilder: () => GridViewModel(),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.i,
  }) : super(key: key);
  final int i;

  @override
  Widget build(BuildContext context) {
    //if (widget.i == 1) return NoFoundCard();
    return ViewModelBuilder<CardItemViewModel>.reactive(
        viewModelBuilder: () => CardItemViewModel(),
        onViewModelReady: (viewModel) => viewModel.initCartView(
              cardIndex: i,
            ),
        fireOnViewModelReadyOnce: false,
        disposeViewModel: true,
        createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
          print('_ProductCard ... Se actualiza la vista ');
          return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 362.0,
              padding: const EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                border: Border.all(color: const Color(0xFFD9E0FC), width: 1, style: BorderStyle.solid),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 362.0,
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (viewModel.selectedProducts[i].coverImage == null) ...[
                              SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.asset(
                                    'assets/images/no_photo.png',
                                    height: 120,
                                    width: 120,
                                  )),
                            ] else ...[
                              SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.network(
                                    viewModel.selectedProducts[i].coverImage!,
                                    height: 120,
                                    width: 120,
                                  )),
                            ],
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 175.0,
                              height: 120.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      //Esto es temporal mientras se programa en el backend todas las marcas para la bd
                                      if(viewModel.selectedProducts[i].brandFavicon != null)...[
                                        Image.network(viewModel.selectedProducts[i].brandFavicon!, width: 16, height: 17,),
                                        const SizedBox(width: 5,),
                                      ],
                                      SelectableText(
                                        viewModel.selectedProducts[i].brand!,
                                        maxLines: 1,
                                        style: GoogleFonts.inter(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          color: CustomColors.dark,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SelectableText(
                                        viewModel.selectedProducts[i].sku!,
                                        maxLines: 1,
                                        style: GoogleFonts.inter(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: CustomColors.dark,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SelectableText(
                                        viewModel.currencyFormat.format(viewModel.selectedProducts[i].pricePublic!),
                                        maxLines: 1,
                                        style: GoogleFonts.inter(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          decoration: TextDecoration.lineThrough,
                                          color: const Color(0xFF9C9FAA),
                                          height: 1.1,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        color: CustomColors.yellowVoltz,
                                        child: SelectableText(
                                          "${(viewModel.selectedProducts[i].discountRate!).toStringAsFixed(2)}%",
                                          enableInteractiveSelection: false,
                                          maxLines: 1,
                                          style: GoogleFonts.inter(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 19,
                                        child: Shimmer(
                                          linearGradient: viewModel.shimmerGradientWhiteBackground,
                                          child: ShimmerLoading(
                                            isLoading: viewModel.selectedProducts[i].isCalculatingProductTotals,
                                            shimmerEmptyBox: const ShimmerEmptyBox(
                                              width: 160,
                                              height: 19,
                                            ),
                                            child: Row(
                                              children: [
                                                SelectableText(
                                                  viewModel.currencyFormat.format(viewModel.selectedProducts[i].price!.price2!),
                                                  maxLines: 1,
                                                  style: GoogleFonts.inter(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.0,
                                                    color: CustomColors.dark,
                                                    height: 1.1,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SelectableText(
                                                  viewModel.selectedProducts[i].saleUnit!,
                                                  maxLines: 1,
                                                  style: GoogleFonts.inter(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.0,
                                                    color: CustomColors.dark,
                                                    height: 1.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/copa_icon.svg',
                                        width: 12,
                                        height: 12,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SelectableText(
                                        "Precio según cantidad",
                                        maxLines: 1,
                                        style: GoogleFonts.inter(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0,
                                          color: CustomColors.dark,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SelectableText(
                          viewModel.selectedProducts[i].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: CustomColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.selectedProducts[i].techFile != null) ...[
                    getHeader(context, viewModel),
                  ] else ...[
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFD9E0FC),
                    ),
                  ],
                  if (viewModel.selectedProducts[i].isCardExpanded) ...[
                    ProductDetail(productId: viewModel.selectedProducts[i].id!,),
                  ],
                  _QuantityCalculatorWidget(index: i),
                ],
              ),
            ),
          ]);
        });
  }

  Widget getHeader(BuildContext context, CardItemViewModel viewModel) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => viewModel.expandOrCollapseCard(i),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 360.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFE4E9FC), width: 1, style: BorderStyle.solid)),
                ),
                padding: const EdgeInsets.only(top: 20.0, right: 25.0, bottom: 20.0, left: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: SvgPicture.asset(
                        'assets/svg/info_icon.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 167.0,
                      child: Text(
                        'Detalles del producto',
                        style: GoogleFonts.inter(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: CustomColors.dark,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: viewModel.selectedProducts[i].isCardExpanded ? const Icon(Icons.expand_less, size: 24) : const Icon(Icons.expand_more, size: 24),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class _QuantityCalculatorWidget extends StackedHookView<CardItemViewModel> {
  const _QuantityCalculatorWidget({Key? key, required this.index}) : super(key: key, reactive: true);
  final int index;

  Widget getQtyLabel(CardItemViewModel viewModel, double elevation) {
    print('getQytLabel con elevation $elevation');
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: GestureDetector(
          onTap: () => viewModel.activateCalculator(),
          child: Material(
            elevation: elevation,
            color: const Color(0xFFE4E9FC),
            child: Container(
              height: 60,
              width: 188,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    viewModel.textEditingController.text,
                    style: GoogleFonts.inter(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: CustomColors.dark,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    ' ${viewModel.selectedProducts[index].saleUnit}',
                    style: GoogleFonts.inter(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: CustomColors.dark,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  Widget builder(
    BuildContext context,
    CardItemViewModel viewModel,
  ) {
    return Builder(builder: (BuildContext context) {
      return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(25),
          width: 362,
          child: Column(children: [
            FocusScope(
              onFocusChange: (focused) {
                print('FocusScope: Input Has Focus:  ${viewModel.focusNodeInput.hasFocus}');
                print('FocusScope: Button has Focus:  ${viewModel.focusNodeButton.hasFocus}');
                print('FocusScope: Input has Primary Focus:  ${viewModel.focusNodeInput.hasPrimaryFocus}');
                print('FocusScope: Button has Primary Focus:  ${viewModel.focusNodeButton.hasPrimaryFocus}');
                //print('FocusScope: Parent has Primary Focus:  ${viewModel.focusNodeInput.parent!.hasPrimaryFocus}');
                print('--------------------------------------');
                //print('FocusScope: Add has Primary Focus:  ${viewModel.focusAdd.parent!.hasPrimaryFocus}');
                //print('FocusScope: Add has Focus:  ${viewModel.focusAdd.hasFocus}');
                //print('FocusScope: Add has Primary Focus:  ${viewModel.focusAdd.hasPrimaryFocus}');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 288,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      color: Color(0xFFE4E9FC),
                    ),
                    child: Row(
                      children: [
                        if (!viewModel.isCalculatorActive) ...[
                          Container(
                            height: 60,
                            width: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              style: null,
                              icon: const Icon(
                                Icons.remove,
                                size: 24,
                              ),
                              onPressed: () => viewModel.activateCalculator(),
                            ),
                          ),
                          if (viewModel.isQtyLabelHighlight) ...[
                            getQtyLabel(viewModel, 2),
                          ] else ...[
                            getQtyLabel(viewModel, 0),
                          ],
                          Container(
                            height: 60,
                            width: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              style: null,
                              icon: const Icon(
                                Icons.add,
                                size: 24,
                              ),
                              onPressed: () => viewModel.activateCalculator(),
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: 288,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: const Color(0xFFE4E9FC),
                              border: Border.all(
                                color: CustomColors.dark, //                   <--- border color
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InputTextV3(
                                    focusNode: viewModel.focusNodeInput,
                                    paddingContent: const EdgeInsets.only(bottom: 14, top: 19, left: 15),
                                    margin: const EdgeInsets.all(0),
                                    textStyle: GoogleFonts.inter(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22.0,
                                      color: CustomColors.dark,
                                    ),
                                    textAlign: TextAlign.start,
                                    controller: viewModel.textEditingController,
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(6), topLeft: Radius.circular(6)),
                                    onTap: () async {
                                      viewModel.lastValue = double.tryParse(viewModel.textEditingController.text)!;
                                    },
                                    onChanged: (value) async {
                                      await viewModel.onTextQtyChanged(value);
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
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: 150,
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                                  alignment: Alignment.center,
                                  child: viewModel.isQtyControlOpen
                                      ? Container(
                                          width: 141.0,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: CustomColors.dark,
                                            borderRadius: BorderRadius.all(Radius.circular(200.0)),
                                          ),
                                          child: TextFieldTapRegion(
                                            child: TextButton(
                                              focusNode: viewModel.focusNodeButton,
                                              style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    return Colors.transparent;
                                                  },
                                                ),
                                                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    return Colors.transparent;
                                                  },
                                                ),
                                              ),
                                              onPressed: () {
                                                print('Se dio clic en Button onPressCalculate');
                                                viewModel.onPressCalculate(context, index);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                constraints: const BoxConstraints(
                                                  minHeight: 30.0,
                                                ),
                                                child: Text(
                                                  'Actualizar',
                                                  style: GoogleFonts.inter(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13.0,
                                                    color: const Color(0xFF9C9FAA),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: const [
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 26,
                  child: Shimmer(
                    linearGradient: viewModel.shimmerGradientWhiteBackground,
                    child: ShimmerLoading(
                      isLoading: viewModel.selectedProducts[index].isCalculatingProductTotals,
                      shimmerEmptyBox: const ShimmerEmptyBox(
                        width: 180,
                        height: 26,
                      ),
                      child: Row(
                        children: [
                          viewModel.selectedProducts[index].isCalculatingProductTotals
                              ? Container()
                              : SelectableText(
                            viewModel.currencyFormat.format(viewModel.selectedProducts[index].total!.afterDiscount ?? ''),
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 22.0,
                              color: CustomColors.dark,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.left,
                            //overflow: TextOverflow.clip,
                          ),
                          Text(
                            ' +iva',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: CustomColors.dark,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¡Disponibilidad inmediata!',
                  style: GoogleFonts.inter(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                    color: CustomColors.dark,
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                SizedBox(
                  height: 30,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {},
                        child: Text(
                          '¡Agregado!',
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: CustomColors.blueVoltz,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )),
                ),
                const Spacer(),
                SizedBox(
                  width: 60,
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          await viewModel.onDeleteSku(viewModel.quote.detail![index]);
                          return viewModel.notifyListeners();
                        },
                        child: Text(
                          'Quitar',
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: const Color(0xFF9C9FAA),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )),
                ),
              ],
            ),
          ]));
    });
  }
}

class PendingCard extends StackedHookView<QuoteViewModel> {
  const PendingCard({Key? key}) : super(key: key, reactive: false);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    var media = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
              color: CustomColors.dark,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            width: 362.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 362.0,
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/assistant_icon.png',
                        width: 62.0,
                        height: 62.0,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${model.quote.pendingProducts!.length} productos en cotización manual",
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 32.0,
                                color: Colors.white,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Estamos buscando el mejor precio y disponibilidad en cientos de proveedores",
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 362.0,
                  padding: const EdgeInsets.only(top: 35.0, right: 25.0, bottom: 35.0, left: 25.0),
                  decoration: const BoxDecoration(
                    color: CustomColors.dark,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "¡Pronto los agregaremos a tu cotización!",
                        style: GoogleFonts.inter(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          color: CustomColors.yellowVoltz,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${DateFormat.yMMMd().format(DateTime.parse(model.quote.createdAt!.toDate().toString()))} ${DateFormat.Hms().format(DateTime.parse(model.quote.createdAt!.toDate().toString()))} última actualización",
                        //viewModel.quote.convertTimestampToLocal(viewModel.quote.createdAt!).toString(),
                        style: GoogleFonts.inter(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: CustomColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
