import 'dart:html' as html;

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:maketplace/keys_model.dart';
// import 'package:maketplace/order/order_view_mobile.dart';
// import 'package:maketplace/order/order_viewmodel.dart';
// import 'package:maketplace/payment/payment_view.dart';
// import 'package:maketplace/utils/style.dart';
// import 'package:provider/provider.dart';
// import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:maketplace/common/app_bar_view.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/order/mobile/payment_options_view.dart';
import 'package:maketplace/order/order_model.dart';
import 'package:maketplace/order/order_viewmodel.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key, required this.orderId, required this.fromQuote}) : super(key: key);

  final String orderId;
  final bool fromQuote;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderViewModel()..init(orderId, fromQuote),
      child: Scaffold(
        appBar: NormalAppBar(context: context),
        backgroundColor: AppKeys().customColors!.WBY,
        body: Builder(builder: (context) {
          final hasOrder = context.watch<OrderViewModel>().order != null;
          if (!hasOrder) {
            return const Center(
              child: CircularProgressIndicator(),
              // child: _Content(),
            );
          }
          return const Center(
            child: _Content(),
          );
        }),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderViewModel>().order!;
    final customColors = AppKeys().customColors!;
    final size = MediaQuery.of(context).size;
    if (kIsWeb) {
      html.window.history.pushState(null, 'Voltz - Orden ${order.consecutive}', '?order=${order.id!}');
    }
    return SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 130),
          Text("Tu pedido", style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 42.0, color: customColors.dark)),
          SizedBox(height: 10),
          Text("Alias ${order.alias}", style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 28.0, color: customColors.dark)),
          SizedBox(height: 10),
          Text("ID: #${order.consecutive}", style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, fontSize: 14.0, color: customColors.dark)),
          SizedBox(height: 25),
          Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              const _TrackingWidget(),
              // if (size.width > 745) const SizedBox(width: 25) else SizedBox(height: 25, width: size.width > 360 ? 360 : double.infinity),
              // const _ContentItemWidget(),
              if (size.width > 745) const SizedBox(width: 25) else const SizedBox.shrink(),
              if (size.width > 745) const _ContentItemWidget() else const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 130),
        ],
      ),
    );
  }
}

class _ContentItemWidget extends StatelessWidget {
  const _ContentItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = AppKeys().customColors!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          constraints: BoxConstraints(
            maxWidth: size.width > 360 ? 360 : double.infinity,
            // maxWidth: 360,
            maxHeight: 580,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Realiza tu pago",
                        style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 32.0, color: colors.dark),
                      ),
                      // LinearProgressIndicator(
                      //   backgroundColor: colors.dark,
                      //   color: colors.energyColor,
                      //   value: 0.5,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Text("Vence"),
                      //     Text("00:00:00"),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                _PaymentItemWidget(),
                _PaymentItemWidget2(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(
            maxWidth: size.width > 360 ? 360 : double.infinity,
            // maxWidth: 360,
            maxHeight: 580,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Constancia S. Fiscal Voltz",
                style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, fontSize: 14.0, color: AppKeys().customColors!.dark),
              ),
              const SizedBox(width: 30),
              SecondaryButton(
                text: "Descargar",
                buttonColor: AppKeys().customColors!.WBY,
                onPressed: () {
                  final fiscalUrl =
                      'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2Fcsf_VOLTZ.pdf?alt=media&token=605ceadf-2576-44e4-b353-1ef990872d9f';
                  html.window.open(fiscalUrl, "_blank");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentItemWidget extends HookWidget {
  const _PaymentItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final open = useState(true);
    final order = context.watch<OrderViewModel>().order!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppKeys().customColors!.WBY),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          child: Row(
            children: <Widget>[
              Icon(Icons.account_balance_wallet_rounded, color: AppKeys().customColors!.dark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Transferencia electronica",
                  style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 16.0, color: AppKeys().customColors!.dark),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  open.value = !open.value;
                },
                icon: open.value ? const Icon(Icons.keyboard_arrow_down_outlined) : const Icon(Icons.keyboard_arrow_up_outlined),
              ),
            ],
          ),
        ),
        if (open.value)
          Container(
            padding: EdgeInsets.all(25),
            color: AppKeys().customColors!.WBYPlusOne,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const _BankItemWidget(
                        title: "Banco destino",
                        text: "BBVA",
                      ),
                      const SizedBox(height: 15),
                      const _BankItemWidget(
                        title: "No. Cuenta",
                        text: "0119621431",
                      ),
                      const SizedBox(height: 15),
                      const _BankItemWidget(
                        title: "CLABE",
                        text: "012320001196214312",
                      ),
                      const SizedBox(height: 15),
                      const _BankItemWidget(
                        title: "Titutlar",
                        text: "VOLTZ MEXICO SAPI DE CV",
                      ),
                      const SizedBox(height: 15),
                      _BankItemWidget(
                        title: "Valor a pagar",
                        text: "\$${order.totals!.total!.toStringAsFixed(2)} mxn",
                      ),
                      const SizedBox(height: 15),
                      _BankItemWidget(
                        title: "Concepto",
                        text: order.consecutive!.toString(),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  "assets/svg/under_part.svg",
                  height: 20,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 15),
                Builder(
                  builder: (ctx) {
                    final stepStatus = context.watch<OrderViewModel>().stepStatus;
                    return PrimaryButton(
                      text: stepStatus == StepStatus.verifyingPayment ? "Verificando..." : "Ya pague",
                      onPressed: () {
                        if (stepStatus != StepStatus.verifyingPayment) {
                          context.read<OrderViewModel>().updatePaymentStatus(PaymentStatus.verifying);
                        }
                      },
                      enabled: stepStatus != StepStatus.verifyingPayment,
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PaymentItemWidget2 extends HookWidget {
  const _PaymentItemWidget2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final open = useState(false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppKeys().customColors!.WBY),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          child: Row(
            children: <Widget>[
              Icon(Icons.account_balance_wallet_rounded, color: AppKeys().customColors!.dark),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Otras formas de pago",
                  style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 16.0, color: AppKeys().customColors!.dark),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  open.value = !open.value;
                },
                icon: open.value ? const Icon(Icons.keyboard_arrow_down_outlined) : const Icon(Icons.keyboard_arrow_up_outlined),
              ),
            ],
          ),
        ),
        if (open.value)
          Container(
            padding: EdgeInsets.all(25),
            color: AppKeys().customColors!.WBYPlusOne,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Contacta a un agente Voltz\npara pagar con estos medios",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(child: Image.asset("assets/images/payments/visamaster.png")),
                              const SizedBox(width: 10),
                              Expanded(child: Image.asset("assets/images/payments/amex.png")),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Image.asset("assets/images/payments/paypal.png")),
                              const SizedBox(width: 10),
                              Expanded(child: Image.asset("assets/images/payments/efectivo.png")),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: "Contactar agente",
                  onPressed: () {
                    html.window.open('https://api.whatsapp.com/send/?phone=523313078145&text=Hola%2C+quiero+que+me+cotices%3A&type=phone_number&app_absent=0', "_blank");
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BankItemWidget extends StatelessWidget {
  const _BankItemWidget({
    super.key,
    required this.title,
    required this.text,
  });
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 12.0, color: AppKeys().customColors!.dark),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(fontStyle: FontStyle.normal, fontWeight: FontWeight.w500, fontSize: 14.0, color: AppKeys().customColors!.dark),
          ),
        ),
      ],
    );
  }
}

class _TrackingWidget extends StatelessWidget {
  const _TrackingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final stepStatus = context.watch<OrderViewModel>().stepStatus;
    final order = context.watch<OrderViewModel>().order!;
    final size = MediaQuery.of(context).size;
    final colors = AppKeys().customColors!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: size.width > 360 ? 360 : double.infinity,
        // maxWidth: 360,
        maxHeight: 580,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                _PointWidget(
                  pending: stepStatus == StepStatus.initial,
                  completed: true,
                ),
                const SizedBox(height: 5),
                _LineWidget(
                  pending: stepStatus == StepStatus.pendingPayment || stepStatus == StepStatus.verifyingPayment,
                  completed: stepStatus == StepStatus.paymentDone || (stepStatus != StepStatus.pendingPayment && stepStatus != StepStatus.verifyingPayment),
                ),
                const SizedBox(height: 5),
                _PointWidget(
                  pending: stepStatus == StepStatus.pendingPayment || stepStatus == StepStatus.verifyingPayment,
                  completed: stepStatus == StepStatus.paymentDone || (stepStatus != StepStatus.pendingPayment && stepStatus != StepStatus.verifyingPayment),
                ),
                const SizedBox(height: 5),
                _LineWidget(
                  pending: stepStatus == StepStatus.shippingProcessing || stepStatus == StepStatus.shippingShipped,
                  completed: stepStatus == StepStatus.shippingDelivered,
                ),
                const SizedBox(height: 5),
                _PointWidget(
                  pending: stepStatus == StepStatus.shippingProcessing || stepStatus == StepStatus.shippingShipped,
                  completed: stepStatus == StepStatus.shippingDelivered,
                ),
                const SizedBox(height: 5),
                _LineWidget(
                  pending: stepStatus == StepStatus.shippingDelivered,
                  completed: stepStatus == StepStatus.shippingDelivered,
                ),
                const SizedBox(height: 5),
                _PointWidget(
                  pending: stepStatus == StepStatus.shippingDelivered,
                  completed: stepStatus == StepStatus.shippingDelivered,
                ),
              ],
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                children: <Widget>[
                  _TrackItemWidget(
                    iconData: Icons.format_list_numbered_rounded,
                    title: "Pedido realizado",
                    date: DateFormat("dd/MM/yyyy HH:mm").format(order.createdAt!),
                    actionWidget: SecondaryButton(
                      onPressed: () {},
                      text: "Ver productos",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFE4E9FC)),
                  const SizedBox(height: 20),
                  _TrackItemWidget(
                    iconData: Icons.attach_money_rounded,
                    title: "Pagar pedido",
                    date: stepStatus == StepStatus.verifyingPayment ? "Verificando..." : "\$${order.totals!.total!.toStringAsFixed(2)} mxn",
                    actionWidget: Builder(builder: (context) {
                      if (stepStatus == StepStatus.pendingPayment) {
                        return PrimaryButton(
                          onPressed: () {
                            if (size.width > 720) {
                              // reemplazar ventana de la derecha
                            } else {
                              //mostrar una nueva ventana con metodos de pago
                              final orderVMRead = context.read<OrderViewModel>();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => PaymentOptionsView(
                                    contextVM: context,
                                  ),
                                ),
                              );
                            }
                          },
                          text: "Realizar pago",
                        );
                      } else if (stepStatus == StepStatus.verifyingPayment) {
                        return PrimaryButton(
                          onPressed: () {},
                          text: "Realizar pago",
                          enabled: false,
                        );
                      } else {
                        return const SizedBox.shrink();
                        return SecondaryButton(
                          onPressed: () {},
                          text: "Descargar factura",
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFE4E9FC)),
                  const SizedBox(height: 20),
                  _TrackItemWidget(
                    iconData: Icons.local_shipping,
                    title: "Envio",
                    date: stepStatus == StepStatus.shippingProcessing
                        ? "Recolectando material"
                        : stepStatus == StepStatus.shippingShipped
                            ? DateFormat("dd/MM/yyyy HH:mm").format(order.shipping!.shippedDate!)
                            : stepStatus == StepStatus.shippingDelivered
                                ? DateFormat("dd/MM/yyyy HH:mm").format(order.shipping!.shippedDate!)
                                : "Esperando pago",
                    actionWidget: Builder(builder: (context) {
                      if (stepStatus == StepStatus.shippingProcessing) {
                        return const SizedBox.shrink();
                        return ThirdButton(
                          onPressed: () {},
                          text: "Programar envio",
                        );
                      } else if (stepStatus == StepStatus.shippingShipped) {
                        return const SizedBox.shrink();
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  Divider(height: 1, color: Color(0xFFE4E9FC)),
                  const SizedBox(height: 20),
                  _TrackItemWidget(
                    iconData: Icons.done_all,
                    title: "Entregado",
                    date: stepStatus == StepStatus.shippingShipped
                        ? "En ruta"
                        : stepStatus == StepStatus.shippingDelivered
                            ? DateFormat("dd/MM/yyyy HH:mm").format(order.shipping!.deliveredDate!)
                            : "Esperando",
                    actionWidget: Builder(builder: (context) {
                      return const SizedBox.shrink();
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LineWidget extends StatelessWidget {
  const _LineWidget({
    super.key,
    this.completed = false,
    this.pending = false,
  });

  final bool completed;
  final bool pending;
  @override
  Widget build(BuildContext context) {
    final colors = AppKeys().customColors!;
    return SizedBox(
      height: 115,
      child: VerticalDivider(
          width: 2,
          color: pending
              ? colors.energyColor
              : completed
                  ? colors.dark
                  : colors.dark1,
          thickness: 2),
    );
  }
}

class _PointWidget extends StatelessWidget {
  const _PointWidget({
    super.key,
    this.completed = false,
    this.pending = false,
  });

  final bool completed;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final colors = AppKeys().customColors!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 15,
        height: 15,
        color: pending
            ? colors.energyColor
            : completed
                ? colors.dark
                : colors.dark1,
      ),
    );
  }
}

class _TrackItemWidget extends StatelessWidget {
  const _TrackItemWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.date,
    required this.actionWidget,
  });
  final IconData iconData;
  final String title;
  final String date;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    final colors = AppKeys().customColors!;
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colors.dark, shape: BoxShape.circle),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    height: 1,
                    color: AppKeys().customColors!.dark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    height: 1,
                    color: AppKeys().customColors!.dark,
                  ),
                ),
                const SizedBox(height: 10),
                actionWidget,
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class OrderView extends StatefulWidget {
//   const OrderView({Key? key, required this.orderId}) : super(key: key);
//   final String orderId;

//   @override
//   _OrderViewState createState() => _OrderViewState();
// }

// class _OrderViewState extends State<OrderView> {
//   ScrollController _scrollController = ScrollController();

//   bool showPaymentView = true;

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<OrderViewModel>.reactive(
//         viewModelBuilder: () => OrderViewModel(),
//         onViewModelReady: (viewModel) => viewModel.init(widget.orderId),
//         fireOnViewModelReadyOnce: false,
//         disposeViewModel: false,
//         builder: (context, viewModel, child) {
//           if (viewModel.order == null) {
//             return const Center(
//               child: SizedBox(
//                 width: 30,
//                 height: 30,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           } else {
//             // html.window.history.pushState(null, 'Voltz - Pedido ${viewModel.order!.consecutive}', '?cotz=${viewModel.order!.id}');
//             return Scaffold(
//               backgroundColor: AppKeys().customColors!.backgroundCanvas,
//               body: MediaQuery.of(context).size.width >= 480
//                   ? Container(
//                       padding: EdgeInsets.all(0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           if (showPaymentView) ...[
//                             _OrderHeader(
//                               total: viewModel.order!.totals!.total!,
//                             ),
//                             Expanded(
//                               child: PaymentInstructions(
//                                 total: viewModel.order!.totals!.total!,
//                                 order_consecutive: viewModel.order!.consecutive!.toString(),
//                                 showOrderListener: showOrder,
//                               ),
//                             ),
//                           ] else ...[
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 controller: _scrollController,
//                                 child: Column(
//                                   children: [
//                                     _OrderHeader(
//                                       total: viewModel.order!.totals!.total!,
//                                     ),
//                                     Divider(
//                                       height: 1,
//                                       color: AppKeys().customColors!.grayBackground,
//                                     ),
//                                     _OrderHeaderId(
//                                         createdAt: viewModel.order!.createdAt!.toDate(),
//                                         alias: viewModel.order!.alias!,
//                                         orderId: viewModel.order!.consecutive!.toString(),
//                                         showOrder: showOrder),
//                                     Divider(
//                                       height: 1,
//                                       color: AppKeys().customColors!.grayBackground,
//                                     ),
//                                     const SizedBox(
//                                       height: 24,
//                                     ),
//                                     if (viewModel.order!.detail != null) ...[
//                                       for (int i = 0; i <= viewModel.order!.detail!.length - 1; i++) ...{
//                                         _OrerdeTableDetail(
//                                           i: i,
//                                         ),
//                                       },
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             _OrderTotals(
//                               tax: viewModel.order!.totals!.tax!,
//                               total: viewModel.order!.totals!.total!,
//                               subTotal: viewModel.order!.totals!.subTotal!,
//                               shippingTotal: (viewModel.order!.shipping != null ? viewModel.order!.shipping!.total! : null),
//                             ),
//                           ],
//                         ],
//                       ),
//                     )
//                   : Container(
//                       padding: EdgeInsets.all(0),
//                       child: Column(
//                         children: [
//                           if (showPaymentView) ...[
//                             OrderHeaderMobile(
//                               total: viewModel.order!.totals!.total!,
//                               consecutive: viewModel.order!.consecutive.toString(),
//                             ),
//                             Expanded(
//                               child: PaymentInstructionsMobile(
//                                 total: viewModel.order!.totals!.total!,
//                                 order_consecutive: viewModel.order!.consecutive!.toString(),
//                                 showOrderListener: showOrder,
//                               ),
//                             ),
//                           ] else ...[
//                             OrderHeaderMobile(
//                               total: viewModel.order!.totals!.total!,
//                               consecutive: viewModel.order!.consecutive.toString(),
//                             ),
//                             Divider(
//                               height: 1,
//                               color: AppKeys().customColors!.grayBackground,
//                             ),
//                             OrderTotalsMobile(
//                               tax: viewModel.order!.totals!.tax!,
//                               total: viewModel.order!.totals!.total!,
//                               subTotal: viewModel.order!.totals!.subTotal!,
//                               shippingTotal: viewModel.order!.shipping == null ? null : viewModel.order!.shipping!.total,
//                               quoteId: viewModel.order!.id!,
//                               totalProducts: viewModel.order!.detail!.length,
//                             ),
//                             const SizedBox(
//                               height: 24,
//                             ),
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 controller: _scrollController,
//                                 child: Column(
//                                   children: [
//                                     if (viewModel.order!.detail != null) ...[
//                                       for (int i = 0; i <= viewModel.order!.detail!.length - 1; i++) ...{
//                                         OrderTableDetailMobile(
//                                           i: i,
//                                         ),
//                                       },
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             _GoToPayment(
//                               listenerShowOrder: showOrder,
//                             )
//                           ],
//                         ],
//                       ),
//                     ),
//             );
//           }
//         });
//   }

//   showOrder() {
//     setState(() {
//       showPaymentView = !showPaymentView;
//     });
//   }
// }

// class _GoToPayment extends StatefulWidget {
//   _GoToPayment({
//     Key? key,
//     required this.listenerShowOrder,
//   }) : super(
//           key: key,
//         );
//   VoidCallback listenerShowOrder;
//   @override
//   _GoToPaymentSate createState() => _GoToPaymentSate();
// }

// class _GoToPaymentSate extends State<_GoToPayment> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       color: Colors.white,
//       child: Container(
//           width: double.infinity,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(26),
//             ),
//             color: AppKeys().customColors!.energyColor,
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: const BorderRadius.all(Radius.circular(26)),
//               hoverColor: AppKeys().customColors!.energyColorHover,
//               onTap: () {
//                 setState(() {
//                   widget.listenerShowOrder();
//                 });
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                 alignment: Alignment.center,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       'Ir a pago',
//                       style: CustomStyles.styleVolcanicBlueDos.copyWith(color: Colors.white),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )),
//     );
//   }
// }

// class _OrderHeader extends StatelessWidget {
//   _OrderHeader({
//     required this.total,
//   });
//   double total;
//   var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
//       color: Colors.white,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             AppKeys().logo!,
//             width: 122,
//             height: 24.5,
//           ),
//           const Spacer(),

//           /*Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(26),),
//                   color: Color(0xFFFFFDFB),
//                   border: Border.all(width: 2, color: CustomColors.safeBlue)
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.all(Radius.circular(26)),
//                   hoverColor: CustomColors.blueBackground,
//                   onTap: (){

//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                     alignment: Alignment.center,
//                     child:  Row(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/svg/pdf_export_ico.svg',
//                           width: 16,
//                           height: 20,
//                         ),
//                         const SizedBox(width: 8,),
//                         SelectableText.rich(
//                           textAlign: TextAlign.start,
//                           text: new TextSpan(
//                             children: [
//                               new TextSpan(text: 'Exportar PDF',
//                                 style: TextStyle(
//                                   fontFamily: "Hellix",
//                                   color: CustomColors.safeBlue,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//           ),*/
//           SizedBox(
//             width: 16,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OrderHeaderId extends StatelessWidget {
//   _OrderHeaderId({required this.orderId, required this.alias, required this.createdAt, required this.showOrder});

//   final DateTime createdAt;
//   final String orderId;
//   final String alias;
//   final VoidCallback showOrder;

//   final Color _buttonColor = AppKeys().customColors!.safeBlue;
//   final Color _buttonHoverColor = AppKeys().customColors!.safeBlueHover;

//   @override
//   Widget build(BuildContext context) {
//     {
//       final f = intl.DateFormat('MMMM dd, yyyy hh:mm', 'es_MX');
//       String formattedDate = f.format(createdAt.toLocal());
//       return Container(
//         padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 64),
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SelectableText.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: 'Pedido ',
//                     style: TextStyle(
//                       fontFamily: "Hellix",
//                       color: AppKeys().customColors!.volcanicBlue,
//                       fontSize: 48,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   TextSpan(
//                     text: "#$orderId",
//                     style: TextStyle(
//                       fontFamily: "Hellix",
//                       color: AppKeys().customColors!.volcanicBlue,
//                       fontSize: 32,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               textAlign: TextAlign.start,
//             ),
//             const SizedBox(
//               height: 24,
//             ),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                       color: const Color(0xFFF9FAFF),
//                       border: Border.all(width: 1, color: const Color(0xFFE5E7EB))),
//                   child: SelectableText.rich(
//                     TextSpan(
//                       children: [
//                         /*new TextSpan(text: 'CLIENTE: ',
//                         style: TextStyle(
//                           fontFamily: "Hellix",
//                           color: CustomColors.volcanicBlue,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,),
//                       ),*/
//                         TextSpan(
//                           text: alias,
//                           style: TextStyle(
//                             fontFamily: "Hellix",
//                             color: AppKeys().customColors!.volcanicBlue,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 40,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                       color: const Color(0xFFF9FAFF),
//                       border: Border.all(width: 1, color: const Color(0xFFE5E7EB))),
//                   child: SelectableText.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'FECHA: ',
//                           style: TextStyle(
//                             fontFamily: "Hellix",
//                             color: AppKeys().customColors!.volcanicBlue,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         TextSpan(
//                           text: formattedDate,
//                           style: TextStyle(
//                             fontFamily: "Hellix",
//                             color: AppKeys().customColors!.volcanicBlue,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                     width: 250,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(26),
//                       ),
//                       color: _buttonColor,
//                     ),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         borderRadius: const BorderRadius.all(Radius.circular(26)),
//                         hoverColor: _buttonHoverColor,
//                         onTap: () {
//                           showOrder();
//                         },
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                           alignment: Alignment.center,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Text(
//                                 'Ir a pago',
//                                 style: CustomStyles.styleWhiteDos,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     )),
//               ],
//             )
//           ],
//         ),
//       );
//     }
//   }
// }

// class _OrderTotals extends StatefulWidget {
//   _OrderTotals({
//     Key? key,
//     required this.tax,
//     required this.total,
//     required this.subTotal,
//     required this.shippingTotal,
//   }) : super(
//           key: key,
//         );
//   final double tax;
//   final double total;
//   final double subTotal;
//   final double? shippingTotal;

//   @override
//   _OrderTotalsState createState() => _OrderTotalsState();
// }

// class _OrderTotalsState extends State<_OrderTotals> {
//   var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
//         color: AppKeys().customColors!.volcanicBlue,
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       SelectableText(
//                         "Subtotal único",
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                       const Spacer(),
//                       SelectableText(
//                         currencyFormat.format(widget.subTotal),
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                     ],
//                   ),
//                   /* const SizedBox(height: 8,),
//                 Row(
//                   children: [
//                     SelectableText(
//                       "Descuento",
//                       style: CustomStyles.styleWhiteUno,
//                     ),
//                     Spacer(),
//                     SelectableText(
//                       currencyFormat.format(widget.discount),
//                       style: CustomStyles.styleWhiteUno,
//                     ),
//                   ],
//                 ),*/
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SelectableText(
//                         "IVA",
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                       const Spacer(),
//                       SelectableText(
//                         currencyFormat.format(widget.tax * widget.subTotal),
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                     ],
//                   ),
//                   if (widget.shippingTotal != null) ...[
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       children: [
//                         SelectableText(
//                           "Costo de envío",
//                           style: CustomStyles.styleWhiteUno,
//                         ),
//                         const Spacer(),
//                         SelectableText(
//                           currencyFormat.format(widget.shippingTotal),
//                           style: CustomStyles.styleWhiteUno,
//                         ),
//                       ],
//                     ),
//                   ],
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       SelectableText(
//                         "Total",
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                       const Spacer(),
//                       SelectableText(
//                         currencyFormat.format(widget.total),
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OrerdeTableDetail extends StatefulWidget {
//   _OrerdeTableDetail({
//     Key? key,
//     required this.i,
//   }) : super(key: key);
//   int i;

//   @override
//   _OrerdeTableDetailState createState() => _OrerdeTableDetailState();
// }

// class _OrerdeTableDetailState extends State<_OrerdeTableDetail> {
//   late OrderViewModel model;
//   var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

//   TextEditingController textEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     print(widget.i);
//     model = context.read<OrderViewModel>();
//     print('esta es la orden ... ');
//     print(model.order!.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.only(left: 60, right: 60, top: 16, bottom: 16),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 2,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
//                   color: AppKeys().customColors!.safeBlue,
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                         color: AppKeys().customColors!.energyColor,
//                       ),
//                       alignment: Alignment.center,
//                       width: 56,
//                       child: SelectableText(
//                         (widget.i + 1).toString(),
//                         style: CustomStyles.styleBlueUno,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                       ),
//                       child: SelectableText(
//                         model.order!.detail![widget.i].productRequested!.toUpperCase(),
//                         style: CustomStyles.styleWhiteUno,
//                       ),
//                     ),
//                     const Spacer(),
//                   ],
//                 ),
//               ),
//               for (int b = 0; b <= model.order!.detail![widget.i].productsOrdered!.length - 1; b++) ...{
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                   decoration: BoxDecoration(
//                     borderRadius: b == model.order!.detail![widget.i].productsOrdered!.length - 1
//                         ? const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
//                         : null,
//                     color: AppKeys().customColors!.blueBackground,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 140,
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 24,
//                             ),
//                             const SizedBox(
//                               width: 30,
//                             ),
//                             if (1 == 1) ...{
//                               SvgPicture.asset(
//                                 'assets/svg/no_image_ico.svg',
//                                 width: 56,
//                                 height: 56,
//                               ),
//                             },
//                             const SizedBox(
//                               width: 30,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SelectableText(
//                               model.order!.detail![widget.i].productsOrdered![b].sku!,
//                               style: CustomStyles.styleVolcanicBlueUno,
//                               textAlign: TextAlign.left,
//                             ),
//                             SelectableText(
//                               model.order!.detail![widget.i].productsOrdered![b].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
//                               style: CustomStyles.styleVolcanicUno,
//                               textAlign: TextAlign.left,
//                               //overflow: TextOverflow.clip,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 524,
//                         child: Row(
//                           children: [
//                             const SizedBox(
//                               width: 30,
//                             ),
//                             Container(
//                               width: 159,
//                               padding: const EdgeInsets.all(8),
//                               alignment: Alignment.center,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         SelectableText(
//                                           model.order!.detail![widget.i].productsOrdered![b].brand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
//                                           style: CustomStyles.styleVolcanicBlueDos,
//                                           textAlign: TextAlign.left,
//                                           //overflow: TextOverflow.clip,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 158,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   SelectableText(
//                                     '${model.order!.detail![widget.i].productsOrdered![b].quantity} ',
//                                     style: CustomStyles.styleVolcanicBlueDos,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                   SelectableText(
//                                     model.order!.detail![widget.i].productsOrdered![b].saleUnit ?? '',
//                                     style: CustomStyles.styleVolcanicBlueDos,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.all(24),
//                               width: 177,
//                               child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     SelectableText(
//                                       (currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].total!.afterDiscount!)),
//                                       style: CustomStyles.styleVolcanicBlueTres,
//                                       textAlign: TextAlign.right,
//                                     ),
//                                     SelectableText(
//                                       "${currencyFormat.format(model.order!.detail![widget.i].productsOrdered![b].price!.price2!)} c/u",
//                                       style: CustomStyles.styleVolcanicUno,
//                                       textAlign: TextAlign.right,
//                                     ),
//                                   ],
//                                 ),
//                               ]),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               }
//             ],
//           ),
//         ));
//   }
// }
