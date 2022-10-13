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
  Shipping? shipping;

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
        this.discardedProducts,
        this.shipping});

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
      detail!.sort((a, b) => a.position!.compareTo(b.position!));
    }
    if (json['discarded_products'] != null) {
      discardedProducts = <DiscardedProducts>[];
      json['discarded_products'].forEach((v) {
        discardedProducts!.add(new DiscardedProducts.fromJson(v));
      });
      discardedProducts!.sort((a, b) => a.position!.compareTo(b.position!));
    }
    if (json.containsKey('shipping') && json['shipping'] != null) {
      shipping = new Shipping.fromJson(json['shipping']);
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
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toMap();
    }
    return data;
  }
}

class Detail {
  String? productRequested;
  List<ProductsSuggested>? productsSuggested;
  int? position;

  Detail({this.productRequested, this.productsSuggested, this.position});

  Detail.fromJson(Map<String, dynamic> json) {
    productRequested = json['product_requested'];
    position = json['position'];
    if (json['products_suggested'] != null) {
      productsSuggested = <ProductsSuggested>[];
      for(int a = 0; a < json['products_suggested'].length; a++) {
        productsSuggested!.add(new ProductsSuggested.fromJson(json['products_suggested'][a]));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_requested'] = this.productRequested;
    if (this.productsSuggested != null) {
      data['products_suggested'] =
          this.productsSuggested!.map((v) => v.toJson()).toList();
    }
    data['position'] = this.position;
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
  String? techFile;
  double? quantity;
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
        this.selected,});

  ProductsSuggested.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sku = json['sku'];
    supplier = json['supplier'];
    skuDescription = json['sku_description'];
    brand = json['brand'];
    subBrand = json['sub_brand'];
    techFile = json.containsKey("tech_file") ? json['tech_file'] : null;
    quantity = double.tryParse(json['quantity'].toString());
    saleValue = double.tryParse(json['sale_value'].toString());
    saleUnit = json['sale_unit'];
    salePrice = double.tryParse(json['sale_price'].toString());
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
    data['tech_file'] = this.techFile;
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
  int? position;

  DiscardedProducts({this.requestedProducts, this.reason, this.position});

  DiscardedProducts.fromJson(Map<String, dynamic> json) {
    requestedProducts = json['requested_products'];
    reason = json['reason'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requested_products'] = this.requestedProducts;
    data['reason'] = this.reason;
    data['position'] = this.position;
    return data;
  }
}

class Shipping {
  double? total;

  Shipping({this.total,});

  Shipping.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}