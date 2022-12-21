
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/order/order_model.dart' as OrderModel;
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/pdf_quote/quote_to_pdf.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart' as intl;
import '../app/app.locator.dart';
import '../utils/custom_colors.dart';
import '../utils/style.dart';
import '../utils/stats.dart';

class QuoteViewModel  extends ReactiveViewModel  {
  final _quoteService = locator<QuoteService>();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_quoteService,];

  QuoteModel get quote => _quoteService.quote;
  String _quoteId = "";
  String? version;
  bool isSaveActive = false;

  int documentLimit = 20;
  QueryDocumentSnapshot? lastDocument = null;
  ScrollController scrollController = ScrollController();
  late DocumentSnapshot postByUser;
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  init(String quoteId, String? version) async {
    _quoteId = quoteId;
    this.version = version;
    initReference();
    _quoteService.init(quoteId, version);
    return notifyListeners();
  }

  initConfirmation(String quoteId, String? version) async {
    _quoteId = quoteId;
    this.version = version;
    initReference();
    return notifyListeners();
  }

  late DocumentReference reference;

  initReference(){
    if(version == "original"){
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId).collection('version').doc(_quoteId);
    } else {
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    }
  }

  List<ProductsSuggested> get selectedProducts => _quoteService.selectedProducts;

  Future<void> navigateToQuoteConfirmation() async {
    return _navigationService.navigateToCartConfirmation(quoteId: quote.id!, version: version);
  }

  Future<void> navigateToQuoteView() async {
    return _navigationService.navigateToCartView(quoteId: quote.id!, version: version);
  }
/*
  Future<bool> updateDetail(int i, int b, double newQuantity) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    await reference.update({
      "detail": FieldValue.arrayRemove([quote.detail![i].toJson()]),
    }).whenComplete(() {
      quote.detail![i].productsSuggested![b].quantity = newQuantity;
      reference.update({
        "detail": FieldValue.arrayUnion([quote.detail![i].toJson()]),
      });
    });
    return true;
  }*/

  void onGenerateOrder(BuildContext context) async {
    saveQuote(quote).then((value) async {
        DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
        await reference.update({'accepted': true});
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SelectableText("Gracias, hemos recibido tu orden.", style: CustomStyles.styleVolcanicDos,),
      backgroundColor: CustomColors.energyYellow,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 5000),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 40,
          right: 20,
          left: 20),
      onVisible: () async {

      },
    ));
    await _saveOrder(_generateOrderV2()); //se cambio a V2
    Stats.QuoteAccepted(_quoteId, quote.totals!.total!);
    //_navigationService.navigateToOrderView(orderId: quote.id!);
  }

  setQuantity(int i, int b, double quantity){
    quote.detail![i].productsSuggested![b].quantity = quantity;
  }

  Future<bool> saveQuote(QuoteModel quote) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(quote.id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(reference, quote.toJson());
    }).then(
          (value) => print("DocumentSnapshot successfully updated!" + quote.id! ),
      onError: (e) => print("Error updating document $e"),
    );
    return true;
  }

  // instruccion para que el backend calcule totales
  void calculateTotals(){
    quote.record!.nextAction = 'calculate_totals';
  }

  void loadingAll (int productIndex) {
    _quoteService.loadingAll(productIndex);
  }

  void loadingTotals () {
    _quoteService.loadingQuoteTotals();
  }

  Future<void> onDeleteSkuFromPending(PendingProduct value) async {
    quote.pendingProducts!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.requestedProduct, reason: "No lo quiero.", position: value.position));
    await saveQuote(quote);
    return Stats.SkuBorrado(quoteId: _quoteId, skuSuggested: null, productRequested: value.requestedProduct!,
        countProductsSuggested: 0);
  }

  Future<void> _saveOrder(OrderModel.OrderModel orderModel) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('order-detail').doc(_quoteId);
    reference.set({
      ...orderModel.toJson(),
      "created_at": FieldValue.serverTimestamp(),
    });
  }

  @deprecated
  OrderModel.OrderModel _generateOrder(){
    List<OrderModel.OrderDetail> orderDetailList = [];
    for(int i = 0; i <= quote.detail!.length - 1; i++) {
      OrderModel.OrderDetail orderDetail = OrderModel.OrderDetail();
      orderDetail.productRequested =  quote.detail![i].productRequested!;
      orderDetail.productsOrdered = [];
      for(int b = 0; b <= quote.detail![i].productsSuggested!.length - 1; b++){
        if(quote.detail![i].productsSuggested![b].selected == true) {
          orderDetail.productsOrdered!.add(OrderModel.ProductsOrdered(
            productId: quote.detail![i].productsSuggested![b].productId,
            sku: quote.detail![i].productsSuggested![b].sku,
            supplier: quote.detail![i].productsSuggested![b].supplier,
            skuDescription: quote.detail![i].productsSuggested![b].skuDescription,
            brand: quote.detail![i].productsSuggested![b].brand,
            //subBrand: quote.detail![i].productsSuggested![b].subBrand,
            quantity: quote.detail![i].productsSuggested![b].quantity,
            saleValue: quote.detail![i].productsSuggested![b].saleValue,
            saleUnit: quote.detail![i].productsSuggested![b].saleUnit,
            //salePrice: quote.detail![i].productsSuggested![b].salePrice,
          ));
        }
      }
      if(orderDetail.productsOrdered!.isNotEmpty){
        orderDetailList.add(orderDetail);
      }
    }
    if(quote.shipping != null){

    }

    OrderModel.OrderModel orderModel = OrderModel.OrderModel(
      customerId: quote.customerId,
      consecutive: 0,
      alias: quote.alias,
      detail: orderDetailList,
      shipping: quote.shipping != null ? OrderModel.Shipping(total: quote.shipping!.total) : null,
    );
    return orderModel;
  }

  OrderModel.OrderModel _generateOrderV2(){
    List<OrderModel.OrderDetail> orderDetailList = [];
    for(int i = 0; i <= quote.detail!.length - 1; i++) {
      OrderModel.OrderDetail orderDetail = OrderModel.OrderDetail();
      orderDetail.productRequested =  quote.detail![i].productRequested!;
      orderDetail.productsOrdered = [];
      for(int b = 0; b <= quote.detail![i].productsSuggested!.length - 1; b++){
        if(quote.detail![i].productsSuggested![b].selected == true) {
          orderDetail.productsOrdered!.add(OrderModel.ProductsOrdered(
            productId: quote.detail![i].productsSuggested![b].productId,
            sku: quote.detail![i].productsSuggested![b].sku,
            supplier: quote.detail![i].productsSuggested![b].supplier,
            skuDescription: quote.detail![i].productsSuggested![b].skuDescription,
            brand: quote.detail![i].productsSuggested![b].brand,
            coverImage: quote.detail![i].productsSuggested![b].coverImage,
            quantity: quote.detail![i].productsSuggested![b].quantity,
            price: quote.detail![i].productsSuggested![b].price != null ? OrderModel.Price.fromJson(quote.detail![i].productsSuggested![b].price!.toMap()) : null,
            total: quote.detail![i].productsSuggested![b].total != null ? OrderModel.Total.fromJson(quote.detail![i].productsSuggested![b].total!.toMap()) : null,
          ));
        }
      }
      if(orderDetail.productsOrdered!.isNotEmpty){
        orderDetailList.add(orderDetail);
      }
    }

    OrderModel.OrderModel orderModel = OrderModel.OrderModel(
      consecutive: 0,
      alias: quote.alias,
      totals: quote.totals != null ? OrderModel.Totals.fromJson(quote.totals!.toMap()) : null,
      shipping: quote.shipping != null ? OrderModel.Shipping.fromJson(quote.shipping!.toMap()) : null,
      detail: orderDetailList,
      customer: quote.customer != null ? OrderModel.Customer.fromJson(quote.customer!.toMap()) : null,
    );
    return orderModel;
  }

  String createConfirmMessage(){
    String? message;
    for(int i = 0; i <= quote.detail!.length - 1; i++) {
      bool indicator = false;
      for(int b = 0; b <= quote.detail![i].productsSuggested!.length - 1; b++){
        if(quote.detail![i].productsSuggested![b].selected == true) {
          indicator = true;
        }
      }
      if(indicator == false){
        if(message == null){
          message = "${(i+1)}";
        } else {
          message = "$message, ${(i+1)}";
        }
      }
      indicator = false;
    }
    if(message == null){
      message = "¿Confirmas que deseas hacer el pedido?";
    } else {
      final List l = message.split(' ');
      if(l.length == 1){
        message = "La fila $message no tienen un producto asignado. ¿Deseas generar el pedido sin él?";
      } else {
        message = "Las filas $message no tienen un producto asignado. ¿Deseas generar el pedido sin ellos?";
      }
    }
    return message;

  }

  trackCSVExport(){
    Stats.ButtonClicked('Exportar CSV');
  }

  Future<void> generatePdf() async {
    QuotePdf quotePdf = QuotePdf(quote: quote, selectedProducts: selectedProducts);
    quotePdf.generatePdf();
  }

  final shimmerGradientWhiteBackground = const LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

}