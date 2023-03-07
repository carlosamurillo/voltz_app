import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/order/order_viewmodel.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';

class PaymentInstructions extends StatefulWidget {
  PaymentInstructions({required this.total, required this.order_consecutive, required this.showOrderListener});
  final double total;
  final String order_consecutive;
  final VoidCallback showOrderListener;

  @override
  _PaymentInstructionsState createState() => _PaymentInstructionsState();
}

class _PaymentInstructionsState extends State<PaymentInstructions> {
  String _actionTitle = '';
  Color _buttonColor = CustomColors.safeBlue;
  Color _buttonHoverColor = CustomColors.safeBlueHover;
  String fiscalUrl = 'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2Fcsf_VOLTZ.pdf?alt=media&token=605ceadf-2576-44e4-b353-1ef990872d9f';

  @override
  void initState() {
    super.initState();
    setupVariables();
  }

  setupVariables() {
    if (context.read<OrderViewModel>().order!.paymentStatus == null || context.read<OrderViewModel>().order!.paymentStatus == 'pending') {
      _actionTitle = 'Ya pagué mi envío';
      _buttonColor = CustomColors.safeBlue;
      _buttonHoverColor = CustomColors.safeBlueHover;
    } else if (context.read<OrderViewModel>().order!.paymentStatus == 'verifying') {
      _actionTitle = 'Verificando pago...';
      _buttonColor = CustomColors.energyYellow;
      _buttonHoverColor = CustomColors.energyYellowHover;
    } else {
      _actionTitle = 'Pago confirmado';
      _buttonColor = CustomColors.energyGreen;
      _buttonHoverColor = CustomColors.energyGreen;
    }
  }

  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
        width: 666,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text("Realiza tu pago", style: CustomStyles.styleVolcanic32x700),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 34),
              child: Text("Verifica los siguientes datos y realiza la transferencia a la siguiente cuenta", style: CustomStyles.styleVolcanic14x500),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 20, left: 30, right: 30),
              margin: const EdgeInsets.all(0),
              width: 666,
              color: Colors.white,
              child: Text("Transferencia electrónica", style: CustomStyles.styleVolcanicBlueTres),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: 666,
              height: 19,
              child: SvgPicture.asset(
                'assets/svg/lines_icon.svg',
                width: 666,
                height: 24,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
              width: 666,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    child: SelectableText("Banco destino", style: CustomStyles.styleVolcanic14x500),
                  ),
                  const Spacer(),
                  Container(
                    child: SelectableText("BBVA", style: CustomStyles.styleBlue14x500),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
              width: 666,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    child: SelectableText("CLABE", style: CustomStyles.styleVolcanic14x500),
                  ),
                  const Spacer(),
                  Container(
                    child: SelectableText("012320001196214312", style: CustomStyles.styleVolcanic14x500),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
              width: 666,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    child: SelectableText("Cuenta", style: CustomStyles.styleVolcanic14x500),
                  ),
                  const Spacer(),
                  Container(
                    child: SelectableText("0119621431", style: CustomStyles.styleVolcanic14x500),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 0, left: 30, right: 30),
              width: 666,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    child: SelectableText("Concepto de pago", style: CustomStyles.styleVolcanic14x500),
                  ),
                  const Spacer(),
                  Container(
                    child: SelectableText(widget.order_consecutive, style: CustomStyles.styleVolcanic14x500),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              width: 666,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    child: SelectableText("Importe", style: CustomStyles.styleVolcanic14x500),
                  ),
                  const Spacer(),
                  Container(
                    child: SelectableText(currencyFormat.format(widget.total), style: CustomStyles.styleVolcanic14x500),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: 666,
              height: 20,
              child: SvgPicture.asset(
                'assets/svg/union_icon.svg',
                width: 666,
                height: 24,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.volcanicGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                      ),
                ),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                margin: const EdgeInsets.only(top: 20, bottom: 20, left: 0, right: 0),
                width: 666,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/svg/admiration_icon.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SelectableText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '* En el titular de cuenta poner: ',
                            style: CustomStyles.styleVolcanic14x500,
                          ),
                          TextSpan(
                            text: "VOLTZ MEXICO SAPI DE CV",
                            style: CustomStyles.styleVolcanicBlueDos,
                          ),
                          TextSpan(
                            text: "\n* RFC: ",
                            style: CustomStyles.styleVolcanic14x500,
                          ),
                          TextSpan(
                            text: "VME221026G21",
                            style: CustomStyles.styleVolcanicBlueDos,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
              width: 666,
              child: GestureDetector(
                onTap: () {
                  html.window.open(fiscalUrl, "_blank");
                },
                child: Text(
                  "Descargar comprobante situación fiscal",
                  style: CustomStyles.styleBlue14x500,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  children: [
                    Container(
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(26),
                            ),
                            color: Color(0xFFFFFDFB),
                            border: Border.all(width: 2, color: CustomColors.safeBlue)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(26)),
                            hoverColor: CustomColors.blueBackground,
                            onTap: () async {
                              widget.showOrderListener();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        new TextSpan(text: 'Ver Pedido', style: CustomStyles.styleBlue14x700),
                                      ],
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
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
                              context.read<OrderViewModel>().changePaymentStatus();
                              setState(() {
                                setupVariables();
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
                                    _actionTitle,
                                    style: CustomStyles.styleWhiteDos,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
              width: 666,
              child: GestureDetector(
                onTap: () {
                  html.window.open('https://walink.co/d9aef3', "_blank");
                },
                child: Text(
                  "¿Pago en efectivo? Contácta un agente Voltz",
                  style: CustomStyles.styleBlue14x500,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentInstructionsMobile extends StatefulWidget {
  PaymentInstructionsMobile({required this.total, required this.order_consecutive, required this.showOrderListener});
  final double total;
  final String order_consecutive;
  final VoidCallback showOrderListener;

  @override
  _PaymentInstructionsMobileState createState() => _PaymentInstructionsMobileState();
}

class _PaymentInstructionsMobileState extends State<PaymentInstructionsMobile> {
  String _actionTitle = '';
  Color _buttonColor = CustomColors.safeBlue;
  Color _buttonHoverColor = CustomColors.safeBlueHover;
  String fiscalUrl = 'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2Fcsf_VOLTZ.pdf?alt=media&token=605ceadf-2576-44e4-b353-1ef990872d9f';

  @override
  void initState() {
    super.initState();
    setupVariables();
  }

  setupVariables() {
    if (context.read<OrderViewModel>().order!.paymentStatus == null || context.read<OrderViewModel>().order!.paymentStatus == 'pending') {
      _actionTitle = 'Ya pagué mi envío';
      _buttonColor = CustomColors.safeBlue;
      _buttonHoverColor = CustomColors.safeBlueHover;
    } else if (context.read<OrderViewModel>().order!.paymentStatus == 'verifying') {
      _actionTitle = 'Verificando pago...';
      _buttonColor = CustomColors.energyYellow;
      _buttonHoverColor = CustomColors.energyYellowHover;
    } else {
      _actionTitle = 'Pago confirmado';
      _buttonColor = CustomColors.energyGreen;
      _buttonHoverColor = CustomColors.energyGreen;
    }
  }

  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 15),
      width: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text("Realiza tu pago", style: CustomStyles.styleVolcanic32x700),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 30),
              child: Text("Verifica los siguientes datos y realiza la transferencia a la siguiente cuenta", style: CustomStyles.styleVolcanic14x500),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 20, left: 30, right: 0),
              margin: const EdgeInsets.all(0),
              width: double.infinity,
              color: Colors.white,
              child: Text("Transferencia electrónica", style: CustomStyles.styleVolcanicBlueTres),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: double.infinity,
              height: 19,
              child: SvgPicture.asset(
                'assets/svg/lines_mobile_icon.svg',
                width: 368,
                height: 24,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 15, bottom: 0, left: 30, right: 30),
              child: SelectableText("Banco destino", style: CustomStyles.styleVolcanicBlueDos),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5, bottom: 0, left: 30, right: 30),
              child: SelectableText("BBVA", style: CustomStyles.styleBlue14x500),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 15, bottom: 0, left: 30, right: 30),
              child: SelectableText("CLABE", style: CustomStyles.styleVolcanicBlueDos),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5, bottom: 0, left: 30, right: 30),
              child: SelectableText("012320001196214312", style: CustomStyles.styleVolcanic14x500),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 15, bottom: 0, left: 30, right: 30),
              child: SelectableText("Cuenta", style: CustomStyles.styleVolcanicBlueDos),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5, bottom: 0, left: 30, right: 30),
              child: SelectableText("0119621431", style: CustomStyles.styleVolcanic14x500),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 15, bottom: 0, left: 30, right: 30),
              child: SelectableText("Concepto de pago", style: CustomStyles.styleVolcanicBlueDos),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5, bottom: 0, left: 30, right: 30),
              child: SelectableText(widget.order_consecutive, style: CustomStyles.styleVolcanic14x500),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 15, bottom: 0, left: 30, right: 30),
              child: SelectableText("Importe", style: CustomStyles.styleVolcanicBlueDos),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5, bottom: 0, left: 30, right: 30),
              child: SelectableText(currencyFormat.format(widget.total), style: CustomStyles.styleVolcanic14x500),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: double.infinity,
              height: 20,
              child: SvgPicture.asset(
                'assets/svg/union_mobile_icon.svg',
                width: 368,
                height: 24,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.volcanicGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                      ),
                ),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                margin: const EdgeInsets.only(top: 20, bottom: 10, left: 0, right: 0),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/svg/admiration_icon.svg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '* En el titular de cuenta poner: ',
                              style: CustomStyles.styleVolcanic14x500,
                            ),
                            TextSpan(
                              text: "VOLTZ MEXICO SAPI DE CV",
                              style: CustomStyles.styleVolcanicBlueDos,
                            ),
                            TextSpan(
                              text: "\n* RFC: ",
                              style: CustomStyles.styleVolcanic14x500,
                            ),
                            TextSpan(
                              text: "VME221026G21",
                              style: CustomStyles.styleVolcanicBlueDos,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
              width: 368,
              child: GestureDetector(
                onTap: () {
                  html.window.open(fiscalUrl, "_blank");
                },
                child: Text(
                  "Descargar comprobante situación fiscal",
                  style: CustomStyles.styleBlue14x500,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(26),
                    ),
                    color: Color(0xFFFFFDFB),
                    border: Border.all(width: 2, color: CustomColors.safeBlue)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(26)),
                    hoverColor: CustomColors.blueBackground,
                    onTap: () async {
                      widget.showOrderListener();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                new TextSpan(text: 'Ver Pedido', style: CustomStyles.styleBlue14x700),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            Container(
                width: double.infinity,
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
                      context.read<OrderViewModel>().changePaymentStatus();
                      setState(() {
                        setupVariables();
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
                            _actionTitle,
                            style: CustomStyles.styleWhiteDos,
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
              width: 368,
              child: GestureDetector(
                onTap: () {
                  html.window.open('https://walink.co/d9aef3', "_blank");
                },
                child: Text(
                  "¿Pago en efectivo? Contácta un agente Voltz",
                  style: CustomStyles.styleBlue14x500,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
