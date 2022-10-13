

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/order/order_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../utils/stats.dart';
import '../app/app.locator.dart';

class OrderViewModel  extends BaseViewModel {

  final NavigationService _navigationService = locator<NavigationService>();

  OrderModel? order;
  String _orderId = "";

  init(String quoteId) {
    _orderId = quoteId;
    _listenChanges();
    Stats.OrderViewed( _orderId);
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
