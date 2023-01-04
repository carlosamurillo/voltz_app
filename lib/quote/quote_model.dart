import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  int? version = 2;
  String? id;
  int? consecutive;
  String? customerId;
  String? alias;
  Timestamp? createdAt;
  Timestamp? publishedAt;
  List<Detail>? detail;
  bool accepted = false;
  List<DiscardedProducts>? discardedProducts = <DiscardedProducts>[];
  Shipping? shipping;
  List<PendingProduct>? pendingProducts = <PendingProduct>[];
  Record? record = Record();
  String? quoteCategory;
  Totals? totals = Totals();
  Customer? customer = Customer();
  //this is only for local proposes
  bool isCalculatingTotals = false;

  QuoteModel(
      {this.version,
        this.id,
        this.consecutive,
        this.customerId,
        this.alias,
        this.createdAt,
        this.publishedAt,
        this.detail,
        this.accepted = false,
        this.discardedProducts,
        this.shipping,
      this.pendingProducts,
      this.record,
      this.quoteCategory,
      this.totals,
      this.customer,});

  QuoteModel.fromJson(Map<String, dynamic> json, String docId) {
    version = json['version'];
    id = docId;
    consecutive = json['consecutive'];
    customerId = json['customer_id'];
    alias = json['alias'];
    createdAt = json['created_at'];
    if (json.containsKey('published_at')) {
      publishedAt = json['published_at'];
    }
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
    if (json.containsKey('shipping') && json['shipping'] != null) {
      shipping = new Shipping.fromJson(json['shipping']);
    }
    if (json['arr_not_result'] != null) {
      pendingProducts = <PendingProduct>[];
      json['arr_not_result'].forEach((v) {
        pendingProducts!.add(new PendingProduct.fromJson(v));
      });
    }
    if (json.containsKey('record') && json['record'] != null) {
      record = Record.fromJson(json['record']);
    }
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
    data['version'] = this.version;
    data['consecutive'] = this.consecutive;
    data['customer_id'] = this.customerId;
    data['alias'] = this.alias;
    data['created_at'] = this.createdAt;
    if (this.publishedAt != null) {
      data['published_at'] = this.publishedAt;
    }
    data['accepted'] = this.accepted;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    if (this.discardedProducts != null) {
      data['discarded_products'] =
          this.discardedProducts!.map((v) => v.toMap()).toList();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toMap();
    }
    if (this.pendingProducts != null) {
      data['arr_not_result'] =
          this.pendingProducts!.map((v) => v.toJson()).toList();
    }
    if (this.record != null) {
      data['record'] = this.record!.toMap();
    }
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
    data['tax'] =  tax;
    data['total'] = total;
    data['saving'] = saving;
    return data;
  }
}

class Detail {
  String? productRequested;
  String? id;
  List<ProductsSuggested>? productsSuggested;
  int? position;
  //this is only for local proposes
  bool isCalculatingProductTotals = false;

  Detail({this.productRequested, this.id, this.productsSuggested, this.position,});

  Detail.fromJson(Map<String, dynamic> json) {
    productRequested = json['product_requested'];
    id = json['id'];
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
    if (this.id != null) {
      data['id'] = this.id!;
    }
    if (this.productsSuggested != null) {
      data['products_suggested'] =
          this.productsSuggested!.map((v) => v.toJson()).toList();
    }
    data['position'] = this.position;
    return data;
  }
}

class Record {
  String? nextAction;
  Record({this.nextAction});

  Record.fromJson(Map<String, dynamic> json) {
    nextAction = json['next_action'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next_action'] = this.nextAction;
    return data;
  }
}

class Price {
  double? priceBest;
  double? price1;
  double? price2;

  Price({this.priceBest = 0, this.price1, this.price2 = 0});

  Price.fromJson(Map<String, dynamic> json) {
    priceBest = json['price_best'];
    price1 = json['price_1'];
    price2 = json['price_2'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_best'] = this.priceBest;
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
  double? pricePublic;
  bool? selected;
  String? coverImage;
  Price? price = Price();
  Total? total = Total();
  String? source;

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
        this.pricePublic = 0.0,
        this.selected,
        this.coverImage,
      this.price,
      this.total,
      this.source});

  ProductsSuggested.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sku = json['sku'];
    supplier = json['supplier'];
    skuDescription = json['sku_description'];
    brand = json['brand'];
    subBrand = null;
    techFile = json.containsKey("tech_file") ? json['tech_file'] : null;
    quantity = double.tryParse(json['quantity'].toString());
    saleValue = double.tryParse(json['sale_value'].toString());
    saleUnit = json['sale_unit'];
    pricePublic = double.tryParse(json['price_public'].toString());
    selected = json['selected'];
    coverImage = json['image_cover'];
    if (json.containsKey('price')){
      price = Price.fromJson(json['price']);
    }
    print(json['total']);
    if (json.containsKey('total') && json['total'] != null){
      total = Total.fromJson(json['total']);
    }
    if (json.containsKey('source')){
      source = json['source'];
    }
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
    data['price_public'] = this.pricePublic;
    data['selected'] = this.selected;
    data['image_cover'] = this.coverImage;
    if (this.price != null) {
      data['price'] =
          this.price!.toMap();
    }
    if (this.total != null) {
      data['total'] =
          this.total!.toMap();
    }
    if (this.source != null) {
      data['source'] =
          this.source!;
    }
    return data;
  }
}

class DiscardedProducts {
  String? requestedProducts;
  String? reason;
  int? position;
  String? id;

  DiscardedProducts({this.requestedProducts, this.reason, this.position, this.id});

  DiscardedProducts.fromJson(Map<String, dynamic> json) {
    requestedProducts = json['requested_products'];
    reason = json['reason'];
    position = json['position'];
    id = json['id'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requested_products'] = this.requestedProducts;
    data['reason'] = this.reason;
    data['position'] = this.position;
    data['id'] = this.id;
    return data;
  }
}


class PendingProduct {
  String? requestedProduct;
  int? position;
  double? quantity;
  String? id;

  PendingProduct({this.requestedProduct, this.position, this.quantity = 0, this.id});

  PendingProduct.fromJson(Map<String, dynamic> json) {
    requestedProduct = json['requested_products'];
    position = json['position'];
    quantity = double.tryParse(json['quantity'].toString());
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requested_products'] = this.requestedProduct;
    data['position'] = this.position;
    data['quantity'] = this.quantity;
    data['id'] = this.id;
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


class Customer {
  String? id;
  String? category;

  Customer({this.id, this.category,});

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