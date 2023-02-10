import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/product/product_viewmodel.dart';
import 'package:maketplace/search/search_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../quote/quote_model.dart';
import '../../utils/custom_colors.dart';
import '../../utils/shimmer.dart';
import '../../utils/style.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key, required this.product,
  }) : super(key: key);
  final ProductSuggested product;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductCardViewModel>.reactive(
        viewModelBuilder: () => ProductCardViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(product),
        fireOnViewModelReadyOnce: false,
        disposeViewModel: true,
        createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
          if (kDebugMode) {
            print('ProductCard ... Se actualiza la vista ');
            print('ProductCard ... getHeader ... ProductCardViewModel ... isCardExpanded = ${viewModel.isCardExpanded}');
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 362.0,
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    border: Border.all(
                        color: const Color(0xFFD9E0FC),
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
                                if (product.coverImage == null) ...[
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
                                        product.coverImage!,
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //Esto es temporal mientras se programa en el backend todas las marcas para la bd
                                          if(product.brand != null && product.brand!.toLowerCase() == 'tecnolite')...[
                                            Image.asset('assets/images/favicon_tecnolite.png', width: 16, height: 17,),
                                            const SizedBox(width: 5,),
                                          ],
                                          SizedBox(
                                            width: product.brand!.toLowerCase() == 'tecnolite' ? 154 : 175,
                                            child: Tooltip(
                                              message: product.brand?? '',
                                              child: Text(
                                                product.brand?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  textStyle: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.0,
                                                    color: CustomColors.dark,
                                                    height: 1.1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 154,
                                            child: Tooltip(
                                              message: product.sku?? '',
                                              child: Text(
                                                product.sku?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  textStyle: const TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0,
                                                    color: CustomColors.dark,
                                                    height: 1.1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
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
                                            product.pricePublic != null ?
                                            viewModel.currencyFormat.format(product.pricePublic!) : '',
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
                                          const SizedBox(width: 5,),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            color: CustomColors.yellowVoltz,
                                            child: SelectableText(
                                              product.discountRate != null ?
                                              "${(product.discountRate!).toStringAsFixed(2)}%" : '' ,
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
                                              product.isCalculatingProductTotals,
                                              shimmerEmptyBox: const ShimmerEmptyBox(
                                                width: 160,
                                                height: 21,
                                              ),
                                              child: Row(
                                                children: [
                                                  SelectableText(
                                                    product.price == null ? '' :
                                                    viewModel.currencyFormat.format(product.price!.price2!),
                                                    maxLines: 1,
                                                    style: GoogleFonts.inter(
                                                      fontStyle: FontStyle.normal,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18.0,
                                                      color: CustomColors.dark,
                                                      height: 1.1,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  SelectableText(
                                                    product.saleUnit == null ? '' :
                                                    product.saleUnit!,
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
                            const SizedBox(height: 25,),
                            SelectableText(product.skuDescription == null ? '' : product.skuDescription!
                                .replaceAll("<em>", "")
                                .replaceAll("<\/em>", ""),
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
                      if(product.techFile!=null) ...[
                        getHeader(context, viewModel),
                      ] else ...[
                        const Divider(
                          thickness: 1,
                          color: Color(0xFFD9E0FC),
                        ),
                      ],
                      if(viewModel.isCardExpanded)...[
                        ProductDetail(productId: product.productId!),
                      ],
                    ],
                  ),
                ),
              ]
          );
        });
  }

  Widget getHeader(BuildContext context, ProductCardViewModel viewModel){
    var media = MediaQuery.of(context).size;
    if (kDebugMode) {
      print('ProductCard ... getHeader ... ProductCardViewModel ... isCardExpanded = ${viewModel.isCardExpanded}');
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => viewModel.expandOrCollapseCard(),
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
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: SvgPicture.asset('assets/svg/info_icon.svg', height: 24, width: 24,),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 167.0,
                      child: Text(
                        media.width >= CustomStyles.desktopBreak ? 'Detalles del producto' : "Detalles",
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

class ProductDetail extends StatelessWidget {
  const ProductDetail({
    Key? key,
    required this.productId,
  }) : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(productId),
        fireOnViewModelReadyOnce: true,
        disposeViewModel: true,
        createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
          if (kDebugMode) {
            print("ProductDetail ... Se actualiza la vista ...");
          }
          if(viewModel.product != null && (viewModel.product!.techFile!=null || viewModel.product!.imageUrls != null || viewModel.product!.features != null ||
              viewModel.product!.makerWeb != null)) {
            return _ProductDetailWidget(product: viewModel.product!, openTechFile: viewModel.openTechFile, openWebPage: viewModel.openWebPage,);
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

}


class _ProductDetailWidget extends StatelessWidget {
  const _ProductDetailWidget({
    Key? key,
    required this.product,
    required this.openTechFile,
    required this.openWebPage,
  }) : super(key: key);
  final Product product;
  final void Function (String url) openTechFile;
  final void Function (String url) openWebPage;

  @override
  Widget build(BuildContext context) {
    return
    Container(
      width: 362.0,
      padding: const EdgeInsets.all(25.0),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFF),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(product.techFile!=null) ...[
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
                            color: CustomColors.dark,
                          ),
                        ),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => openTechFile(product.techFile!),
                              child: Container(
                                padding: const EdgeInsets.only(top: 8.0, right: 24.0, bottom: 8.0, left: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(200.0)),
                                  border: Border.all(
                                      color: CustomColors.dark,
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
                                    color: CustomColors.dark,
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4E9FC),
                    )
                ),
              ],
            ),
          ],
          if(product.imageUrls != null && product.imageUrls!.isNotEmpty) ...[
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
                                  color: CustomColors.dark,
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
                            items: product.imageUrls!
                                .map((item) => Container(
                              child: Container(
                                height: 310,
                                width: 310,
                                margin: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4E9FC),
                    )
                ),
              ],
            ),
          ],
          if(product.featuresString != null) ...[
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
                                color: CustomColors.dark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 15.0, right: 0.0, bottom: 15.0, left: 0.0),
                            width: 310.0,
                            child: SelectableText(
                              product.featuresString!,
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: CustomColors.dark,
                              ),
                            ),
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
          if(product.makerWeb != null) ...[
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
                            color: CustomColors.dark,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => openWebPage(product.makerWeb!),
                            child: Container(
                              padding: const EdgeInsets.only(top: 8.0, right: 24.0, bottom: 8.0, left: 24.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(200.0)),
                                border: Border.all(
                                    color: CustomColors.dark,
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
                                  color: CustomColors.dark,
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
                    decoration: const BoxDecoration(
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