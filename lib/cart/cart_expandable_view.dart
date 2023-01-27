import 'dart:html' as html;
import 'dart:math' as math;
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/src/intl/number_format.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../products/product_viewmodel.dart';
import '../quote/quote_viewmodel.dart';
import '../utils/style.dart';
import 'cart_item_viewmodel.dart';
import 'cart_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class CartGrid extends HookViewModelWidget<QuoteViewModel> {
  const CartGrid({Key? key}) : super(key: key, reactive: true);

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
            color: Colors.red,
            child: LayoutBuilder(builder: (context, constraints) {
              return MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                itemCount: viewModel.quote.detail!.length + 1,
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  if (index < viewModel.quote.detail!.length) {
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
              );
              return GridView.builder(
                itemCount: viewModel.quote.detail!.length + 1,
                itemBuilder: (context, index) {
                  if (index < viewModel.quote.detail!.length) {
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 700 ? 3 : 1,
                  childAspectRatio: 1,
                ),
              );
            })
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


class ProductCard extends StatefulWidget {
  ProductCard({
    Key? key,
    required this.i,
  }) : super(key: key);
  int i;

  @override
  _ProductCard createState() => _ProductCard();
}

class _ProductCard extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartItemViewModel>.nonReactive(
        viewModelBuilder: () => CartItemViewModel(),
        onModelReady: (viewModel) => viewModel.initCartView(cartIndex: widget.i),
        fireOnModelReadyOnce: false,
        disposeViewModel: true,
        builder: (context, viewModel, child) {
    return Container(
      width: 360.0,
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.all(const Radius.circular(6.0)),
        border: Border.all(
            color: Color(0xFFD9E0FC),
            width: 1,
            style: BorderStyle.solid
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/favicon_tecnolite.png', width: 16, height: 17,),
                        SelectableText(
                          viewModel.product.brand!,
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                            color: CustomColors.darkVoltz,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          viewModel.product.sku!,
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: CustomColors.darkVoltz,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "${viewModel.currencyFormat.format(viewModel.product.pricePublic!)}   ",
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                            color: Color(0xFF9C9FAA),
                          ),
                        ),
                        SelectableText(
                          "-000.00%",
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "${viewModel.currencyFormat.format(viewModel.product.price!.price2!)}   ",
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: CustomColors.darkVoltz,
                          ),
                        ),
                        SelectableText(
                          viewModel.product.saleUnit!,
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            color: CustomColors.darkVoltz,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/copa_icon.svg',
                          width: 12,
                          height: 12,
                        ),
                        SelectableText(
                          "Precio según cantidad",
                          style: GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            color: CustomColors.darkVoltz,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SelectableText(viewModel.product.skuDescription!
                .replaceAll("<em>", "")
                .replaceAll("<\/em>", ""),
              style: GoogleFonts.inter(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: CustomColors.darkVoltz,
              ),
            ),
            getExpandableZone(context, viewModel),
          ],
        ),
      ),
    );
        });
  }

  Widget getExpandableZone(BuildContext context, CartItemViewModel viewModel){
    final formatCurrency = new NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0, locale: 'en');
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Container(
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: false,
            ),
            header: getHeader(context, viewModel),
            collapsed: Container(),
            expanded: ProductDetail(productId: viewModel.product.productId!),
          ),
        ),
      ),
    );
  }


  Widget getHeader(BuildContext context, CartItemViewModel viewModel){
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 360.0,
              height: 60.0,
              padding: const EdgeInsets.only(top: 20.0, right: 25.0, bottom: 20.0, left: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 24.0,
                    height: 24.0,
                    child: SvgPicture.asset('assets/svg/info_icon.svg', height: 24, width: 24,),
                  ),
                  Container(
                    child: Text(
                      'Detalles del producto',
                      style: GoogleFonts.inter(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: CustomColors.darkVoltz,
                      ),
                    ),
                    width: 167.0,
                    height: 16.0,
                  ),
                  ExpandableIcon(
                    theme: const ExpandableThemeData(
                      expandIcon: Icons.expand_less,
                      collapseIcon: Icons.expand_more,
                      iconColor: const Color(0xFF94A3B8), // concrete
                      iconSize: 28.0,
                      iconRotationAngle: math.pi,
                      iconPadding: EdgeInsets.only(right: 5),
                      hasIcon: false,
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}


class ProductDetail extends StatefulWidget {
  ProductDetail({
    Key? key,
    required this.productId,
  }) : super(key: key);
  String productId;

  @override
  _ProductDetail createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetail> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.nonReactive(
        viewModelBuilder: () => ProductViewModel(),
        onModelReady: (viewModel) => viewModel.init(widget.productId),
        fireOnModelReadyOnce: false,
        disposeViewModel: true,
        builder: (context, viewModel, child) {
  print(viewModel.product.skuDescription);
    if(viewModel.product.techFile!=null || viewModel.product.imageUrls != null || viewModel.product.features != null ||
    viewModel.product.makerWeb != null) {
      return getExpandedContent(context, viewModel);
    } else {
      return Container();
    }
        });
  }


  Widget getExpandedContent(BuildContext context, ProductViewModel viewModel){
    return Container(
      width: 310.0,
        padding: const EdgeInsets.all(25.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                    width: 310.0,
                    height: 60.0,
                    padding: const EdgeInsets.only(top: 20.0, right: 0.0, bottom: 20.0, left: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Ficha técnica',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: CustomColors.darkVoltz,
                            ),
                          ),
                          width: 102.0,
                          height: 16.0,
                        ),
                        Container(
                          width: 112.0,
                          height: 28.0,
                          padding: const EdgeInsets.only(top: 8.0, right: 24.0, bottom: 8.0, left: 24.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(const Radius.circular(200.0)),
                            border: Border.all(
                                color: Color(0x39405500),
                                width: 0.996094,
                                style: BorderStyle.solid
                            ),
                          ),
                          child: Text(
                            "Descargar",
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                              color: CustomColors.darkVoltz,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    width: 310.0,
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFE4E9FC),
                    )
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 310.0,
                    height: 425.0,
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Container(
                          width: 310.0,
                          height: 60.0,
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            'Galería del producto',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: CustomColors.darkVoltz,
                            ),
                          ),
                        ),
                        Container(
                          width: 310.0,
                          height: 365.0,
                          color: Colors.red,
                          padding: const EdgeInsets.only(top: 15.0, right: 0.0, bottom: 15.0, left: 0.0),
                          child: Container(
                              width: 310.0,
                              height: 310.0,
                          ),
                        ),

                      ],
                    )
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    width: 310.0,
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFE4E9FC),
                    )
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 310.0,
                  height: 216.0,
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 310.0,
                        height: 60.0,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          child: Text(
                            "Especificaciones",
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Color(0xFF394055),
                            ),
                          ),
                          width: 129.0,
                          height: 16.0,
                        ),
                      ),
                    ],
                  ) ,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 310.0,
                  height: 156.0,
                  padding: const EdgeInsets.only(top: 15.0, right: 0.0, bottom: 15.0, left: 0.0),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  child: SelectableText(
                    viewModel.product.skuDescription!,
                    style: GoogleFonts.inter(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: CustomColors.darkVoltz,
                    ),
                  ),
                  width: 310.0,
                ),
              ],
            ),
          ],
        )
    );
  }

}


