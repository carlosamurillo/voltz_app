
import 'dart:js' as js;
import 'package:intl/intl.dart' as intl;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/utils/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:maketplace/pdf_quote/svg_icons.dart';

import '../keys_model.dart';


class QuotePdf {
  QuotePdf({required this.quote, required this.selectedProducts});
  final VoltzKeys _config = VoltzKeys();
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  final QuoteModel quote;
  final List<ProductsSuggested> selectedProducts;
  var _pdf;
  late final _fontRegular;
  late final _fontSemiBold;

  double fontSizeParagraph = 11;
  final PdfColor _white = const PdfColor.fromInt(0xFFFFFFFF);
  final PdfColor _yellow = const PdfColor.fromInt(0xFFF7CB2F);
  final PdfColor _blue = const PdfColor.fromInt(0xFF2E5CFF);
  final PdfColor _volcanic = const PdfColor.fromInt(0xFF394055);
  final PdfColor _gray = const PdfColor.fromInt(0xFFEFF2FD);
  final PdfColor _background = const PdfColor.fromInt(0xFFEFF2FD);
  final PdfColor _energyYellow_20 = const PdfColor.fromInt(0xFFFDF5D5);
 /* final Uint8List fontData = File('fonts/Hellix-Black.ttf').readAsBytesSync();
  late var _font;*/
  late var _visa_image;
  late var _amex_image;
  late var _paypal_image;

  void generatePdf() async {

    await Future.wait([_loadFonts(), _loadAssistant(),
      _loadAmex(), _loadPaypal(), _loadVisa()]);

    _pdf = Document();

    _page1();
    await _theRest();
    final url = await _uploadFile(await  _pdf.save());
    await _openPdf(url!);
  }

  Future<void> _loadFonts() async {
     _fontRegular = await PdfGoogleFonts.montserratRegular();
    _fontSemiBold = await PdfGoogleFonts.montserratSemiBold();
  }

  // ignore: prefer_typing_uninitialized_variables
  late var _assistantIcon;
  Future<void> _loadAssistant() async {
    _assistantIcon = await networkImage('https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2Fassistant_icon.png?alt=media&token=a38ac3f8-0ab3-4558-a77d-831ea14852fb');
  }
  Future<void> _loadAmex() async {
    _amex_image = await networkImage('https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2FAmex.png?alt=media&token=d997de8b-412d-429f-9086-aa0f66335285');
  }
  Future<void> _loadPaypal() async {
    _paypal_image = await networkImage('https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2FPaypal.png?alt=media&token=02dfcd64-7467-4b1a-b437-427f5b091590');
  }
  Future<void> _loadVisa() async {
    _visa_image = await networkImage('https://firebasestorage.googleapis.com/v0/b/voltz-pro.appspot.com/o/public%2FVisamaster.png?alt=media&token=32df52e8-9c33-4b3c-af4f-c36887d5c3de');
  }

  
  void _page1(){
    _pdf.addPage(Page(
        pageFormat: PdfPageFormat.letter,
        build: (Context context) {
          return FullPage(
              ignoreMargins: true,
              child: Container(
                  color: _background,
                  child: Column(
                    children: [
                      _headerPdf(),
                      SizedBox(height: 30),
                      _ad(),
                      _summary(quote),
                      _addSavings(quote),
                      _detailFirstPage(quote),
                    ]))); // Center
        }));
  }

  Future<void> _theRest() async {
    _pdf.addPage(MultiPage(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: const EdgeInsets.all(0),
          buildBackground: (context){
            return Container(
              color: _background,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
        header: (context){
          return Container(
            color: _background,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 30),
            child: _headerPdf(),
          );
        },
        footer: (context){
          return Container(
            color: _background,
            width: double.infinity,
            height: 36,
          );
        },
        build: (context) {
          return [
            Column(
                children: [
                  for(int i = 2; i < selectedProducts.length; i++)...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _product(i),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                    ),
                    if((i-1)%6 == 0 && i != 2 && selectedProducts.length - i - 1 != 0)...[
                      _next(endMargin: 20),
                    ]
                  ],
                ]
            ),
            _paymentDetails(),
          ];
    }));
  }
  
  Container _headerPdf(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      color: _white,
      child: Row(
        children: [
          SvgImage (
            svg: SVGIcons.logo_votz,
            width: 97,
            height: 18,
          ),
          Spacer(),
          Column(
            children: [
              Text( "Versión impresa",
                  style: TextStyle(fontSize: fontSizeParagraph, font: _fontSemiBold, color: _volcanic)
              ),
              UrlLink(
                  child: Text( "Usar versión digital",
                      style: TextStyle(fontSize: 10, font: _fontRegular, color: _blue, decoration: TextDecoration.underline)),
                  destination: "${_config.appUrl}?cotz=${quote.id!}"
              ),
            ]
          )
        ],
      ),
    );
  }

  Container _ad() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          color: _blue,
        ),
        width: double.infinity,
        child: Row(
          children: [
            Image (
              _assistantIcon,
              width: 64,
              height: 64,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( "Confirma este pedido en Voltz.mx",
                    style: TextStyle(color: _white, fontSize: 24, font: _fontSemiBold,)),
                SizedBox(height: 10,),
                Text( "La disponibilidad y los precios pueden cambiar sin previo aviso.",
                    style: TextStyle(color: _white, fontSize: fontSizeParagraph, font: _fontRegular,)),
                Text( "¡Confirma tu pedido ya!",
                    style: TextStyle(color: _yellow, fontSize: fontSizeParagraph, font: _fontSemiBold,)),

              ],
            )
          ],
        )
    );
  }

  Container _summary(QuoteModel quote){
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: _white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row (
              children: [
                Text( "Resumen del pedido",
                    style: TextStyle(color: _volcanic, fontSize: 18, font: _fontSemiBold,)),
                Spacer(),
                Text( "#${quote.consecutive}",
                    style: TextStyle(color: _volcanic, fontSize: 18, font: _fontSemiBold,)),
              ]
            ),
            SizedBox(height: 10,),
            Divider(
              height: 2,
              color: _gray,
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Valor productos",
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,)),
                Text(" (-${currencyFormat.format(quote.totals!.discount!)} dcto.)",
                    style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,)),
                Spacer(),
                Text(currencyFormat.format(quote.totals!.subTotal! - quote.totals!.discount!),
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,)),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('IVA (16%)',
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,)),
                Spacer(),
                Text(currencyFormat.format(quote.totals!.tax!),
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,)),
              ],
            ),
            SizedBox(height: 10,),
            Divider(
              height: 2,
              color: _gray,
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Envio',
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,)),
                Spacer(),
                if (quote.shipping == null ||
                    quote.shipping!.total == 0)...[
                  Text('Gratis',
                      style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,)),
                ] else
                  ...[
                    Text(currencyFormat.format(quote.shipping!.total!),
                        style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,)),
                  ]
              ],
            ),
            SizedBox(height: 10,),
            Divider(
              height: 2,
              color: _gray,
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Total pedido',
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontSemiBold,)),
                Spacer(),
                Text('${currencyFormat.format(quote.totals!.total)} MXN',
                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontSemiBold,)),
              ],
            ),
          ],
        )
    );
  }

  Container _addSavings(QuoteModel quote){
    return Container(
        padding: const EdgeInsets.all(10),
        color: _energyYellow_20,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: SvgImage(
                svg: SVGIcons.prime_voltz_ico,
                width: 16,
                height: 16,
              ),
            ),
            SizedBox(width: 7,),
            Text(
              "¡Felicidades! Con este pedido estás ahorrando",
              style: TextStyle(color: _volcanic, fontSize: 13, font: _fontRegular,),
              textAlign: TextAlign.left,
            ),
            SizedBox(width: 5),
            Text(
              currencyFormat.format(quote.totals!.saving),
              style: TextStyle(color: _volcanic, fontSize: 13, font: _fontRegular,),
              textAlign: TextAlign.left,
            ),
          ],
        )
    );
  }

  Container _detailFirstPage(QuoteModel quote){
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "${quote.detail!.length} Productos incluidos",
                    style: TextStyle(color: _volcanic, fontSize: 18, font: _fontSemiBold,),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Descarga este listado en Excel y las fichas técnicas en la ",
                        style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                      ),
                      UrlLink(
                          child: Text(
                            "versión digital de este pedido.",
                            style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,),
                          ),
                          destination: "${_config.appUrl}?cotz=${quote.id!}"
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _product(0),
                SizedBox(height: 1),
                if(selectedProducts.length > 1) ...[
                  _product(1),
                ],
              ],
            ),
          ),
          if(selectedProducts.length > 2) ...[
            _next(endMargin: 20),
          ],
        ],
      ),
    );
  }

  Container _next({double endMargin = 0}){
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, right: endMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Continua en la siguiente página",
            style: TextStyle(color: _volcanic, fontSize: 12, font: _fontRegular,),
          ),
          SizedBox(width: 10),
          SvgImage(
            svg: SVGIcons.icon_next,
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }

  Container _product(int productIndex) {
    return Container(
      color: _white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedProducts[productIndex].skuDescription!.capitalize(),
            style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                selectedProducts[productIndex].brand!.capitalize(),
                style: TextStyle(color: _volcanic, fontSize: 12, font: _fontSemiBold,),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              SizedBox(width: 11),
              Text(
                selectedProducts[productIndex].sku!,
                style: TextStyle(color: _volcanic, fontSize: 12, font: _fontSemiBold,),
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ]
          ),
          SizedBox(height: 5),
          Row(
              children: [
                SvgImage(svg: SVGIcons.icon_price, width: 16, height: 16 ),
                SizedBox(width: 5),
                Text(
                  currencyFormat.format(selectedProducts[productIndex].pricePublic!),
                  style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,
                      decoration: TextDecoration.lineThrough),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                SizedBox(width: 5),
                Text(
                  currencyFormat.format(selectedProducts[productIndex].price!.price2!),
                  style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                SizedBox(width: 2),
                Text(
                  selectedProducts[productIndex].saleUnit!.capitalize(),
                  style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Spacer(),
                SizedBox(width: 5),
                SvgImage(svg: SVGIcons.icon_cart, width: 16, height: 16 ),
                SizedBox(width: 5),
                Text(
                  '${selectedProducts[productIndex].quantity} ${selectedProducts[productIndex].saleUnit!.capitalize()}(s)',
                  style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                SizedBox(width: 5),
                SvgImage(svg: SVGIcons.icon_total, width: 16, height: 16 ),
                SizedBox(width: 5),
                Text(
                  currencyFormat.format(selectedProducts[productIndex].total!.afterDiscount!),
                  style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
          ),
        ],
      ),
    );
  }

  Container _paymentDetails() {
    double ticket_width = 250;
    return Container(
      color: _background,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Container(
            color: _blue,
            height: 250,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Realiza tu pago. Después de confirmar tu pedido.',
                        style: TextStyle(color: _white, fontSize: 24, font: _fontSemiBold,),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Otras formas de pago',
                            style: TextStyle(color: _white, fontSize: fontSizeParagraph, font: _fontSemiBold,),
                            maxLines: 3,
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              children: [
                                Image(
                                  _visa_image,
                                  height: 20,
                                  width: 60,
                                ),
                                SizedBox(width: 6.67),
                                Image(
                                  _amex_image,
                                  height: 20,
                                  width: 60,
                                ),
                                SizedBox(width: 6.67),
                                Image(
                                  _paypal_image,
                                  height: 20,
                                  width: 60,
                                ),
                                SizedBox(width: 6.67),
                                SvgImage(
                                  svg: SVGIcons.icon_cash,
                                  height: 20,
                                  width: 60,
                                ),
                              ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
                              margin: const EdgeInsets.all(0),
                              width: ticket_width,
                              color:  _white,
                              child:  Text("Transferencia electrónica",
                                style: TextStyle(color: _volcanic, fontSize: 14, font: _fontSemiBold,),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: ticket_width,
                              height: 16,
                              child: SvgImage(
                                svg: SVGIcons.icon_lines,
                                width: ticket_width,
                                height: 16,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
                              width: ticket_width,
                              color: _white,
                              child:  Row(
                                children: [
                                  Container(
                                    child: Text("Banco destino",
                                      style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text("BBVA",
                                      style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const  EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
                              width: ticket_width,
                              color: _white,
                              child:  Row(
                                children: [
                                  Container(
                                    child: Text("No. Cuenta",
                                      style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text("0119621431",
                                      style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                              width: ticket_width,
                              color: _white,
                              child:  Row(
                                children: [
                                  Container(
                                    child: Text("CLABE",
                                      style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    child: Text("012320001196214312",
                                      style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /*Container(
                            padding: const  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                            width: ticket_width,
                            color:  _white,
                            child:  Row(
                              children: [
                                Container(
                                  child: Text("Concepto",
                                    style: TextStyle(color: _volcanic, fontSize: fontSizeParagraph, font: _fontRegular,),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Text("9998",
                                    style: TextStyle(color: _blue, fontSize: fontSizeParagraph, font: _fontRegular,),
                                  ),
                                )
                              ],
                            ),
                          ),*/
                            Container(
                              margin: const EdgeInsets.all(0),
                              width: ticket_width,
                              height: 16,
                              child: SvgImage(
                                svg: SVGIcons.icon_union,
                                width: ticket_width,
                                height: 16,
                                fit:  BoxFit.fitWidth,
                              ),
                            ),
                          ]
                      ),
                    ),
                ),
              ],
            ),
          ),
          Container(
            color: _white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SvgImage(
                  svg: SVGIcons.icon_business,
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 5),
                Text(
                  'Voltz México SAPI de CV\nVME221026G21',
                  style: TextStyle(color: _volcanic, fontSize: 10, font: _fontRegular,),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Spacer(),
                SvgImage(
                  svg: SVGIcons.icon_location,
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 5),
                Text(
                  'Carretera a Nogales 9005 Int. D15, Diana\nNatura, Zapopan Jalisco, México. CP 45221',
                  style: TextStyle(color: _volcanic, fontSize: 10, font: _fontRegular,),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Spacer(),
                SvgImage(
                  svg: SVGIcons.icon_phone,
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 5),
                Text(
                  '+52 33 1307 8145\nventas@voltz.mx',
                  style: TextStyle(color: _volcanic, fontSize: 10, font: _fontRegular,),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _uploadFile(Uint8List bytes) async {
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('public')
        .child('cotizaciones_pdf')
        .child(quote.customer!.id!)
        .child('cotizacion_voltz_${quote.consecutive}.pdf');

    final metadata = SettableMetadata(
      contentType: 'application/pdf',
      customMetadata: {
        'por': "Voltz",
        'cotización No.': quote.consecutive.toString(),
        'id cotización': quote.id!,
        'alias': quote.alias!,
        'pais': "Mexico"
      },
    );
  print('linea 10');
    String? url;
    try {
      TaskSnapshot uploadTaskSnapshot = await ref.putData(bytes, metadata);
      var imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      url = imageUri.toString();
    } on FirebaseException catch (e) {
      // ...
    }

    return url;
  }

  Future<void> _openPdf(String url) async {
    js.context.callMethod('open', [url]);
  }

}




