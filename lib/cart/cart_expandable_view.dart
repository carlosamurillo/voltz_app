import 'dart:html' as html;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../products/product_viewmodel.dart';
import '../quote/quote_viewmodel.dart';
import '../utils/inputText.dart';
import '../utils/shimmer.dart';
import 'cart_expandible_viewmodel.dart';
import 'cart_item_viewmodel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({Key? key}) : super(key: key,);
/*
  @override
  Widget builder(
      BuildContext context,
      CardViewModel viewModel,
      ) {
    var media = MediaQuery.of(context).size;
    print('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT');
    return StreamBuilder<ProductsSuggested>(
        stream: viewModel.stream,
        builder: (BuildContext context, AsyncSnapshot<ProductsSuggested> snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }
          html.window.history.pushState(
              null,
              'Voltz - Cotización ${viewModel.quote.consecutive}',
              '?cotz=${viewModel.quote.id!}');
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 25, left: 25),
                height: double.infinity,
                width: ((media.width - 310 - 25) / 387).truncateToDouble() * (387) + 25,
                //width: media.width > 900 && media.width <= 1300 ? 799 : (media.width > 1300 && media.width <= 1800 ? 1186 : media.width > 1800 ? 1573 : 412),
                *//*child: MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    //itemCount: viewModel.updateGrid ?(viewModel.quote.detail!.length > 3 ? 3 : viewModel.quote.detail!.length + 1): viewModel.quote.detail!.length,
                    //viewModel.quote.detail!.length + 1,
                    itemCount: viewModel.countProducts,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    itemBuilder: (context, index) {
                      if (index < viewModel.countProducts) {
                        return ProductCard(
                          i: index, productSuggested: snapshot.data!,
                        );
                      } else if (viewModel.quote.pendingProducts != null && viewModel.quote.pendingProducts!.isNotEmpty) {
                        return const PendingCard();
                      } else {
                        return Container();
                      }
                    },
                  crossAxisCount: ((media.width - 310 - 25) / 387).truncateToDouble().toInt(),
                  //crossAxisCount: media.width > 900 && media.width <= 1300 ? 2 : media.width > 1300 && media.width <= 1800 ? 3 : media.width > 1800 ? 4  : 1,
                ),*//*
                child: CustomScrollView(
                  slivers: [
                    SliverMasonryGrid.extent(
                      maxCrossAxisExtent: 362,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      itemBuilder: (context, index) {
                        if (index < viewModel.productList.length) {
                          return ProductCard(
                            i: index, productSuggested: viewModel.productList.elementAt(index),
                          );
                        } else if (viewModel.quote.pendingProducts != null && viewModel.quote.pendingProducts!.isNotEmpty) {
                          return const PendingCard();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }*/
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GridViewModel>.reactive(
      builder: (context, viewModel, child) {
        if(viewModel.productList.isEmpty) {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        print('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT');
        html.window.history.pushState(
            null,
            'Voltz - Cotización ${viewModel.quote.consecutive}',
            '?cotz=${viewModel.quote.id!}');
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:  MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: const EdgeInsets.only(right: 25, left: 25),
                //height: double.infinity,
                //width: double.infinity,
                child: CustomScrollView(
                  slivers: <Widget> [
                    SilverPadding(
                      padding: const EdgeInsets.only(right: 25, left: 25),
                      silver: SliverMasonryGrid.extent(
                        maxCrossAxisExtent: 362,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 25,
                        itemBuilder: (context, index) {
                          if (index < viewModel.productList.length) {
                            return ProductCard(
                              i: index, productSuggested: viewModel.productList.elementAt(index),
                            );
                          } else if (viewModel.quote.pendingProducts != null && viewModel.quote.pendingProducts!.isNotEmpty) {
                            return const PendingCard();
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
      viewModelBuilder: () => GridViewModel(),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.i, required this.productSuggested
  }) : super(key: key);
  final int i;
  final ProductsSuggested productSuggested;
  @override
  _ProductCard createState() => _ProductCard();
}

class _ProductCard extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CardItemViewModel>.reactive(
        viewModelBuilder: () => CardItemViewModel(),
        onViewModelReady: (viewModel) => viewModel.initCartView(cartIndex: widget.i, productSuggested: widget.productSuggested),
        fireOnViewModelReadyOnce: false,
        disposeViewModel: true,
        createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 362.0,
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
                          if (viewModel.product.coverImage == null) ...[
                            SvgPicture.asset(
                              'assets/svg/no_image.svg',
                              width: 120,
                              height: 120,
                            ),
                          ] else ...[
                            SizedBox(
                                width: 120,
                                height: 120,
                                child: Image.network(
                                  viewModel.product.coverImage!,
                                  height: 120,
                                  width: 120,
                                )),
                          ],
                          const SizedBox(width: 15,),
                          SizedBox(
                            width: 175.0,
                            height: 120.0,
                            child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/favicon_tecnolite.png', width: 16, height: 17,),
                                    const SizedBox(width: 5,),
                                    SelectableText(
                                      viewModel.product.brand!,
                                      maxLines: 1,
                                      style: GoogleFonts.inter(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.0,
                                        color: CustomColors.darkVoltz,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SelectableText(
                                      viewModel.product.sku!,
                                      maxLines: 1,
                                      style: GoogleFonts.inter(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: CustomColors.darkVoltz,
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
                                      viewModel.currencyFormat.format(viewModel.product.pricePublic!),
                                      maxLines: 1,
                                      style: GoogleFonts.inter(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        decoration: TextDecoration.lineThrough,
                                        color: Color(0xFF9C9FAA),
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      color: CustomColors.yellowVoltz,
                                      child: SelectableText(
                                        "${(viewModel.product.discountRate!).toStringAsFixed(2)}%" ,
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
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Shimmer(
                                      linearGradient: viewModel.shimmerGradientWhiteBackground,
                                      child: ShimmerLoading(
                                        isLoading:
                                        viewModel.product.isCalculatingProductTotals,
                                        shimmerEmptyBox: const ShimmerEmptyBox(
                                          width: 160,
                                          height: 21,
                                        ),
                                        child: Row(
                                          children: [
                                            SelectableText(
                                              viewModel.currencyFormat.format(viewModel.product.price!.price2!),
                                              maxLines: 1,
                                              style: GoogleFonts.inter(
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18.0,
                                                color: CustomColors.darkVoltz,
                                                height: 1.1,
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            SelectableText(
                                              viewModel.product.saleUnit!,
                                              maxLines: 1,
                                              style: GoogleFonts.inter(
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                                color: CustomColors.darkVoltz,
                                                height: 1.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/copa_icon.svg',
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 5,),
                                    SelectableText(
                                      "Precio según cantidad",
                                      maxLines: 1,
                                      style: GoogleFonts.inter(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: CustomColors.darkVoltz,
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
                      const SizedBox(height: 25,),
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
                    ],
                  ),
                ),
                if(viewModel.product.techFile!=null) ...[
                  getHeader(context, viewModel),
                ] else ...[
                  const Divider(
                    thickness: 1,
                    color: Color(0xFFD9E0FC),
                  ),
                ],
                if(viewModel.product.isCardExpanded)...[
                  ProductDetail(productId: viewModel.product.productId!),
                ],
                 _QuantityCalculatorWidget(viewModel: viewModel,),
              ],
            ),
        ),
      ]
    );
        });
  }

  Widget getHeader(BuildContext context, CardItemViewModel viewModel){
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          print('dio clic ....');
            viewModel.expandOrCollapseCard();
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 360.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Color(0xFFE4E9FC),
                      width: 1,
                      style: BorderStyle.solid)
                  ),
                ),
                padding: const EdgeInsets.only(top: 20.0, right: 25.0, bottom: 20.0, left: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      child: SvgPicture.asset('assets/svg/info_icon.svg', height: 24, width: 24,),
                    ),
                    const SizedBox(width: 10,),
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
                    ),
                    const Spacer(),
                    Container(
                      child: viewModel.product.isCardExpanded ? const Icon( Icons.expand_less, size: 24) : const Icon(Icons.expand_more, size: 24),
                    ),
                  ],
                )
            ),
          ],
        ),
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
    return ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(widget.productId),
        fireOnViewModelReadyOnce: true,
        disposeViewModel: true,
        createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
    if(viewModel.product.techFile!=null || viewModel.product.imageUrls != null || viewModel.product.features != null ||
    viewModel.product.makerWeb != null) {
      return getExpandedContent(context, viewModel);
    } else {
      return Container(
        width: 362.0,
        padding: const EdgeInsets.all(25.0),
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFF),
        ),
        child: const Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        )
      );
    }
        });
  }


  Widget getExpandedContent(BuildContext context, ProductViewModel viewModel){
    return Container(
      width: 362.0,
        padding: const EdgeInsets.all(25.0),
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFF),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(viewModel.product.techFile!=null) ...[
              Row(
              children: [
                Container(
                    width: 310.0,
                    padding: const EdgeInsets.only(top: 20.0, right: 0.0, bottom: 20.0, left: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text(
                            'Ficha técnica',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: CustomColors.darkVoltz,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => viewModel.openTechFile(viewModel.product.techFile!),
                              child: Container(
                                padding: const EdgeInsets.only(top: 8.0, right: 24.0, bottom: 8.0, left: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(const Radius.circular(200.0)),
                                  border: Border.all(
                                      color: CustomColors.darkVoltz,
                                      width: 1,
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
                            )
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
            ],
            if(viewModel.product.imageUrls != null && viewModel.product.imageUrls!.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                      width: 310.0,
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 310.0,
                                height: 60.0,
                                padding: const EdgeInsets.only(top: 20.0, right: 0.0, bottom: 20.0, left: 0.0),
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
                            ],
                          ),
                          Container(
                            width: 310.0,
                            height: 310,
                            padding: const EdgeInsets.only(top: 15.0, right: 0.0, bottom: 15.0, left: 0.0),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              ),
                              items: viewModel.product.imageUrls!
                                  .map((item) => Container(
                                child: Container(
                                  height: 310,
                                  width: 310,
                                  margin: EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: Stack(
                                        children: <Widget>[
                                          Image.network(item, fit: BoxFit.scaleDown, width: double.infinity),
                                        ],
                                      )),
                                ),
                              ))
                                  .toList(),
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
            ],
            if(viewModel.product.featuresString != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 310.0,
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 310.0,
                              height: 60.0,
                              padding: const EdgeInsets.only(top: 20.0, right: 0.0, bottom: 20.0, left: 0.0),
                              child: Text(
                                'Especificaciones',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: CustomColors.darkVoltz,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 15.0, right: 0.0, bottom: 15.0, left: 0.0),
                              child: SelectableText(
                                viewModel.product.featuresString!,
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
                      ],
                    ) ,
                  ),
                ],
              ),
            ],
            if(viewModel.product.makerWeb != null) ...[
              Row(
                children: [
                  Container(
                      width: 310.0,
                      padding: const EdgeInsets.only(top: 20.0, right: 0.0, bottom: 20.0, left: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Web del fabricante',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: CustomColors.darkVoltz,
                            ),
                          ),
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => viewModel.openWebPage(viewModel.product.makerWeb!),
                                child: Container(
                                  padding: const EdgeInsets.only(top: 8.0, right: 24.0, bottom: 8.0, left: 24.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(const Radius.circular(200.0)),
                                    border: Border.all(
                                        color: CustomColors.darkVoltz,
                                        width: 1,
                                        style: BorderStyle.solid
                                    ),
                                  ),
                                  child: Text(
                                    "Visitar",
                                    style: GoogleFonts.inter(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0,
                                      color: CustomColors.darkVoltz,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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

            ],

          ],
        ),
    );
  }
}


class _QuantityCalculatorWidget extends StatelessWidget{
  final CardItemViewModel viewModel;
  const _QuantityCalculatorWidget({Key? key, required this.viewModel }) : super(key: key,);

  @override
  Widget build(
      BuildContext context
      ) {
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
              print('FocusScope: Add has Focus:  ${viewModel.product.focusAdd.hasFocus}');
              print('FocusScope: Add has Primary Focus:  ${viewModel.product.focusAdd.hasPrimaryFocus}');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 288,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6),),
                    color: Color(0xFFE4E9FC),
                  ),
                  child: Row(
                    children: [
                      if(!viewModel.isCalculatorActive)...[
                        Container(
                            height: 60,
                            width: 50,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),),
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: TextFieldTapRegion(
                              onTapOutside: (value) => viewModel.unFocusRemove(),
                              onTapInside: (value) => viewModel.requestFocusRemove(),
                              child: IconButton(
                                focusNode: viewModel.product.focusRemove,
                                mouseCursor: SystemMouseCursors.click,
                                style: null,
                                icon: const Icon(Icons.remove, size: 24,),
                                onPressed: () => viewModel.removeOne(),
                              ),
                            ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.text,
                          child: GestureDetector(
                              onTap: () => viewModel.activateCalculator(),
                              child: Material(
                                elevation: viewModel.product.isQtyLabelHighlight ? 2 : 0,
                                color: Color(0xFFE4E9FC),
                                child: Container(
                                  height: 60,
                                  width: 188,
                                  color: Colors.transparent,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${viewModel.textEditingController.text}',
                                        style: GoogleFonts.inter(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.0,
                                            color: CustomColors.darkVoltz,
                                          height: 1.2,
                                        ),
                                      ),
                                      Text(
                                        ' ${viewModel.product.saleUnit}',
                                        style: GoogleFonts.inter(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                            color: CustomColors.darkVoltz,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6),
                              bottomRight: Radius.circular(6),),
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: TextFieldTapRegion(
                            onTapOutside: (value) => viewModel.unFocusAdd(),
                            onTapInside: (value) => viewModel.requestFocusAdd(),
                            child: IconButton(
                              focusNode: viewModel.product.focusAdd,
                              mouseCursor: SystemMouseCursors.click,
                              style: null,
                              icon: const Icon(Icons.add, size: 24,),
                              onPressed: () => viewModel.addOne(),
                            ),
                          )
                        ),
                      ] else ... [
                        Container(
                          width: 288,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6),),
                            color: Color(0xFFE4E9FC),
                            border: Border.all(
                              color: CustomColors.darkVoltz, //                   <--- border color
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InputTextV3(
                                  focusNode: viewModel.focusNodeInput,
                                  paddingContent: const EdgeInsets.only(
                                      bottom: 14, top: 19, left: 15),
                                  margin: const EdgeInsets.all(0),
                                  textStyle: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22.0,
                                    color: CustomColors.darkVoltz,
                                  ),
                                  textAlign: TextAlign.start,
                                  controller: viewModel.textEditingController,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      topLeft: Radius.circular(6)),
                                  onTap: () async {
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
                              Container(
                                color: Colors.transparent,
                                width: 150,
                                height: 60,
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                                alignment: Alignment.center,
                                child: viewModel.isQtyControlOpen
                                    ? Container(
                                  width: 141.0,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: CustomColors.darkVoltz,
                                    borderRadius: BorderRadius.all(Radius.circular(200.0)),
                                  ),
                                  child: TextFieldTapRegion(
                                    child: TextButton(
                                      focusNode: viewModel.focusNodeButton,
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                            return Colors.transparent;
                                          },
                                        ),
                                        backgroundColor:
                                        MaterialStateProperty
                                            .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                            return Colors.transparent;
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        print('Se dio clic en Button');
                                        viewModel.onPressCalculate(context);
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Actualizar',
                                            style: GoogleFonts.inter(
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.0,
                                              color: const Color(0xFF9C9FAA),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ) : Container(),
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
              Shimmer(
                linearGradient: viewModel.shimmerGradientWhiteBackground,
                child: ShimmerLoading(
                  isLoading:
                  viewModel.product.isCalculatingProductTotals,
                  shimmerEmptyBox: const ShimmerEmptyBox(
                    width: 180,
                    height: 28,
                  ),
                  child: Row(
                    children: [
                      viewModel.product.isCalculatingProductTotals
                          ? Container()
                          : SelectableText(
                        viewModel.currencyFormat.format(viewModel
                            .product
                            .total!
                            .afterDiscount ??
                            ''),
                        style: GoogleFonts.inter(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.0,
                          color: CustomColors.darkVoltz,
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
                          color: CustomColors.darkVoltz,
                          height: 1.2,
                        ),
                      ),
                    ],
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
                  color: CustomColors.darkVoltz,
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
                      onTap: () async {

                      },
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
                    )
                ),
              ),
              Spacer(),
              SizedBox(
                width: 60,
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        await viewModel.onDeleteSku(
                            viewModel.quote.detail![viewModel.cardIndex]);
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
                    )
                ),
              ),
            ],
          ),
        ]));
  }
}

class PendingCard extends StackedHookView<QuoteViewModel> {
  const PendingCard({Key? key}) : super(key: key, reactive: false);

  @override
  Widget builder(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    var media = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
          color: CustomColors.darkVoltz,
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
                        "${viewModel.quote.pendingProducts!.length} productos en cotización manual",
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
                      child:Text(
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
              color: CustomColors.darkVoltz,
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
                    "${DateFormat.Hms().format(DateTime.parse(viewModel.quote.createdAt!.toDate().toString()))} última actualización",
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
      )
    );
  }
}
