import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/common/header.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/extensions.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

const double fontSizeParagraph = 12;
const Color _white = Color(0xFFFFFFFF);
const Color _yellow = Color(0xFFF7CB2F);
const Color _blue = Color(0xFF2E5CFF);
const Color _volcanic = Color(0xFF394055);
const Color _gray = Color(0xFFEFF2FD);
const Color _background = Color(0xFFEFF2FD);
const Color _energyYellow_20 = Color(0xFFFDF5D5);

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: _background,
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderMobile(),
              _ad(),
              summary(),
              _cartContent(),
            ],
          ),
        ),
      ),
    );
  }

  Container _ad() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: const BoxDecoration(
          color: _blue,
        ),
        width: double.infinity,
        height: 110,
        child: Row(
          children: [
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2Fassistant_icon.png?alt=media&token=a38ac3f8-0ab3-4558-a77d-831ea14852fb',
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Puedes modificar este pedido", style: GoogleFonts.montserrat(color: _white, fontSize: 16, fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Abre esta URL desde tu computador de escritorio o portátil para acceder a todas las funcionalidades.",
                      style: GoogleFonts.montserrat(
                        color: _white,
                        fontSize: fontSizeParagraph,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}

class summary extends StackedHookView<QuoteViewModel> {
  summary({
    Key? key,
  }) : super(key: key, reactive: true);
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (model.quote.detail != null) {
          if (kIsWeb) {
            html.window.history.pushState(null, 'Voltz - Cotización ${model.quote.consecutive}', '?cotz=${model.quote.id!}');
          }
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text("Resumen del pedido",
                        style: GoogleFonts.montserrat(
                          color: _volcanic,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                    const Spacer(),
                    Text("#${model.quote.consecutive}",
                        style: GoogleFonts.montserrat(
                          color: _volcanic,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                    color: _gray,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Valor productos",
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          )),
                      Text(" (-${currencyFormat.format(model.quote.totals!.discount!)} dcto.)",
                          style: GoogleFonts.montserrat(
                            color: _blue,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          )),
                      const Spacer(),
                      Text(currencyFormat.format(model.quote.totals!.subTotal! - model.quote.totals!.discount!),
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('IVA (16%)',
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          )),
                      const Spacer(),
                      Text(currencyFormat.format(model.quote.totals!.tax!),
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                    color: _gray,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Envio',
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          )),
                      const Spacer(),
                      if (model.quote.shipping == null || model.quote.shipping!.total == 0) ...[
                        Text('Gratis',
                            style: GoogleFonts.montserrat(
                              color: _blue,
                              fontSize: fontSizeParagraph,
                              fontWeight: FontWeight.w400,
                            )),
                      ] else ...[
                        Text(currencyFormat.format(model.quote.shipping!.total!),
                            style: GoogleFonts.montserrat(
                              color: _volcanic,
                              fontSize: fontSizeParagraph,
                              fontWeight: FontWeight.w400,
                            )),
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                    color: _gray,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Total pedido',
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w600,
                          )),
                      const Spacer(),
                      Text('${currencyFormat.format(model.quote.totals!.total)} MXN',
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ],
              ));
        } else {
          return Container();
        }
      },
    );
  }
}

class _cartContent extends StackedHookView<QuoteViewModel> {
  _cartContent({
    Key? key,
  }) : super(key: key, reactive: true);
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    print(model.selectedProducts.length.toString());
    return model.selectedProducts.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "${model.selectedProducts.length} Productos incluidos",
                    style: GoogleFonts.montserrat(
                      color: _volcanic,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Descarga este listado en Excel y las fichas técnicas abriendo este link desde tu computador.",
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.montserrat(
                      color: _volcanic,
                      fontSize: fontSizeParagraph,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                /*for(int index = 0; index <= model.selectedProducts.length -1; index++) ...{
          _cartItemView(
            productIndex: index,
          ),
        },*/
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                  reverse: false,
                  controller: model.scrollController,
                  itemCount: model.selectedProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index <= model.selectedProducts.length - 1) {
                      return _cartItemView(
                        productIndex: index,
                      );
                    } else {
                      return _paymentDetails();
                    }
                  },
                ),
              ],
            ))
        : const SizedBox(
            height: 200,
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }

  Column _paymentDetails() {
    return Column(
      children: [
        Container(
          color: _blue,
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 30,
            right: 10,
            left: 10,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    'Realiza tu pago. Después de confirmar tu pedido.',
                    style: GoogleFonts.montserrat(
                      color: _white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Otras formas de pago',
                        style: GoogleFonts.montserrat(
                          color: _white,
                          fontSize: fontSizeParagraph,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2FVisamaster.png?alt=media&token=32df52e8-9c33-4b3c-af4f-c36887d5c3de',
                            height: 20,
                            width: 60,
                          ),
                          SizedBox(width: 6.67),
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2FAmex.png?alt=media&token=d997de8b-412d-429f-9086-aa0f66335285',
                            height: 20,
                            width: 60,
                          ),
                          SizedBox(width: 6.67),
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2FPaypal.png?alt=media&token=02dfcd64-7467-4b1a-b437-427f5b091590',
                            height: 20,
                            width: 60,
                          ),
                          SizedBox(width: 6.67),
                          SvgPicture.asset(
                            'assets/svg/icon_cash.svg',
                            height: 20,
                            width: 60,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
                  margin: const EdgeInsets.all(0),
                  width: double.infinity,
                  color: _white,
                  child: Text(
                    "Transferencia electrónica",
                    style: GoogleFonts.montserrat(
                      color: _volcanic,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: double.infinity,
                  height: 16,
                  child: SvgPicture.asset(
                    'assets/svg/lines_mobile_icon.svg',
                    width: double.infinity,
                    height: 16,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
                  width: double.infinity,
                  color: _white,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Banco destino",
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          "BBVA",
                          style: GoogleFonts.montserrat(
                            color: _blue,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
                  color: _white,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "No. Cuenta",
                          style: GoogleFonts.montserrat(
                            color: _blue,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          "0119621431",
                          style: GoogleFonts.montserrat(
                            color: _blue,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  width: double.infinity,
                  color: _white,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "CLABE",
                          style: GoogleFonts.montserrat(
                            color: _volcanic,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          "012320001196214312",
                          style: GoogleFonts.montserrat(
                            color: _blue,
                            fontSize: fontSizeParagraph,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  width: double.infinity,
                  height: 16,
                  child: SvgPicture.asset(
                    'assets/svg/bottom_lines.svg',
                    width: double.infinity,
                    height: 16,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ]),
            ],
          ),
        ),
        Container(
          color: _white,
          margin: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/icon_business.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  'Voltz México SAPI de CV\nVME221026G21',
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/icon_location.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  'Carretera a Nogales 9005 Int. D15, Diana\nNatura, Zapopan Jalisco, México. CP 45221',
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/icon_phone.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  '+52 33 1307 8145\nventas@voltz.mx',
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                const Spacer(),
              ],
            )
          ]),
        ),
      ],
    );
  }
}

class CartList extends StackedHookView<QuoteViewModel> {
  const CartList({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (viewModel.selectedProducts.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            reverse: false,
            controller: viewModel.scrollController,
            itemCount: viewModel.selectedProducts.length,
            itemBuilder: (context, index) {
              return _cartItemView(
                productIndex: index,
              );
            },
          );
        } else {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class _cartItemView extends StackedHookView<QuoteViewModel> {
  const _cartItemView({Key? key, required this.productIndex}) : super(key: key, reactive: true);
  final int productIndex;

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return GestureDetector(
      onTap: model.selectedProducts[productIndex].source != "manual"
          ? () {
              //model.navigateToProductDetailMobile( model.selectedProducts[productIndex].productId!);
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        color: _white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.selectedProducts[productIndex].skuDescription!.capitalize(),
              style: GoogleFonts.montserrat(
                color: _volcanic,
                fontSize: fontSizeParagraph,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.clip,
            ),
            const SizedBox(height: 5),
            Row(children: [
              Text(
                model.selectedProducts[productIndex].brand!.capitalize(),
                style: GoogleFonts.montserrat(
                  color: _volcanic,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              const SizedBox(width: 11),
              Text(
                model.selectedProducts[productIndex].sku!,
                style: GoogleFonts.montserrat(
                  color: _volcanic,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ]),
            const SizedBox(height: 5),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/icon_price.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  model.currencyFormat.format(model.selectedProducts[productIndex].pricePublic!),
                  style: GoogleFonts.montserrat(color: _volcanic, fontSize: fontSizeParagraph, fontWeight: FontWeight.w400, decoration: TextDecoration.lineThrough),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(width: 5),
                Text(
                  model.currencyFormat.format(model.selectedProducts[productIndex].price!.price2!),
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: fontSizeParagraph,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(width: 2),
                Text(
                  model.selectedProducts[productIndex].saleUnit!.capitalize(),
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: fontSizeParagraph,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                SvgPicture.asset('assets/svg/icon_cart.svg', width: 16, height: 16),
                const SizedBox(width: 5),
                Text(
                  '${model.selectedProducts[productIndex].quantity} ${model.selectedProducts[productIndex].saleUnit!.capitalize()}(s)',
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: fontSizeParagraph,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(width: 5),
                SvgPicture.asset('assets/svg/icon_total.svg', width: 16, height: 16),
                const SizedBox(width: 5),
                Text(
                  model.currencyFormat.format(model.selectedProducts[productIndex].total!.afterDiscount!),
                  style: GoogleFonts.montserrat(
                    color: _volcanic,
                    fontSize: fontSizeParagraph,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
