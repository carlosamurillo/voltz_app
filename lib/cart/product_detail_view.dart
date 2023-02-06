import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/products/product_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import '../utils/custom_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key, required this.productId,}) : super(key: key);
  final String productId;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(widget.productId),
        builder: (context, viewModel, child) {
          print("se imprime pantalla");
          if(viewModel.product.id != null){
            return Container(
              width: double.infinity,
              height: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 780.0,
                maxWidth: 780.0,
              ),
              color: Colors.white,
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: CustomColors.volcanicBlue,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 40, top: 37.5, bottom: 37.5),
                    child: SelectableText(
                      "Detalles del producto",
                      style: CustomStyles.styleWhite24x700,
                      textAlign: TextAlign.left,
                      //overflow: TextOverflow.clip,
                    ),
                  ),
                  Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.all(30),
                      child: Column (
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 250,
                            width: double.infinity,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (viewModel.product.imageUrls != null) ...[
                                    Container(
                                        width: 250,
                                        height: 250,
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            autoPlay: true,
                                            aspectRatio: 2.0,
                                            enlargeCenterPage: true,
                                          ),
                                          items: viewModel.product.imageUrls!
                                              .map((item) => Container(
                                            child: Container(
                                              margin: EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Image.network(item, fit: BoxFit.cover, width: double.infinity),
                                                      /*Positioned(
                                                        bottom: 0.0,
                                                        left: 0.0,
                                                        right: 0.0,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                Color.fromARGB(200, 0, 0, 0),
                                                                Color.fromARGB(0, 0, 0, 0)
                                                              ],
                                                              begin: Alignment.bottomCenter,
                                                              end: Alignment.topCenter,
                                                            ),
                                                          ),
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 10.0, horizontal: 20.0),
                                                          child: Text(
                                                            'No. ${viewModel.product.imageUrls!.indexOf(item)} image',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),*/
                                                    ],
                                                  )),
                                            ),
                                          ))
                                              .toList(),
                                        ),
                                    ),
                                  ] else if (viewModel.product.coverImage != null) ...[
                                      Image.network(
                                        viewModel.product.coverImage!,
                                      width: 250,
                                      height: 250,
                                    ),
                                  ]
                                  else ...[
                                      SvgPicture.asset(
                                      'assets/svg/no_image.svg',
                                      width: 250,
                                      height: 250,
                                    ),
                                  ],
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 30),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              if(viewModel.product.warranty != null)...[
                                                SvgPicture.asset(
                                                  'assets/svg/security_icon.svg',
                                                  width: 24.0,
                                                  height: 24.0,
                                                ),
                                                SizedBox(width: 10,),
                                                Flexible(
                                                  child: SelectableText(
                                                    "${viewModel.product.warranty} de garantia",
                                                    style: CustomStyles.styleVolcanic16600,
                                                    textAlign: TextAlign.left,
                                                    //overflow: TextOverflow.clip,
                                                  ),
                                                )
                                              ],
                                            ],
                                          ),
                                        ),
                                        SelectableText(
                                          viewModel.product.skuDescription!,
                                          style: CustomStyles.styleVolcanicBlue12600,
                                          textAlign: TextAlign.left,
                                        ),
                                        const Spacer(),
                                        Row(
                                            children: [
                                              /*SelectableText(
                                        viewModel.currencyFormat.format(viewModel.product.price!.price1!),
                                        style: CustomStyles.styleVolcanic16600,
                                        textAlign: TextAlign.left,
                                        //overflow: TextOverflow.clip,
                                      ),*/
                                              if(viewModel.product.price != null && viewModel.product.price!.price2 != null) ...[
                                                SelectableText(
                                                  viewModel.currencyFormat.format(viewModel.product.price!.price2!),
                                                  style: CustomStyles.styleSafeBlue22600,
                                                  textAlign: TextAlign.left,
                                                  //overflow: TextOverflow.clip,
                                                ),
                                              ],
                                              if(viewModel.product.pricePublic != null) ...[
                                                SelectableText(
                                                  viewModel.currencyFormat.format(viewModel.product.pricePublic!),
                                                  style: CustomStyles.styleVolcanic14300WithLineThrough,
                                                  textAlign: TextAlign.left,
                                                  //overflow: TextOverflow.clip,
                                                ),
                                              ]
                                            ]
                                        ),
                                        SelectableText(
                                          "El precio más bajo encontrado",
                                          style: CustomStyles.styleVolcanic14300,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  )
                                ]
                            ),
                          ),
                          SizedBox(height: 40,),
                          //Aqui viene la tabla
                          SizedBox(height: 40,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children : [
                                if(viewModel.product.brand != null) ...[
                                  SvgPicture.asset(
                                    'assets/svg/local_offer.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12,),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SelectableText(
                                          "Marca/fabricante",
                                          style: CustomStyles.styleVolcanic14400,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                        SelectableText(
                                          viewModel.product.brand!,
                                          style: CustomStyles.styleVolcanic16600,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                      ]
                                  ),
                                ],
                                /*Spacer(),
                                SelectableText(
                                  "Visita la tienda Tecnolite",
                                  style: CustomStyles.styleSafeBlue14600Underline,
                                  textAlign: TextAlign.left,
                                  //overflow: TextOverflow.clip,
                                ),*/
                              ]
                          ),
                          const SizedBox(height: 20,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children : [
                                SvgPicture.asset(
                                  'assets/svg/fiber_new.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12,),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SelectableText(
                                        "Código del fabricante (SKU)",
                                        style: CustomStyles.styleVolcanic14400,
                                        textAlign: TextAlign.left,
                                        //overflow: TextOverflow.clip,
                                      ),
                                      SelectableText(
                                        viewModel.product.sku!,
                                        style: CustomStyles.styleVolcanic16600,
                                        textAlign: TextAlign.left,
                                        //overflow: TextOverflow.clip,
                                      ),
                                    ]
                                ),
                              ]
                          ),
                          if(viewModel.product.features != null)...[
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children : [
                                SvgPicture.asset(
                                  'assets/svg/label_important.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 12,),
                                Flexible(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SelectableText(
                                          "Especificaciones",
                                          style: CustomStyles.styleVolcanic14400,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                        SelectableText(
                                          viewModel.product.featuresString!,
                                          style: CustomStyles.styleVolcanic16600,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                      ]
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      )
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(6),),
                          color: viewModel.product.techFile != null ?  CustomColors.safeBlue : CustomColors.muggleGray_5,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            hoverColor: CustomColors.safeBlueHover,
                            onTap: viewModel.product.techFile != null ? () async {
                              return viewModel.openTechFile(viewModel.product.techFile!);
                            } : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              alignment: Alignment.center,
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/cloud_download.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(viewModel.product.techFile != null ? 'Descargar ficha técnica' : 'Ficha técnica no disponible', textAlign: TextAlign.center , style: CustomStyles.styleWhite16x600,),
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 40,),
                ],
              ),
            );
          } else {
            return Container(color: Colors.black);
          }
      });
  }

}



class ProductViewMobile extends StatefulWidget {
  const ProductViewMobile({Key? key, required this.productId,}) : super(key: key);
  final String productId;

  @override
  _ProductViewMobileState createState() => _ProductViewMobileState();
}

class _ProductViewMobileState extends State<ProductViewMobile> {

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(widget.productId),
        builder: (context, viewModel, child) {
          print("se imprime pantalla");
          if(viewModel.product.id != null){
            return Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: CustomColors.volcanicBlue,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 30),
                      child: Row(
                          children: [
                            SelectableText(
                            "Detalles",
                            style: CustomStyles.styleWhite22x700,
                            textAlign: TextAlign.left,
                            //overflow: TextOverflow.clip,
                            ),
                            const Spacer(),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.navigateBack();
                                },
                                child: Container(
                                  color: CustomColors.volcanicBlue,
                                  child: SvgPicture.asset(
                                    'assets/svg/close_icon.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ]
                      )
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: Column (
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (viewModel.product.imageUrls != null) ...[
                                  Container(
                                    width: double.infinity,
                                    height: 290,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        aspectRatio: 2.0,
                                        enlargeCenterPage: true,
                                      ),
                                      items: viewModel.product.imageUrls!
                                          .map((item) => Container(
                                        child: Container(
                                          margin: EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              child: Stack(
                                                children: <Widget>[
                                                  Image.network(item, fit: BoxFit.fitHeight, width: double.infinity),
                                                  /*Positioned(
                                                        bottom: 0.0,
                                                        left: 0.0,
                                                        right: 0.0,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                Color.fromARGB(200, 0, 0, 0),
                                                                Color.fromARGB(0, 0, 0, 0)
                                                              ],
                                                              begin: Alignment.bottomCenter,
                                                              end: Alignment.topCenter,
                                                            ),
                                                          ),
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 10.0, horizontal: 20.0),
                                                          child: Text(
                                                            'No. ${viewModel.product.imageUrls!.indexOf(item)} image',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),*/
                                                ],
                                              )),
                                        ),
                                      ))
                                          .toList(),
                                    ),
                                  ),
                                ] else if (viewModel.product.coverImage != null) ...[
                                  Image.network(
                                    viewModel.product.coverImage!,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ]
                                else ...[
                                    SvgPicture.asset(
                                      'assets/svg/no_image.svg',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ],
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if(viewModel.product.warranty != null)...[
                                        SvgPicture.asset(
                                          'assets/svg/security_icon.svg',
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                        SizedBox(width: 10,),
                                        Flexible(
                                          child: SelectableText(
                                            "${viewModel.product.warranty} de garantia",
                                            style: CustomStyles.styleVolcanic16600,
                                            textAlign: TextAlign.left,
                                            //overflow: TextOverflow.clip,
                                          ),
                                        )
                                      ],
                                    ],
                                  ),
                                ),
                                SelectableText(
                                  viewModel.product.skuDescription!,
                                  style: CustomStyles.styleVolcanicBlue18x600,
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 20,),
                                Row(
                                    children: [
                                      /*SelectableText(
                                        viewModel.currencyFormat.format(viewModel.product.price!.price1!),
                                        style: CustomStyles.styleVolcanic16600,
                                        textAlign: TextAlign.left,
                                        //overflow: TextOverflow.clip,
                                      ),*/
                                      if(viewModel.product.price != null && viewModel.product.price!.price2 != 0) ...[
                                        SelectableText(
                                          viewModel.currencyFormat.format(viewModel.product.price!.price2!),
                                          style: CustomStyles.styleSafeBlue22600,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                      ],
                                      if(viewModel.product.pricePublic != null) ...[
                                        SelectableText(
                                          viewModel.currencyFormat.format(viewModel.product.pricePublic!),
                                          style: CustomStyles.styleVolcanic14300WithLineThrough,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                      ]
                                    ]
                                ),
                                Text(
                                  "El precio más bajo encontrado",
                                  style: CustomStyles.styleVolcanic14300,
                                  textAlign: TextAlign.left,
                                  //overflow: TextOverflow.clip,
                                ),
                                SizedBox(height: 40,),
                                //Aqui viene la tabla
                                SizedBox(height: 40,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children : [
                                      if(viewModel.product.brand != null) ...[
                                        SvgPicture.asset(
                                          'assets/svg/local_offer.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 12,),
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SelectableText(
                                                "Marca/fabricante",
                                                style: CustomStyles.styleVolcanic14400,
                                                textAlign: TextAlign.left,
                                                //overflow: TextOverflow.clip,
                                              ),
                                              SelectableText(
                                                viewModel.product.brand!,
                                                style: CustomStyles.styleVolcanic16600,
                                                textAlign: TextAlign.left,
                                                //overflow: TextOverflow.clip,
                                              ),
                                            ]
                                        ),
                                      ],
                                      /*Spacer(),
                                SelectableText(
                                  "Visita la tienda Tecnolite",
                                  style: CustomStyles.styleSafeBlue14600Underline,
                                  textAlign: TextAlign.left,
                                  //overflow: TextOverflow.clip,
                                ),*/
                                    ]
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children : [
                                      SvgPicture.asset(
                                        'assets/svg/fiber_new.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 12,),
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SelectableText(
                                              "Código del fabricante (SKU)",
                                              style: CustomStyles.styleVolcanic14400,
                                              textAlign: TextAlign.left,
                                              //overflow: TextOverflow.clip,
                                            ),
                                            SelectableText(
                                              viewModel.product.sku!,
                                              style: CustomStyles.styleVolcanic16600,
                                              textAlign: TextAlign.left,
                                              //overflow: TextOverflow.clip,
                                            ),
                                          ]
                                      ),
                                    ]
                                ),
                                if(viewModel.product.features != null)...[
                                  const SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children : [
                                      SvgPicture.asset(
                                        'assets/svg/label_important.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 12,),
                                      Flexible(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SelectableText(
                                                "Especificaciones",
                                                style: CustomStyles.styleVolcanic14400,
                                                textAlign: TextAlign.left,
                                                //overflow: TextOverflow.clip,
                                              ),
                                              SelectableText(
                                                viewModel.product.featuresString!,
                                                style: CustomStyles.styleVolcanic16600,
                                                textAlign: TextAlign.left,
                                                //overflow: TextOverflow.clip,
                                              ),
                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6),),
                            color: viewModel.product.techFile != null ?  CustomColors.safeBlue : CustomColors.muggleGray_5,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              hoverColor: CustomColors.safeBlueHover,
                              onTap: viewModel.product.techFile != null ? () async {
                                return viewModel.openTechFile(viewModel.product.techFile!);
                              } : null,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                alignment: Alignment.center,
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/cloud_download.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 10,),
                                    Text(viewModel.product.techFile != null ? 'Descargar ficha técnica' : 'Ficha técnica no disponible', textAlign: TextAlign.center , style: CustomStyles.styleWhite16x600,),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          } else {
            return Container(color: Colors.black);
          }
        });
  }

}