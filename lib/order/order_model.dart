import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
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
  Timestamp? createdAt;
  List<OrderDetail>? detail;

  OrderModel(
      {this.id,
        this.customerId,
        this.alias,
        this.name,
        this.address,
        this.tel,
        this.subTotal = 0.0,
        this.discount = 0.0,
        this.tax = 0.0,
        this.total = 0.0,
        this.createdAt,
        this.detail,});

  OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    customerId = json['customer_id'];
    alias = json['alias'];
    name = json['name'];
    address = json['address'];
    tel = json['tel'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    tax = json['tax'];
    total = json['total'];
    createdAt = json['created_at'];
    if (json['detail'] != null) {
      detail = <OrderDetail>[];
      json['detail'].forEach((v) {
        detail!.add(new OrderDetail.fromJson(v));
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
    data['created_at'] = this.createdAt;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetail {
  String? productRequested;
  List<ProductsOrdered>? productsOrdered;

  OrderDetail({this.productRequested, this.productsOrdered});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    productRequested = json['product_requested'];
    if (json['products_ordered'] != null) {
      productsOrdered = <ProductsOrdered>[];
      json['products_ordered'].forEach((v) {
        productsOrdered!.add(new ProductsOrdered.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_requested'] = this.productRequested;
    if (this.productsOrdered != null) {
      data['products_ordered'] =
          this.productsOrdered!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductsOrdered {
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

  ProductsOrdered(
      {this.productId,
        this.sku,
        this.supplier,
        this.skuDescription,
        this.brand,
        this.subBrand,
        this.quantity = 0,
        this.saleValue,
        this.saleUnit,
        this.salePrice = 0.0,});

  ProductsOrdered.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

