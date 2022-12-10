

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/order/order_model.dart' as OrderModel;
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote/quote_stream.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../cart/socket_futures.dart';
import '../utils/custom_colors.dart';
import '../utils/style.dart';
import '../utils/stats.dart';

class QuoteViewModel  extends ReactiveViewModel  {
  QueueService queueService = QueueService();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [QuoteService(),];

  QuoteModel quote = QuoteModel();
  String _quoteId = "";
  String? version;
  bool isSaveActive = false;

  int documentLimit = 20;
  QueryDocumentSnapshot? lastDocument = null;
  ScrollController scrollController = ScrollController();
  late DocumentSnapshot postByUser;

  final shimmerGradient = const LinearGradient(
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
  final shimmerGradient2 = const LinearGradient(
    colors: [
      Color(0xFF4C5365),
      Color(0xFF4C5367),
      Color(0xFF4C5370),
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

  init(String quoteId, String? version) async {
    _quoteId = quoteId;
    this.version = version;
    initReference();
    await _getQuote();
    setLoading();
    _listenChanges();
    return notifyListeners();
  }

  initConfirmation(String quoteId, String? version) async {
    _quoteId = quoteId;
    this.version = version;
    initReference();
    await _getQuote();
    await _fillSelectedProductsList();
    setLoading();
    return notifyListeners();
  }

  bool isCalculatingProductTotal = true;
  bool isCalculatingQuoteTotals = true;
  bool viewRecorded = false;

  late DocumentReference reference;

  initReference(){
    if(version == "original"){
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId).collection('version').doc(_quoteId);
    } else {
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    }
  }

  Future<void> _getQuote() async {
    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      print('si existe data de quote, se guarda en primera consulta individual');
      quote = await processQuote(documentSnapshot);
    } else {
      quote = QuoteModel();
    }
  }

  Future<void> _listenChanges() async {
    reference.snapshots().listen(
          (documentSnapshot) async {
            print("Llego data nueva...1");
            if (documentSnapshot.exists) {
              QuoteModel data = await processQuote(documentSnapshot);
              print("Llego data nueva...");
              if (data.record != null && data.record!.nextAction == null) {
                quote = data;
                notifyListeners();
                print("se actualiza la pantalla");
              }
              print('Ult. cantidad recibida fue: ' + quote.detail![0].productsSuggested![0].quantity.toString());
            } else {
              quote = QuoteModel();
            }
            setLoading();
          },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  setLoading() {
    if (quote.record != null && quote.record!.nextAction == null) {
      isCalculatingProductTotal = false;
      isCalculatingQuoteTotals = false;
    } else {
      isCalculatingProductTotal = true;
      isCalculatingQuoteTotals = true;
    }
  }

  //factory Future.delayed(Duration duration, [FutureOr<QuoteModel> computation()?]) {
  Future<QuoteModel> processQuote(DocumentSnapshot documentSnapshot) async {
    quote = QuoteModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
    if(version == null && quote.accepted){
      Future.delayed(const Duration(milliseconds: 1500), () {
        _navigationService.navigateToOrderView(orderId: quote.id!);
      });
    } else if(!viewRecorded) {
      Stats.QuoteViewed(_quoteId);
      viewRecorded = true;
    }
    return quote;
  }

  List<ProductsSuggested> selectedProducts = [];
  Future<void> _fillSelectedProductsList() async {
    selectedProducts = [];
    quote.detail?.forEach((element) {
      element.productsSuggested?.forEach((element2) {
        if (element2.selected == true){
          selectedProducts.add(element2);
        }
      });
    });
  }

  Future<void> navigateToQuoteConfirmation() async {
    return _navigationService.navigateToQuoteConfirmation(quoteId: quote.id!, version: version);
  }

  Future<void> navigateToQuoteView() async {
    return _navigationService.navigateToQuoteView(quoteId: quote.id!, version: version);
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

  @deprecated
  Future<bool> saveQuote() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    await reference.set(quote.toJson());
    return true;
  }

  void onGenerateOrder(BuildContext context) async {
    _saveQuote(quote).then((value) async {
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

  Future<void> onUpdateQuote(int i, int b, double quantity) async {
    loadingAll();
    notifyListeners();
    setQuantity(i, b, quantity);
    calculateTotals();
    Future.delayed(const Duration(milliseconds: 0), () async {
      await _saveQuote(quote);
    });

  }

  Future<bool> _saveQuote(QuoteModel quote) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(quote.id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(reference, quote.toJson());
    }).then(
          (value) => print("DocumentSnapshot successfully updated!" + quote.id! ),
      onError: (e) => print("Error updating document $e"),
    );
    return true;
  }

  void loadingAll () {
    isCalculatingProductTotal = true;
    isCalculatingQuoteTotals = true;
  }

  void loadingQuoteTotals () {
    isCalculatingQuoteTotals = true;
  }

  // instruccion para que el backend calcule totales
  void calculateTotals(){
    quote.record!.nextAction = 'calculate_totals';
  }

  Future<void> onSelectedSku(bool value, int i, int b) async {
    loadingAll();
    notifyListeners();
    quote.detail![i].productsSuggested![b].selected = value;
    calculateTotals();
    await _saveQuote(quote);
    return Stats.SkuSeleccionado(quoteId: _quoteId, skuSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true,  orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: quote.detail![i].productRequested!,
        countProductsSuggested: quote.detail![i].productsSuggested!.length);
  }

  Future<void> onDeleteSku(Detail value) async {
    loadingQuoteTotals();
    notifyListeners();
    quote.detail!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.productRequested, reason: "No lo quiero.", position: value.position));
    calculateTotals();
    await _saveQuote(quote);
    return Stats.SkuBorrado(quoteId: _quoteId, skuSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: value.productRequested!,
        countProductsSuggested: value.productsSuggested!.length);
  }

  Future<void> onDeleteSkuFromPending(PendingProduct value) async {
    quote.pendingProducts!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.requestedProduct, reason: "No lo quiero.", position: value.position));
    await _saveQuote(quote);
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

}