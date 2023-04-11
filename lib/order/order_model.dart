import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderModel {
  int? version = 2;
  String? id;
  int? consecutive;
  String? alias;
  DateTime? createdAt;
  Shipping? shipping;
  PaymentStatus? paymentStatus;
  Totals? totals = Totals();
  Customer? customer = Customer();
  String? quoteDetailId;

  OrderModel({
    this.id,
    this.consecutive,
    this.alias,
    this.createdAt,
    this.shipping,
    this.paymentStatus = PaymentStatus.initial,
    this.totals,
    this.customer,
    this.quoteDetailId,
  });

  OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    consecutive = json['consecutive'];
    alias = json['alias'];
    createdAt = _convertTimestampToLocal(json['created_at'] as Timestamp?);
    if (json.containsKey('shipping') && json['shipping'] != null) {
      shipping = new Shipping.fromJson(json['shipping']);
    }
    paymentStatus = strToPaymentStatus(json['payment_status']);
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

  PaymentStatus strToPaymentStatus(String? status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'verifying':
        return PaymentStatus.verifying;
      case 'paid':
        return PaymentStatus.paid;
      default:
        return PaymentStatus.initial;
    }
  }
}

class Shipping {
  int? total;
  ShippingStatus status = ShippingStatus.initial;
  DateTime? processedDate;
  DateTime? shippedDate;
  DateTime? deliveredDate;

  Shipping({
    this.total,
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    status = strToShippoingStatus(json['status']);
    processedDate = _convertTimestampToLocal(json['processed_date'] as Timestamp?);
    shippedDate = _convertTimestampToLocal(json['shipped_date'] as Timestamp?);
    deliveredDate = _convertTimestampToLocal(json['delivered_date'] as Timestamp?);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }

  ShippingStatus strToShippoingStatus(String? status) {
    switch (status) {
      case 'processed':
        return ShippingStatus.processing;
      case 'shipped':
        return ShippingStatus.shipped;
      case 'delivered':
        return ShippingStatus.delivered;
      default:
        return ShippingStatus.initial;
    }
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

//   Stream<List<Order>> get orderModelsStream =>
//       ordersStream.map((snapshot) => snapshot.map((doc) => Order.fromJson(doc.data())).toList());
// }

enum PaymentStatus { initial, pending, verifying, paid }

enum ShippingStatus { initial, processing, shipped, delivered }

DateTime? _convertTimestampToLocal(Timestamp? date) {
  if (date == null) return null;
  var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.toDate().toUtc().toString(), true);
  return dateTime.toLocal();
}
