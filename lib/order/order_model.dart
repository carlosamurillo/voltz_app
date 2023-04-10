import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  int? version = 2;
  String? id;
  int? consecutive;
  String? alias;
  Timestamp? createdAt;
  Shipping? shipping;
  String? paymentStatus;
  Totals? totals = Totals();
  Customer? customer = Customer();
  String? quoteDetailId;

  OrderModel({
    this.id,
    this.consecutive,
    this.alias,
    this.createdAt,
    this.shipping,
    this.paymentStatus = 'pending',
    this.totals,
    this.customer,
    this.quoteDetailId,
  });

  OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    consecutive = json['consecutive'];
    alias = json['alias'];
    createdAt = json['created_at'];
    if (json.containsKey('shipping') && json['shipping'] != null) {
      shipping = new Shipping.fromJson(json['shipping']);
    }
    paymentStatus = json['payment_status'];
    quoteDetailId = json['quote_detail_id'];
    if (json.containsKey('totals') && json['totals'] != null) {
      totals = Totals.fromJson(json['totals']);
    }
    if (json.containsKey('customer') && json['customer'] != null) {
      customer = Customer.fromJson(json['customer']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consecutive'] = this.consecutive;
    data['alias'] = this.alias;
    data['created_at'] = this.createdAt;
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toMap();
    }
    data['payment_status'] = this.paymentStatus;
    data['quote_detail_id'] = this.quoteDetailId;
    if (this.totals != null) {
      data['totals'] = this.totals!.toMap();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toMap();
    }
    return data;
  }
}

class Shipping {
  int? total;

  Shipping({
    this.total,
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}

class Totals {
  double? discount;
  double? factorDiscount;
  double? subTotal;
  double? tax;
  double? total;
  double? saving;

  Totals({this.discount = 0, this.factorDiscount = 0, this.subTotal = 0, this.tax = 0, this.total = 0, this.saving = 0});

  Totals.fromJson(Map<String, dynamic> json) {
    discount = double.tryParse(json['discount']?.toString() ?? '');
    factorDiscount = double.tryParse(json['factor_discount']?.toString() ?? '');
    subTotal = double.tryParse(json['sub_total']?.toString() ?? '');
    tax = double.tryParse(json['tax']?.toString() ?? '');
    total = double.tryParse(json['total']?.toString() ?? '');
    saving = double.tryParse(json['saving']?.toString() ?? '');
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = discount;
    data['factor_discount'] = factorDiscount;
    data['sub_total'] = subTotal;
    data['tax'] = tax;
    data['total'] = total;
    data['saving'] = saving;
    return data;
  }
}

class Customer {
  String? id;
  String? category;

  Customer({
    this.id,
    this.category,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    return data;
  }
}

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:your_app/models/order.dart';

// class OrderService {
//   final String documentId;

//   OrderService(this.documentId);

//   Stream<List<DocumentSnapshot>> get ordersStream =>
//       FirebaseFirestore.instance
//           .collection('order-detail')
//           .doc(documentId)
//           .snapshots()
//           .map((snapshot) => [snapshot]);

//   Future<void> updatePaymentStatus(PaymentStatus status) async {
//     final orderRef = FirebaseFirestore.instance.collection('order-detail').doc(documentId);
//     final result = await FirebaseFirestore.instance.runTransaction((transaction) async {
//       final snapshot = await transaction.get(orderRef);
//       final data = snapshot.data();
//       final updatedData = Map<String, dynamic>.from(data);
//       updatedData['payment_status'] = _enumToString(status);
//       transaction.update(orderRef, updatedData);
//       return updatedData;
//     });
//     print('Updated order detail: $result');
//   }

//   String _enumToString(PaymentStatus status) {
//     switch (status) {
//       case PaymentStatus.pending:
//         return 'pending';
//       case PaymentStatus.verifying:
//         return 'verifying';
//       case PaymentStatus.paid:
//         return 'paid';
//       default:
//         throw ArgumentError('Invalid payment status');
//     }
//   }

//   Stream<List<Order>> get orderModelsStream =>
//       ordersStream.map((snapshot) => snapshot.map((doc) => Order.fromJson(doc.data())).toList());
// }