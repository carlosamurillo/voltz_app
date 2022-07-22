import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  String? id;
  int? consecutive;
  String? customerId;
  String? alias;
  double? subTotal;
  double? discount;
  double? tax;
  double? total;
  Timestamp? createdAt;
  List<Detail>? detail;
  bool accepted = false;
  List<DiscardedProducts>? discardedProducts = <DiscardedProducts>[];

  QuoteModel(
      {this.id,
        this.consecutive,
        this.customerId,
        this.alias,
        this.subTotal = 0.0,
        this.discount = 0.0,
        this.tax = 0.0,
        this.total = 0.0,
        this.createdAt,
        this.detail,
        this.accepted = false,
        this.discardedProducts});

  QuoteModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    consecutive = json['consecutive'];
    customerId = json['customer_id'];
    alias = json['alias'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    tax = json['tax'];
    total = json['total'];
    createdAt = json['created_at'];
    accepted = json['accepted'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
    if (json['discarded_products'] != null) {
      discardedProducts = <DiscardedProducts>[];
      json['discarded_products'].forEach((v) {
        discardedProducts!.add(new DiscardedProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consecutive'] = this.consecutive;
    data['customer_id'] = this.customerId;
    data['alias'] = this.alias;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['accepted'] = this.accepted;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    if (this.discardedProducts != null) {
      data['discarded_products'] =
          this.discardedProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  String? productRequested;
  List<ProductsSuggested>? productsSuggested;

  Detail({this.productRequested, this.productsSuggested});

  Detail.fromJson(Map<String, dynamic> json) {
    productRequested = json['product_requested'];
    if (json['products_suggested'] != null) {
      productsSuggested = <ProductsSuggested>[];
      json['products_suggested'].forEach((v) {
        productsSuggested!.add(new ProductsSuggested.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_requested'] = this.productRequested;
    if (this.productsSuggested != null) {
      data['products_suggested'] =
          this.productsSuggested!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsSuggested {
  String? productId;
  String? sku;
  String? supplier;
  String? skuDescription;
  String? brand;
  String? subBrand;
  int? quantity;
  double? saleValue;
  String? saleUnit;
  double? salePrice;
  bool? selected;

  ProductsSuggested(
      {this.productId,
        this.sku,
        this.supplier,
        this.skuDescription,
        this.brand,
        this.subBrand,
        this.quantity = 0,
        this.saleValue,
        this.saleUnit,
        this.salePrice = 0.0,
        this.selected});

  ProductsSuggested.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sku = json['sku'];
    supplier = json['supplier'];
    skuDescription = json['sku_description'];
    brand = json['brand'];
    subBrand = json['sub_brand'];
    quantity = json['quantity'];
    saleValue = json['sale_value'];
    saleUnit = json['sale_unit'];
    salePrice = json['sale_price'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['supplier'] = this.supplier;
    data['sku_description'] = this.skuDescription;
    data['brand'] = this.brand;
    data['sub_brand'] = this.subBrand;
    data['quantity'] = this.quantity;
    data['sale_value'] = this.saleValue;
    data['sale_unit'] = this.saleUnit;
    data['sale_price'] = this.salePrice;
    data['selected'] = this.selected;
    return data;
  }
}

class DiscardedProducts {
  String? requestedProducts;
  String? reason;

  DiscardedProducts({this.requestedProducts, this.reason});

  DiscardedProducts.fromJson(Map<String, dynamic> json) {
    requestedProducts = json['requested_products'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requested_products'] = this.requestedProducts;
    data['reason'] = this.reason;
    return data;
  }
}