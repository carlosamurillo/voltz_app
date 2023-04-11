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
  late bool _fromQuote;

  init(String orderId, bool fromQuote) {
    _orderId = orderId;
    _fromQuote = fromQuote;

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
    if (!_fromQuote) {
      DocumentReference reference = FirebaseFirestore.instance.collection('order-detail').doc(_orderId);
      reference.snapshots().listen((documentSnapshot) async {
        if (documentSnapshot.exists) {
          _order = OrderModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
          _stepStatus = _getStepStatus(_order?.paymentStatus, _order?.shipping);
          notifyListeners();
        }
      });
    } else {
      FirebaseFirestore.instance
          .collection('order-detail') //
          .where('quote_detail_id', isEqualTo: _orderId)
          .snapshots()
          .listen((s) {
        if (s.docs.isNotEmpty) {
          final snap = s.docs.first;
          _order = OrderModel.fromJson(snap.data(), snap.id);
          _orderId = snap.id;
          _stepStatus = _getStepStatus(_order?.paymentStatus, _order?.shipping);
          notifyListeners();
        }
      });
    }
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
    await orderRef.update({
      "payment_status": _enumPaymentStatusToString(status),
    });
    ;
    print('Updated order detail: true');
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
