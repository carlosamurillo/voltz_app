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

  StepStatus _stepStatus = StepStatus.initial;
  StepStatus get stepStatus => _stepStatus;

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

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('order-detail').doc(_orderId);
    reference.snapshots().listen((documentSnapshot) async {
      if (documentSnapshot.exists) {
        _order = OrderModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        _stepStatus = _getStepStatus(_order?.paymentStatus, _order?.shipping);
        notifyListeners();
      }
    });
  }

  StepStatus _getStepStatus(PaymentStatus? paymentStatus, Shipping? orderShipping) {
    switch (orderShipping?.status) {
      case ShippingStatus.processing:
        return StepStatus.shippingProcessing;
      case ShippingStatus.shipped:
        return StepStatus.shippingShipped;
      case ShippingStatus.delivered:
        return StepStatus.shippingDelivered;
      default:
        break;
    }

    switch (paymentStatus) {
      case PaymentStatus.pending:
        return StepStatus.pendingPayment;
      case PaymentStatus.verifying:
        return StepStatus.verifyingPayment;
      case PaymentStatus.paid:
        return StepStatus.paymentDone;
      default:
        break;
    }

    return StepStatus.initial;
  }

  Future<void> updatePaymentStatus(PaymentStatus status) async {
    final orderRef = FirebaseFirestore.instance.collection('order-detail').doc(_orderId);
    final result = await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(orderRef);
      final data = snapshot.data();
      final updatedData = Map<String, dynamic>.from(data!);
      updatedData['payment_status'] = _enumPaymentStatusToString(status);
      transaction.update(orderRef, updatedData);
      return updatedData;
    });
    print('Updated order detail: $result');
  }
}

String _enumPaymentStatusToString(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.pending:
      return 'pending';
    case PaymentStatus.verifying:
      return 'verifying';
    case PaymentStatus.paid:
      return 'paid';
    default:
      throw ArgumentError('Invalid payment status');
  }
}

enum StepStatus { initial, pendingPayment, verifyingPayment, paymentDone, shippingProcessing, shippingShipped, shippingDelivered }
