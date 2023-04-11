import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/common/app_bar_view.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/order/order_model.dart';
import 'package:maketplace/order/order_viewmodel.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:provider/provider.dart';

class PaymentOptionsView extends StatelessWidget {
  const PaymentOptionsView({super.key, required this.contextVM});
  final BuildContext contextVM;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = AppKeys().customColors!;
    return Scaffold(
      appBar: NormalAppBar(context: context),
      body: Center(
        child: Column(
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
                    _PaymentItemWidget(
                      contextVM: contextVM,
                    ),
                    _PaymentItemWidget2(),
                  ],
                ),
              ),
            ),
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
        ),
      ),
    );
  }
}

class _PaymentItemWidget extends HookWidget {
  const _PaymentItemWidget({super.key, required this.contextVM});
  final BuildContext contextVM;
  @override
  Widget build(BuildContext context) {
    final open = useState(true);
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
                    children: const <Widget>[
                      _BankItemWidget(
                        title: "Banco destino",
                        text: "BBVA",
                      ),
                      SizedBox(height: 15),
                      _BankItemWidget(
                        title: "No. Cuenta",
                        text: "0119621431",
                      ),
                      SizedBox(height: 15),
                      _BankItemWidget(
                        title: "CLABE",
                        text: "012320001196214312",
                      ),
                      SizedBox(height: 15),
                      _BankItemWidget(
                        title: "Titutlar",
                        text: "VOLTZ MEXICO SAPI DE CV",
                      ),
                      SizedBox(height: 15),
                      _BankItemWidget(
                        title: "Valor a pagar",
                        text: "\$0,000,000.00 MXN",
                      ),
                      SizedBox(height: 15),
                      _BankItemWidget(
                        title: "Concepto",
                        text: "872625",
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
                    final stepStatus = contextVM.watch<OrderViewModel>().stepStatus;
                    return PrimaryButton(
                      text: stepStatus == StepStatus.verifyingPayment ? "Verificando..." : "Ya pague",
                      onPressed: () {
                        if (stepStatus != StepStatus.verifyingPayment) {
                          contextVM.read<OrderViewModel>().updatePaymentStatus(PaymentStatus.verifying);
                          Navigator.of(context).pop();
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
