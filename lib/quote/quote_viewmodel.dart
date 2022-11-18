

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/order/order_model.dart' as OrderModel;
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../utils/custom_colors.dart';
import '../utils/style.dart';
import '../utils/stats.dart';

class QuoteViewModel  extends ReactiveViewModel  {

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

  init(String quoteId, String? version) async {
    _quoteId = quoteId;
    this.version = version;
    _listenChanges();
  }

  bool isLoading = true;
  bool viewRecorded = false;
  void _listenChanges() async {

    DocumentReference reference;
    if(version == "original"){
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId).collection('version').doc(_quoteId);
    } else {
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    }

    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      quote = await processQuote(documentSnapshot);
    } else {
      quote = QuoteModel();
    }
    reference.snapshots().listen(
          (documentSnapshot) async {
            if (documentSnapshot.exists) {
              print("Listen success");
              quote = await processQuote(documentSnapshot);
              notifyListeners();
            } else {
              quote = QuoteModel();
            }

          },
      onError: (error) => print("Listen failed: $error"),
    );
  }

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

  
  void updateDetail(Detail detail) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    reference.update({
      "detail": FieldValue.arrayRemove([detail.toJson()]),
    }).whenComplete(() {
      reference.update({
        "detail": FieldValue.arrayUnion([detail.toJson()]),
      });
    });
  }

  Future<void> saveQuote() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    return reference.set(quote.toJson());
  }

  void onGenerateOrder(BuildContext context) async {
    saveQuote().then((value) async {
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
    await _saveOrder(_generateOrder());
    Stats.QuoteAccepted(_quoteId, quote.total!);
    //_navigationService.navigateToOrderView(orderId: quote.id!);
  }

  Future<void> onUpdateQuantity(int i, int b, double quantity) async {
    quote.detail![i].productsSuggested![b].quantity = quantity;
    calculateTotals();
    saveQuote();
  }

  // instruccion para que el backend calcule totales
  void calculateTotals(){
    quote.record!.nextAction = 'calculate_totals';
  }

  void onSelectedSku(bool value, int i, int b){
    quote.detail![i].productsSuggested![b].selected = value;
    calculateTotals();
    saveQuote();
    Stats.SkuSeleccionado(quoteId: _quoteId, skuSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true,  orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: quote.detail![i].productRequested!,
        countProductsSuggested: quote.detail![i].productsSuggested!.length);
  }

  void onDeleteSku(Detail value){
    quote.detail!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.productRequested, reason: "No lo quiero.", position: value.position));
    calculateTotals();
    saveQuote();
    Stats.SkuBorrado(quoteId: _quoteId, skuSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: value.productRequested!,
        countProductsSuggested: value.productsSuggested!.length);
  }

  void onDeleteSkuFromPending(PendingProduct value){
    quote.pendingProducts!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.requestedProduct, reason: "No lo quiero.", position: value.position));
    saveQuote();
    Stats.SkuBorrado(quoteId: _quoteId, skuSuggested: null, productRequested: value.requestedProduct!,
        countProductsSuggested: 0);
  }


  Future<void> _saveOrder(OrderModel.OrderModel orderModel) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('order-detail').doc(_quoteId);
    reference.set({
      ...orderModel.toJson(),
      "created_at": FieldValue.serverTimestamp(),
    });
  }


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
            subBrand: quote.detail![i].productsSuggested![b].subBrand,
            quantity: quote.detail![i].productsSuggested![b].quantity,
            saleValue: quote.detail![i].productsSuggested![b].saleValue,
            saleUnit: quote.detail![i].productsSuggested![b].saleUnit,
            salePrice: quote.detail![i].productsSuggested![b].salePrice,
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
      subTotal: quote.subTotal,
      discount: quote.discount,
      tax: quote.tax,
      total: quote.total,
      detail: orderDetailList,
      shipping: quote.shipping != null ? OrderModel.Shipping(total: quote.shipping!.total) : null,
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