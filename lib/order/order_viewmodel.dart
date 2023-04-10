import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/order/order_model.dart';
import 'package:maketplace/utils/stats.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderViewModel extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();

  OrderModel? _order;
  OrderModel? get order => _order;

  String _orderId = "";

  init(String orderId) {
    _orderId = orderId;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      Future.delayed(
        const Duration(seconds: 0),
        () async {
          final args = LoginViewArguments(orderId: orderId);
          _navigationService.clearStackAndShow(Routes.loginView, arguments: args);
          return;
        },
      );
    } else {
      _listenChanges();
      Stats.OrderViewed(_orderId);
    }
  }

  OrderStatus _orderStatus = OrderStatus.inPayment;
  OrderStatus get ordderStatus => _orderStatus;

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('order-detail').doc(_orderId);
    reference.snapshots().listen((documentSnapshot) async {
      if (documentSnapshot.exists) {
        _order = OrderModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        notifyListeners();
      }
    });
  }
}

enum OrderStatus { initial, inPayment, inSend, finished }
