

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/order/order_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';

class OrderViewModel  extends BaseViewModel {

  final NavigationService _navigationService = locator<NavigationService>();

  OrderModel? order;
  String _orderId = "";

  init(String quoteId) {
    _orderId = quoteId;
    _listenChanges();
  }

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection(
        'order-detail').doc(_orderId);
    reference.snapshots().listen((documentSnapshot) async {
      if (documentSnapshot.exists) {
        order = OrderModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>,
            documentSnapshot.id);
        notifyListeners();
      }
    });
  }
}
