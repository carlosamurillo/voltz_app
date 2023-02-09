import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/products/product_viewmodel.dart';
import 'package:maketplace/search/search_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../quote/quote_model.dart';
import '../utils/custom_colors.dart';
import '../utils/shimmer.dart';
import '../utils/style.dart';

class ProductsSearchResult extends StatelessWidget {
  const ProductsSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      viewModelBuilder: () => ProductSearchViewModel(),
      fireOnViewModelReadyOnce: false,
      createNewViewModelOnInsert: true,
      builder: (context, viewModel, child) {
        print('............................................' + media.height.toString());
        if(viewModel.lastQuery == null || viewModel.lastQuery!.isEmpty){
          return const SearchInitialViewWidget();
        }

        if(viewModel.data == null) {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SizedBox(
          width: media.width,
          height: media.width >= CustomStyles.desktopBreak ? media.height - CustomStyles.desktopHeaderHeight : media.height - CustomStyles.mobileHeaderHeight,
          child: CustomScrollView(
            slivers: <Widget> [
              const SliverToBoxAdapter(
                child: SizedBox(height: 25,),
              ),
              if(viewModel.data!.isNotEmpty) ...[
                SliverPadding(
                  padding: media.width >= CustomStyles.mobileBreak ? const EdgeInsets.only(right: 25, left: 25) : const EdgeInsets.only(right: 0, left: 0),
                  sliver: SliverMasonryGrid.count(
                    childCount: viewModel.data!.length,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    itemBuilder: (context, index) {
                      if(index == viewModel.data!.length - 1){
                        return const NoFoundCard();
                      }
                      return ProductCard(
                          product: viewModel.data![index]
                      );
                    }, crossAxisCount: ((media.width - 25) / 387).truncateToDouble().toInt() != 0 ? ((media.width - 25) / 387).truncateToDouble().toInt() : 1,
                  ),
                ),
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: 25,),
              ),
            ],
          ),);
        },
    );
  }
}

class SearchInitialViewWidget extends StatelessWidget {
  const SearchInitialViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/images/assistant_icon.png",
                width: 120,
              ),
              const SizedBox(height: 25),
              const Text(
                "Busca por código, nombre, especificación, y/o marca.",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: CustomColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Ejemplos: SML102022, Cable uso rudo, 16AMP, Tecnolite",
                style: TextStyle(
                  fontSize: 18,
                  color: CustomColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        //disposeViewModel: true,
        //createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
          print('_ProductCard ... Se actualiza la vista ');
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
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          //Esto es temporal mientras se programa en el backend todas las marcas para la bd
                                          if(product.brand != null && product.brand!.toLowerCase() == 'tecnolite')...[
                                            Image.asset('assets/images/favicon_tecnolite.png', width: 16, height: 17,),
                                            const SizedBox(width: 5,),
                                          ],
                                          SelectableText(
                                            product.brand == null ? '' :
                                            product.brand!,
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
                                      const SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SelectableText(
                                            product.sku == null ? '' :
                                            product.sku!,
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
                                            product.pricePublic == null ? '' :
                                            viewModel.currencyFormat.format(product.pricePublic!),
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
                                              product.discountRate == null ? '' :
                                              "${(product.discountRate!).toStringAsFixed(2)}%" ,
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
                      if(product.isCardExpanded)...[
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
                      child: product.isCardExpanded ? const Icon( Icons.expand_less, size: 24) : const Icon(Icons.expand_more, size: 24),
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
                            color: CustomColors.dark,
                          ),
                        ),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => viewModel.openTechFile(viewModel.product.techFile!),
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
                            items: viewModel.product.imageUrls!
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
                              viewModel.product.featuresString!,
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
                            color: CustomColors.dark,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => viewModel.openWebPage(viewModel.product.makerWeb!),
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

class NoFoundCard extends StatelessWidget {
  const NoFoundCard({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.0,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 362.0,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 25),
                const SelectableText(
                  "¿No lo encuentras?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: CustomColors.dark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/assistant_icon.png",
                  width: 62,
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: "Buscaremos rápidamente ",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: CustomColors.blueVoltz,
                      ),
                      children: [
                        TextSpan(
                          text: "el mejor precio y disponibilidad en cientos de proveedores",
                          style: TextStyle(color: CustomColors.dark),
                        ),
                      ]),
                ),
                const SizedBox(height: 15),
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: CustomColors.dark,
                      borderRadius: BorderRadius.all(Radius.circular(200.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(200)),
                        hoverColor: CustomColors.dark.withOpacity(.8),
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          alignment: Alignment.center,
                          child: Text(
                            'Solicitar producto',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: CustomColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*class ProductsSearchResult extends StatelessWidget {
  const ProductsSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
              child: PagedSliverGrid<int, ProductSearch>(
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: ((media.width - 310 - 25) / 387).truncateToDouble().toInt() != 0 ? ((media.width - 310 - 25) / 387).truncateToDouble().toInt() : 1,),
                  pagingController: viewModel.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ProductSearch>(
                      noItemsFoundIndicatorBuilder: (_) => const Center(
                        child: Text('No results found'),
                      ),
                      itemBuilder: (_, item, __) => Container(
                        color: Colors.white,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            SizedBox(width: 50, child: Image.network(item.image)),
                            const SizedBox(width: 20),
                            Expanded(child: Text(item.name))
                          ],
                        ),
                      ))),
            )
          ],)
          ,
        ),
      ),
      viewModelBuilder: () => ProductSearchViewModel(),
    );
  }
}*/