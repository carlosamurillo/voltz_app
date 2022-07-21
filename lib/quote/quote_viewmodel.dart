
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';

class QuoteViewModel  extends ReactiveViewModel  {


  @override
  List<ReactiveServiceMixin> get reactiveServices => [QuoteService(),];
  final _quoteService = locator<QuoteService>();
  QuoteModel quote = QuoteModel();
  String _quoteId = "";
  bool isSaveActive = false;

  init(String quoteId) async {
    _quoteId = quoteId;
    _listenChanges();
  }

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    reference.snapshots().listen((documentSnapshot) async {
      print(documentSnapshot.data().toString());
      if (documentSnapshot.exists) {
        quote = QuoteModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        calculateTotals();
        notifyListeners();
      } else {
        quote = QuoteModel();
      }
    });
  }
  
  void saveNewQuantity(int i, int b, int quantity, Detail detail){
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    reference.update({
      "detail": FieldValue.arrayRemove([detail.toJson()]),
    }).whenComplete(() {
      onUpdateQuantity(i, b, quantity);
      reference.update({
        "detail": FieldValue.arrayUnion([detail.toJson()]),
      });
    });
  }

  void _activateSaveButton(){
    isSaveActive = true;
  }

  void _deactivateSaveButton(){
    isSaveActive = false;
  }

  void saveQuote(){
    _deactivateSaveButton();
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    reference.update(quote.toJson());
  }

  void onGenerateOrder(BuildContext context) async {
    saveQuote();
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_quoteId);
    reference.update({'accepted': true});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Gracias, hemos recibido tu orden.", style: CustomStyles.styleVolcanicDos,),
      backgroundColor: CustomColors.energyYellow,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 7000),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 40,
          right: 20,
          left: 20),
    ));
  }

  void onUpdateQuantity(int i, int b, int quantity) {
    quote.detail![i].productsSuggested![b].quantity = quantity;
    _activateSaveButton();
  }

  void onSelectedSku(bool value, int i, int b){
    quote.detail![i].productsSuggested![b].selected = value;
    _activateSaveButton();
  }

  void onDeleteSku(Detail value){
    quote.detail!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.productRequested, reason: "No lo quiero."));
    _activateSaveButton();
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
        message = "La fila $message no tienen un producto asignado. ¿Deseas generar el pedido sin ellos?";
      } else {
        message = "Las filas $message no tienen un producto asignado. ¿Deseas generar el pedido sin ellos?";
      }
    }
    return message;

  }

  void calculateTotals() {
    quote.subTotal = 0;
    quote.tax = 0.16;
    quote.total = 0;
    quote.discount = 0;
    for(int i = 0; i <= quote.detail!.length - 1; i++) {
      for(int b = 0; b <= quote.detail![i].productsSuggested!.length - 1; b++){
        if(quote.detail![i].productsSuggested![b].selected == true) {
          quote.subTotal = quote.subTotal! +
              (quote.detail![i].productsSuggested![b].quantity! *
                  quote.detail![i].productsSuggested![b].salePrice!);
        }
      }
    }
    quote.total = quote.subTotal! * (1 - quote.discount! ) * (1 + quote.tax!);
    print('_calculate Totals.... ${quote.total}');
  }

}