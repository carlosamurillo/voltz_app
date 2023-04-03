import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  int? version = 2;
  String? id;
  int? consecutive;
  String? alias;
  Timestamp? createdAt;
  List<OrderDetail>? detail;
  Shipping? shipping;
  String? paymentStatus;
  String? quoteCategory;
  Totals? totals = Totals();
  Customer? customer = Customer();

  OrderModel({
    this.id,
    this.consecutive,
    this.alias,
    this.createdAt,
    this.detail,
    this.shipping,
    this.paymentStatus = 'pending',
    this.quoteCategory,
    this.totals,
    this.customer,
  });

  OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    consecutive = json['consecutive'];
    alias = json['alias'];
    createdAt = json['created_at'];
    if (json['detail'] != null) {
      detail = <OrderDetail>[];
      json['detail'].forEach((v) {
        detail!.add(new OrderDetail.fromJson(v));
      });
    }
    if (json.containsKey('shipping') && json['shipping'] != null) {
      shipping = new Shipping.fromJson(json['shipping']);
    }
    paymentStatus = json['payment_status'];
    quoteCategory = json['quote_category'];
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
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toMap();
    }
    data['payment_status'] = this.paymentStatus;
    data['quote_category'] = this.quoteCategory;
    if (this.totals != null) {
      data['totals'] = this.totals!.toMap();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toMap();
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
      data['products_ordered'] = this.productsOrdered!.map((v) => v.toJson()).toList();
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
  double? quantity;
  double? saleValue;
  String? saleUnit;
  String? coverImage;
  Price? price = Price();
  Total? total = Total();

  ProductsOrdered(
      {this.productId, this.sku, this.supplier, this.skuDescription, this.brand, this.quantity = 0, this.saleValue, this.saleUnit, this.coverImage, this.price, this.total});

  ProductsOrdered.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sku = json['sku'];
    supplier = json['supplier'];
    skuDescription = json['sku_description'];
    brand = json['brand'];
    quantity = double.tryParse(json['quantity'].toString());
    saleValue = double.tryParse(json['sale_value'].toString());
    saleUnit = json['sale_unit'];
    coverImage = json['image_cover'];
    if (json.containsKey('price')) {
      price = Price.fromJson(json['price']);
    }
    if (json.containsKey('total')) {
      total = Total.fromJson(json['total']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    data['supplier'] = this.supplier;
    data['sku_description'] = this.skuDescription;
    data['brand'] = this.brand;
    data['quantity'] = this.quantity;
    data['sale_value'] = this.saleValue;
    data['sale_unit'] = this.saleUnit;
    data['image_cover'] = this.coverImage;
    if (this.price != null) {
      data['price'] = this.price!.toMap();
    }
    if (this.price != null) {
      data['total'] = this.total!.toMap();
    }
    return data;
  }
}

class Shipping {
  double? total;

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
    discount = json['discount'];
    factorDiscount = json['factor_discount'];
    subTotal = json['sub_total'];
    tax = json['tax'];
    total = json['total'];
    saving = json['saving'];
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

class Price {
  double? priceBest;
  double? pricePublic;
  double? price1;
  double? price2;

  Price({this.priceBest = 0, this.pricePublic = 0, this.price1, this.price2 = 0});

  Price.fromJson(Map<String, dynamic> json) {
    priceBest = json['price_best'];
    pricePublic = json['price_public'];
    price1 = json['price_1'];
    price2 = json['price_2'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_best'] = this.priceBest;
    data['price_public'] = this.pricePublic;
    data['price_1'] = this.price1;
    data['price_2'] = this.price2;
    return data;
  }
}

class Total {
  double? beforeDiscount;
  double? afterDiscount;
  double? discount;

  Total({this.beforeDiscount = 0, this.afterDiscount = 0, this.discount = 0});

  Total.fromJson(Map<String, dynamic> json) {
    beforeDiscount = json['before_discount'];
    afterDiscount = json['after_discount'];
    discount = json['discount'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['before_discount'] = this.beforeDiscount;
    data['after_discount'] = this.afterDiscount;
    data['discount'] = this.discount;
    return data;
  }
}
