import 'dart:html' as html;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../products/product_viewmodel.dart';
import '../quote/quote_viewmodel.dart';
import '../utils/inputText.dart';
import '../utils/shimmer.dart';
import 'cart_item_viewmodel.dart';
import 'cart_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class CartGrid extends HookViewModelWidget<QuoteViewModel> {
  const CartGrid({Key? key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    var media = MediaQuery.of(context).size;
    return StreamBuilder<List<ProductsSuggested>>(
        stream: viewModel.productsSuggestedStream,
        builder: (BuildContext context, AsyncSnapshot<List<ProductsSuggested>> snapshot) {
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
                height: double.infinity,
                width: media.width > 900 && media.width <= 1300 ? 749 : (media.width > 1300 ? 1136 : 362),
                child: MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    //itemCount: viewModel.updateGrid ?(viewModel.quote.detail!.length > 3 ? 3 : viewModel.quote.detail!.length + 1): viewModel.quote.detail!.length,
                    //viewModel.quote.detail!.length + 1,
                    itemCount: snapshot.data!.length +1,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    itemBuilder: (context, index) {
                      if (index < snapshot.data!.length) {
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
                    }, crossAxisCount: media.width > 900 && media.width <= 1300 ? 2 : (media.width > 1300 ? 3 : 1)
                ),
              ),
            ],
          );
        });
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
    return ViewModelBuilder<CartItemViewModel>.reactive(
        viewModelBuilder: () => CartItemViewModel(),
        onModelReady: (viewModel) => viewModel.initCartView(cartIndex: widget.i),
        fireOnModelReadyOnce: true,
        disposeViewModel: true,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/favicon_tecnolite.png', width: 16, height: 17,),
                                    const SizedBox(width: 5,),
                                    SelectableText(
                                      viewModel.product.brand!,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      viewModel.product.sku!,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      viewModel.currencyFormat.format(viewModel.product.pricePublic!),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Shimmer(
                                      linearGradient: viewModel.shimmerGradientWhiteBackground,
                                      child: ShimmerLoading(
                                        isLoading:
                                        viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals,
                                        shimmerEmptyBox: const ShimmerEmptyBox(
                                          width: 160,
                                          height: 21,
                                        ),
                                        child: Row(
                                          children: [
                                            SelectableText(
                                              viewModel.currencyFormat.format(viewModel.quote.detail![viewModel.cartIndex].productsSuggested![viewModel.suggestedIndex].price!.price2!),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/copa_icon.svg',
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 5,),
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
                if(viewModel.isCardExpanded)...[
                  ProductDetail(productId: viewModel.product.productId!),
                ],
                const _QuantityCalculatorWidget(),
              ],
            ),
        ),
      ]
    );
        });
  }

  Widget getHeader(BuildContext context, CartItemViewModel viewModel){
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
                      child: viewModel.isCardExpanded ? const Icon( Icons.expand_less, size: 24) : const Icon(Icons.expand_more, size: 24),
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
        onModelReady: (viewModel) => viewModel.init(widget.productId),
        fireOnModelReadyOnce: true,
        disposeViewModel: true,
        builder: (context, viewModel, child) {
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
              print('FocusScope: Add has Focus:  ${viewModel.focusAdd.hasFocus}');
              print('FocusScope: Add has Primary Focus:  ${viewModel.focusAdd.hasPrimaryFocus}');
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
                      if(!viewModel.product.isCalculatorActive)...[
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
                              onTapOutside: (value) => viewModel.focusRemove.unfocus(),
                              onTapInside: (value) => viewModel.focusRemove.requestFocus(),
                              child: IconButton(
                                focusNode: viewModel.focusRemove,
                                mouseCursor: SystemMouseCursors.click,
                                style: null,
                                icon: const Icon(Icons.remove, size: 24,),
                                onPressed: () => viewModel.removeOne(),
                              ),
                            )
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.text,
                          child: GestureDetector(
                              onTap: () => viewModel.activateCalculator(),
                              child: Material(
                                elevation: viewModel.isQtyLabelElevated ? 2 : 0,
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
                                            color: CustomColors.darkVoltz
                                        ),
                                      ),
                                      Text(
                                        ' ${viewModel.product.saleUnit}',
                                        style: GoogleFonts.inter(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                            color: CustomColors.darkVoltz
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
                            onTapOutside: (value) => viewModel.focusAdd.unfocus(),
                            onTapInside: (value) => viewModel.focusAdd.requestFocus(),
                            child: IconButton(
                              focusNode: viewModel.focusAdd,
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
                  viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals,
                  shimmerEmptyBox: const ShimmerEmptyBox(
                    width: 180,
                    height: 28,
                  ),
                  child: Row(
                    children: [
                      viewModel.quote.detail![viewModel.cartIndex].isCalculatingProductTotals
                          ? Container()
                          : SelectableText(
                        viewModel.currencyFormat.format(viewModel
                            .quote
                            .detail![viewModel.cartIndex]
                            .productsSuggested![viewModel.suggestedIndex]
                            .total!
                            .afterDiscount ??
                            ''),
                        style: GoogleFonts.inter(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.0,
                          color: CustomColors.darkVoltz,
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
                            viewModel.quote.detail![viewModel.cartIndex]);
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



