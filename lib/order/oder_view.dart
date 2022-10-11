
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'order_view_mobile.dart';
import 'order_viewmodel.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
        viewModelBuilder: () => OrderViewModel(),
        onModelReady: (viewModel) => viewModel.init(widget.orderId),
        fireOnModelReadyOnce: false,
        disposeViewModel: false,
        builder: (context, viewModel, child) {
          if(viewModel.order == null){
            return const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            html.window.history.pushState(null, 'Voltz - Pedido ${viewModel.order!.consecutive}', '?cotz=${viewModel.order!.id}');
            return Scaffold(
              backgroundColor: CustomColors.backgroundCanvas,
              body: MediaQuery.of(context).size.width >= 480 ? Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            _OrderHeader(total: viewModel.order!.total!,),
                            const Divider(
                              height: 1,
                              color: CustomColors.grayBackground,
                            ),
                            _OrderHeaderId(createdAt: viewModel.order!.createdAt!.toDate(), alias: viewModel.order!.alias!, orderId: viewModel.order!.consecutive!.toString(),),
                            const Divider(
                              height: 1,
                              color: CustomColors.grayBackground,
                            ),
                            const SizedBox(height: 24,),
                            if(viewModel.order!.detail != null) ...[
                              for(int i = 0; i <=
                                  viewModel.order!.detail!.length - 1; i++) ...{
                                _OrerdeTableDetail(i: i,),
                              },
                            ],
                          ],
                        ),
                      ),
                    ),
                    _OrderTotals(tax: viewModel.order!.tax!, total: viewModel.order!.total!,
                      subTotal: viewModel.order!.subTotal!, discount: viewModel.order!.discount!,),
                  ],
                ),
              ) :
              Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    OrderHeaderMobile(total: viewModel.order!.total!, consecutive: viewModel.order!.consecutive.toString(), ),
                    const Divider(
                      height: 1,
                      color: CustomColors.grayBackground,
                    ),
                    OrderTotalsMobile(tax: viewModel.order!.tax!, total: viewModel.order!.total!,
                      subTotal: viewModel.order!.subTotal!, discount: viewModel.order!.discount!,
                      quoteId: viewModel.order!.id!, totalProducts: viewModel.order!.detail!.length,
                    ),
                    const SizedBox(height: 24,),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            if(viewModel.order!.detail != null) ...[
                              for(int i = 0; i <=
                                  viewModel.order!.detail!.length - 1; i++) ...{
                                OrderTableDetailMobile(i: i,),
                              },
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
    );
  }

}


class _OrderHeader extends StatelessWidget {
  _OrderHeader({required this.total,});
  double total;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/voltz_logo.svg',
            width: 122,
            height: 24.5,
          ),
          const Spacer(),
          /*Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(26),),
                  color: Color(0xFFFFFDFB),
                  border: Border.all(width: 2, color: CustomColors.safeBlue)
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                  hoverColor: CustomColors.blueBackground,
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    alignment: Alignment.center,
                    child:  Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/pdf_export_ico.svg',
                          width: 16,
                          height: 20,
                        ),
                        const SizedBox(width: 8,),
                        SelectableText.rich(
                          textAlign: TextAlign.start,
                          text: new TextSpan(
                            children: [
                              new TextSpan(text: 'Exportar PDF',
                                style: TextStyle(
                                  fontFamily: "Hellix",
                                  color: CustomColors.safeBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),*/
          SizedBox(width: 16,),
        ],
      ),
    );
  }
}

class _OrderHeaderId extends StatelessWidget {
  _OrderHeaderId(
      {required this.orderId, required this.alias, required this.createdAt});

  final DateTime createdAt;
  final String orderId;
  final String alias;

  @override
  Widget build(BuildContext context) {
    {
      final f = intl.DateFormat('MMMM dd, yyyy hh:mm', 'es_MX');
      String formattedDate = f.format(createdAt.toLocal());
      return Container(
        padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText.rich(
              TextSpan(
                children: [
                  new TextSpan(text: 'Pedido ',
                    style: TextStyle(
                      fontFamily: "Hellix",
                      color: CustomColors.volcanicBlue,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,),
                  ),
                  new TextSpan(text: "#${orderId}",
                    style: TextStyle(
                      fontFamily: "Hellix",
                      color: CustomColors.volcanicBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24,),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                      color: Color(0xFFF9FAFF),
                      border: Border.all(width: 1, color: Color(0xFFE5E7EB))
                  ),
                  child: SelectableText.rich(
                    TextSpan(
                      children: [
                        /*new TextSpan(text: 'CLIENTE: ',
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,),
                      ),*/
                        new TextSpan(text: alias,
                          style: TextStyle(
                            fontFamily: "Hellix",
                            color: CustomColors.volcanicBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 40,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                      color: Color(0xFFF9FAFF),
                      border: Border.all(width: 1, color: Color(0xFFE5E7EB))
                  ),
                  child: SelectableText.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'FECHA: ',
                          style: TextStyle(
                            fontFamily: "Hellix",
                            color: CustomColors.volcanicBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,),
                        ),
                        TextSpan(text: formattedDate,
                          style: const TextStyle(
                            fontFamily: "Hellix",
                            color: CustomColors.volcanicBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      );
    }
  }
}

class _OrderTotals extends StatefulWidget {
  _OrderTotals({Key? key, required this.tax, required this.total, required this.subTotal,
    required this.discount,}) : super(key: key, );
  final double tax;
  final double total;
  final double subTotal;
  final double discount;

  @override
  _OrderTotalsState createState() => _OrderTotalsState();
}

class _OrderTotalsState extends State<_OrderTotals> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
        color: CustomColors.volcanicBlue,
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    SelectableText(
                      "Subtotal único",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    SelectableText(
                      currencyFormat.format(widget.subTotal),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
               /* const SizedBox(height: 8,),
                Row(
                  children: [
                    SelectableText(
                      "Descuento",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    SelectableText(
                      currencyFormat.format(widget.discount),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),*/
                const SizedBox(height: 8,),
                Row(
                  children: [
                    SelectableText(
                      "IVA",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    SelectableText(
                      currencyFormat.format(widget.tax * widget.subTotal),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    SelectableText(
                      "Total",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    SelectableText(
                      currencyFormat.format(widget.total),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }


}


class _OrerdeTableDetail extends StatefulWidget {
  _OrerdeTableDetail({Key? key, required this.i,}) : super(key: key);
  int i;

  @override
  _OrerdeTableDetailState createState() => _OrerdeTableDetailState();
}

class _OrerdeTableDetailState extends State<_OrerdeTableDetail> {
  late OrderViewModel model;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.i);
    model = context.read<OrderViewModel>();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.only(left: 60, right: 60, top: 16, bottom: 16 ),
        child:  Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
                  color: CustomColors.safeBlue,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: CustomColors.energyYellow,
                      ),
                      alignment: Alignment.center,
                      width: 56,
                      child: SelectableText(
                        (widget.i + 1).toString(),
                        style: CustomStyles.styleBlueUno,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: SelectableText( model.order!.detail![widget.i].productRequested!.toUpperCase(),
                        style: CustomStyles.styleWhiteUno,
                      ),
                    ),
                    const Spacer(),

                  ],
                ),
              ),
              for(int b = 0; b <= model.order!.detail![widget.i].productsOrdered!.length -1; b++) ...{
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: b == model.order!.detail![widget.i].productsOrdered!.length -1 ? BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)) : null,
                    color: CustomColors.blueBackground,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 24,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            if(1==1) ...{
                              SvgPicture.asset(
                                'assets/svg/no_image_ico.svg',
                                width: 56,
                                height: 56,
                              ),
                            },
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ) ,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              model.order!.detail![widget.i].productsOrdered![b].sku!,
                              style: CustomStyles.styleVolcanicBlueUno,
                              textAlign: TextAlign.left,
                            ),
                            SelectableText(
                              model.order!.detail![widget.i].productsOrdered![b].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                              style: CustomStyles.styleVolcanicUno,
                              textAlign: TextAlign.left,
                              //overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 524,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: 159,
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:  [
                                        SelectableText( model.order!.detail![widget.i].productsOrdered![b].brand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                          style: CustomStyles.styleVolcanicBlueDos,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                        if (model.order!.detail![widget.i].productsOrdered![b].subBrand != null ) ...[
                                          SelectableText(  model.order!.detail![widget.i].productsOrdered![b].subBrand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                            style: CustomStyles.styleVolcanicBlueDos,
                                            textAlign: TextAlign.left,
                                            //overflow: TextOverflow.clip,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              width: 158,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SelectableText(
                                    '${model.order!.detail![widget.i].productsOrdered![b].quantity} ',
                                    style: CustomStyles.styleVolcanicBlueDos,
                                    textAlign: TextAlign.left,
                                  ),
                                  SelectableText(
                                    model.order!.detail![widget.i].productsOrdered![b].saleUnit!,
                                    style: CustomStyles.styleVolcanicBlueDos,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(24),
                              width: 177,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SelectableText(
                                          (currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].salePrice! * model.order!.detail![widget.i].productsOrdered![b].quantity!)),
                                          style: CustomStyles.styleVolcanicBlueTres,
                                          textAlign: TextAlign.right,
                                        ),
                                        SelectableText(
                                          "${currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].salePrice!)} c/u",
                                          style: CustomStyles.styleVolcanicUno,
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              }
            ],
          ),
        )
    );
  }

}


