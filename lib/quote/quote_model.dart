import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  String? id;
  String? customerId;
  String? alias;
  String? name;
  String? address;
  String? tel;
  double? subTotal;
  double? discount;
  double? tax;
  double? total;
  Timestamp? expirationDate;
  List<Detail>? detail;
  List<DiscardedProducts>? discardedProducts;

  QuoteModel(
      {this.id,
        this.customerId,
        this.alias,
        this.name,
        this.address,
        this.tel,
        this.subTotal,
        this.discount,
        this.tax,
        this.total,
        this.expirationDate,
        this.detail,
        this.discardedProducts});

  QuoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    alias = json['alias'];
    name = json['name'];
    address = json['address'];
    tel = json['tel'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    tax = json['tax'];
    total = json['total'];
    expirationDate = json['expiration_date'];
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
    data['customer_id'] = this.customerId;
    data['alias'] = this.alias;
    data['name'] = this.name;
    data['address'] = this.address;
    data['tel'] = this.tel;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['expiration_date'] = this.expirationDate;
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
  String? baseName;
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
        this.baseName,
        this.sku,
        this.supplier,
        this.skuDescription,
        this.brand,
        this.subBrand,
        this.quantity,
        this.saleValue,
        this.saleUnit,
        this.salePrice,
        this.selected});

  ProductsSuggested.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    baseName = json['base_name'];
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
    data['base_name'] = this.baseName;
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