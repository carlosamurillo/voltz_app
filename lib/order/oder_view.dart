import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/order/order_view_mobile.dart';
import 'package:maketplace/order/order_viewmodel.dart';
import 'package:maketplace/payment/payment_view.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  ScrollController _scrollController = ScrollController();

  bool showPaymentView = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
        viewModelBuilder: () => OrderViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(widget.orderId),
        fireOnViewModelReadyOnce: false,
        disposeViewModel: false,
        builder: (context, viewModel, child) {
          if (viewModel.order == null) {
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
              backgroundColor: AppKeys().customColors!.backgroundCanvas,
              body: MediaQuery.of(context).size.width >= 480
                  ? Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (showPaymentView) ...[
                            _OrderHeader(
                              total: viewModel.order!.totals!.total!,
                            ),
                            Expanded(
                              child: PaymentInstructions(
                                total: viewModel.order!.totals!.total!,
                                order_consecutive: viewModel.order!.consecutive!.toString(),
                                showOrderListener: showOrder,
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    _OrderHeader(
                                      total: viewModel.order!.totals!.total!,
                                    ),
                                    Divider(
                                      height: 1,
                                      color: AppKeys().customColors!.grayBackground,
                                    ),
                                    _OrderHeaderId(
                                        createdAt: viewModel.order!.createdAt!.toDate(),
                                        alias: viewModel.order!.alias!,
                                        orderId: viewModel.order!.consecutive!.toString(),
                                        showOrder: showOrder),
                                    Divider(
                                      height: 1,
                                      color: AppKeys().customColors!.grayBackground,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    if (viewModel.order!.detail != null) ...[
                                      for (int i = 0; i <= viewModel.order!.detail!.length - 1; i++) ...{
                                        _OrerdeTableDetail(
                                          i: i,
                                        ),
                                      },
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            _OrderTotals(
                              tax: viewModel.order!.totals!.tax!,
                              total: viewModel.order!.totals!.total!,
                              subTotal: viewModel.order!.totals!.subTotal!,
                              shippingTotal: (viewModel.order!.shipping != null ? viewModel.order!.shipping!.total! : null),
                            ),
                          ],
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          if (showPaymentView) ...[
                            OrderHeaderMobile(
                              total: viewModel.order!.totals!.total!,
                              consecutive: viewModel.order!.consecutive.toString(),
                            ),
                            Expanded(
                              child: PaymentInstructionsMobile(
                                total: viewModel.order!.totals!.total!,
                                order_consecutive: viewModel.order!.consecutive!.toString(),
                                showOrderListener: showOrder,
                              ),
                            ),
                          ] else ...[
                            OrderHeaderMobile(
                              total: viewModel.order!.totals!.total!,
                              consecutive: viewModel.order!.consecutive.toString(),
                            ),
                            Divider(
                              height: 1,
                              color: AppKeys().customColors!.grayBackground,
                            ),
                            OrderTotalsMobile(
                              tax: viewModel.order!.totals!.tax!,
                              total: viewModel.order!.totals!.total!,
                              subTotal: viewModel.order!.totals!.subTotal!,
                              shippingTotal: viewModel.order!.shipping == null ? null : viewModel.order!.shipping!.total,
                              quoteId: viewModel.order!.id!,
                              totalProducts: viewModel.order!.detail!.length,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    if (viewModel.order!.detail != null) ...[
                                      for (int i = 0; i <= viewModel.order!.detail!.length - 1; i++) ...{
                                        OrderTableDetailMobile(
                                          i: i,
                                        ),
                                      },
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            _GoToPayment(
                              listenerShowOrder: showOrder,
                            )
                          ],
                        ],
                      ),
                    ),
            );
          }
        });
  }

  showOrder() {
    setState(() {
      showPaymentView = !showPaymentView;
    });
  }
}

class _GoToPayment extends StatefulWidget {
  _GoToPayment({
    Key? key,
    required this.listenerShowOrder,
  }) : super(
          key: key,
        );
  VoidCallback listenerShowOrder;
  @override
  _GoToPaymentSate createState() => _GoToPaymentSate();
}

class _GoToPaymentSate extends State<_GoToPayment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(26),
            ),
            color: AppKeys().customColors!.energyColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(26)),
              hoverColor: AppKeys().customColors!.energyColorHover,
              onTap: () {
                setState(() {
                  widget.listenerShowOrder();
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Ir a pago',
                      style: CustomStyles.styleVolcanicBlueDos.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  _OrderHeader({
    required this.total,
  });
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
            AppKeys().logo!,
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
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}

class _OrderHeaderId extends StatelessWidget {
  _OrderHeaderId({required this.orderId, required this.alias, required this.createdAt, required this.showOrder});

  final DateTime createdAt;
  final String orderId;
  final String alias;
  final VoidCallback showOrder;

  final Color _buttonColor = AppKeys().customColors!.safeBlue;
  final Color _buttonHoverColor = AppKeys().customColors!.safeBlueHover;

  @override
  Widget build(BuildContext context) {
    {
      final f = intl.DateFormat('MMMM dd, yyyy hh:mm', 'es_MX');
      String formattedDate = f.format(createdAt.toLocal());
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 64),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Pedido ',
                    style: TextStyle(
                      fontFamily: "Hellix",
                      color: AppKeys().customColors!.volcanicBlue,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "#$orderId",
                    style: TextStyle(
                      fontFamily: "Hellix",
                      color: AppKeys().customColors!.volcanicBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: const Color(0xFFF9FAFF),
                      border: Border.all(width: 1, color: const Color(0xFFE5E7EB))),
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
                        TextSpan(
                          text: alias,
                          style: TextStyle(
                            fontFamily: "Hellix",
                            color: AppKeys().customColors!.volcanicBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: const Color(0xFFF9FAFF),
                      border: Border.all(width: 1, color: const Color(0xFFE5E7EB))),
                  child: SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'FECHA: ',
                          style: TextStyle(
                            fontFamily: "Hellix",
                            color: AppKeys().customColors!.volcanicBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: formattedDate,
                          style: TextStyle(
                            fontFamily: "Hellix",
                            color: AppKeys().customColors!.volcanicBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Spacer(),
                Container(
                    width: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(26),
                      ),
                      color: _buttonColor,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(26)),
                        hoverColor: _buttonHoverColor,
                        onTap: () {
                          showOrder();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Ir a pago',
                                style: CustomStyles.styleWhiteDos,
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      );
    }
  }
}

class _OrderTotals extends StatefulWidget {
  _OrderTotals({
    Key? key,
    required this.tax,
    required this.total,
    required this.subTotal,
    required this.shippingTotal,
  }) : super(
          key: key,
        );
  final double tax;
  final double total;
  final double subTotal;
  final double? shippingTotal;

  @override
  _OrderTotalsState createState() => _OrderTotalsState();
}

class _OrderTotalsState extends State<_OrderTotals> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: AppKeys().customColors!.volcanicBlue,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      SelectableText(
                        "Subtotal único",
                        style: CustomStyles.styleWhiteUno,
                      ),
                      const Spacer(),
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
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SelectableText(
                        "IVA",
                        style: CustomStyles.styleWhiteUno,
                      ),
                      const Spacer(),
                      SelectableText(
                        currencyFormat.format(widget.tax * widget.subTotal),
                        style: CustomStyles.styleWhiteUno,
                      ),
                    ],
                  ),
                  if (widget.shippingTotal != null) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SelectableText(
                          "Costo de envío",
                          style: CustomStyles.styleWhiteUno,
                        ),
                        const Spacer(),
                        SelectableText(
                          currencyFormat.format(widget.shippingTotal),
                          style: CustomStyles.styleWhiteUno,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SelectableText(
                        "Total",
                        style: CustomStyles.styleWhiteUno,
                      ),
                      const Spacer(),
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
  _OrerdeTableDetail({
    Key? key,
    required this.i,
  }) : super(key: key);
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
    print('esta es la orden ... ');
    print(model.order!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 60, right: 60, top: 16, bottom: 16),
        child: Card(
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
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  color: AppKeys().customColors!.safeBlue,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: AppKeys().customColors!.energyColor,
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
                      child: SelectableText(
                        model.order!.detail![widget.i].productRequested!.toUpperCase(),
                        style: CustomStyles.styleWhiteUno,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              for (int b = 0; b <= model.order!.detail![widget.i].productsOrdered!.length - 1; b++) ...{
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: b == model.order!.detail![widget.i].productsOrdered!.length - 1
                        ? const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                        : null,
                    color: AppKeys().customColors!.blueBackground,
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
                            if (1 == 1) ...{
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
                        ),
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
                                      children: [
                                        SelectableText(
                                          model.order!.detail![widget.i].productsOrdered![b].brand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                          style: CustomStyles.styleVolcanicBlueDos,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
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
                                    model.order!.detail![widget.i].productsOrdered![b].saleUnit ?? '',
                                    style: CustomStyles.styleVolcanicBlueDos,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(24),
                              width: 177,
                              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SelectableText(
                                      (currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].total!.afterDiscount!)),
                                      style: CustomStyles.styleVolcanicBlueTres,
                                      textAlign: TextAlign.right,
                                    ),
                                    SelectableText(
                                      "${currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].price!.price2!)} c/u",
                                      style: CustomStyles.styleVolcanicUno,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ]),
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
        ));
  }
}
