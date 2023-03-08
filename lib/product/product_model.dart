import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String? sku;
  String? skuDescription;
  String? brand;
  String? techFile;
  double? quantity = 1;
  double? saleValue;
  String? saleUnit;
  double? pricePublic;
  String? priceCurrency;
  String? coverImage;
  Total? total;
  String? source;
  String? brandFavicon;
  Price? price;
  List<String>? imageUrls;
  String? status;
  String? warranty;
  List<String>? features;
  String? featuresString;
  String? makerWeb;
  bool? selected;
  BestSupplier? bestSupplier;

  /** these are for local propose **/
  int? cardIndex;
  String? productRequestedId;
  bool isCardExpanded = false;
  bool isCalculatingProductTotals = false;
  double? discountRate;

  Product(
      {this.id,
      this.techFile,
      this.sku,
      this.skuDescription,
      this.brand,
      this.quantity = 1,
      this.saleValue,
      this.saleUnit,
      this.pricePublic,
      this.priceCurrency,
      this.coverImage,
      this.total,
      this.source,
      this.brandFavicon,
      this.price,
      this.imageUrls,
      this.status,
      this.warranty,
      this.features,
      this.featuresString,
      this.makerWeb,
      this.selected,
      this.bestSupplier});

  Product.fromJsonWithId({
    required Map<String, dynamic> json,
    required String id,
  }) {
    this.id = id;
    _fillFields(json);
  }

  Product.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('objectID')) {
      this.id = json['objectID'];
    } else {
      print('EEEEEEEEEEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOORRRRRRRRR');
    }
    _fillFields(json);
  }

  static Product copyWith(
    Map<String, dynamic> json,
    String id,
  ) {
    return Product.fromJsonWithId(json: json, id: id);
  }

  _fillFields(
    Map<String, dynamic> json,
  ) {
    sku = json['sku'];
    skuDescription = json['sku_description'];

    if (json.containsKey('brand')) {
      brand = json['brand'];
    }
    if (json.containsKey('tech_file')) {
      techFile = json['tech_file'];
    }
    if (json.containsKey('sale_value')) {
      saleValue = double.tryParse(json['sale_value'].toString());
    }
    if (json.containsKey('sale_unit')) {
      saleUnit = json['sale_unit'];
    }
    if (json.containsKey('price_public')) {
      pricePublic = double.tryParse(json['price_public'].toString());
    }
    if (json.containsKey('price_currency')) {
      priceCurrency = json['price_currency'];
    }
    if (json.containsKey('image_cover')) {
      coverImage = json['image_cover'];
    }
    if (json.containsKey('quantity')) {
      quantity = double.tryParse(json['quantity'].toString());
    }
    if (json.containsKey('price') && json['price'] != null) {
      price = Price.fromJson(json['price']);
    }
    if (json.containsKey('total') && json['total'] != null) {
      total = Total.fromJson(json['total']);
    }
    //se omite la primera imagen la cual es la misma que cover image
    if (json.containsKey('image_urls') && json['image_urls'] != null) {
      imageUrls = <String>[];
      for (int a = 0; a < json['image_urls'].length; a++) {
        if (a > 0) {
          imageUrls!.add(json['image_urls'][a]);
        }
      }
    }
    if (json.containsKey('status')) {
      status = json['status'];
    }
    if (json.containsKey('warranty')) {
      warranty = json['warranty'];
    }
    if (json.containsKey('features') && json['features'] != null && json['features'].length > 0) {
      features = <String>[];
      for (int a = 0; a < json['features'].length; a++) {
        features!.add(json['features'][a]);
        if (a == 0) {
          featuresString = json['features'][a].toString();
        } else {
          featuresString = "${featuresString!}, ${json['features'][a]}";
        }
      }
    } else {
      featuresString = null;
    }
    if (json.containsKey('maker_web')) {
      makerWeb = json['maker_web'];
    }
    if (json.containsKey('best_supplier')) {
      bestSupplier = BestSupplier.fromJson(json['best_supplier']);
    }
    if (json.containsKey('price') && json.containsKey('price_public') && price != null && price!.price2 != null && pricePublic != null) {
      discountRate = ((pricePublic! - price!.price2!) / pricePublic!) * 100;
      if(pricePublic == 0){
        pricePublic = price!.priceBest! * 1.66;
      }
    } else if (json.containsKey('best_supplier') && json.containsKey('price_public') && bestSupplier != null && bestSupplier!.price1 != null && pricePublic != null) {
      discountRate = ((pricePublic! - bestSupplier!.price1!) / pricePublic!) * 100;
      if(pricePublic == 0){
        pricePublic = bestSupplier!.priceBest! * 1.66;
      }
    }
    if (json.containsKey('brand_favicon')) {
      brandFavicon = json['brand_favicon'];
    }
    if (json.containsKey('selected')) {
      selected = json['selected'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.sku != null) {
      data['sku'] = this.sku!;
    }
    if (this.skuDescription != null) {
      data['sku_description'] = this.skuDescription!;
    }
    if (this.brand != null) {
      data['brand'] = this.brand!;
    }
    if (this.techFile != null) {
      data['tech_file'] = this.techFile!;
    }
    if (this.saleValue != null) {
      data['sale_value'] = this.saleValue!;
    }
    if (this.saleUnit != null) {
      data['sale_unit'] = this.saleUnit!;
    }
    if (this.pricePublic != null) {
      data['price_public'] = this.pricePublic!;
    }
    if (this.coverImage != null) {
      data['image_cover'] = this.coverImage!;
    }

    if (this.quantity != null) {
      data['quantity'] = this.quantity!;
    }
    if (this.price != null) {
      data['price'] = this.price!.toMap();
    }
    if (this.source != null) {
      data['source'] = this.source!;
    }
    if (this.imageUrls != null) {
      data['image_urls'] = this.imageUrls!.map((v) => v).toList();
    }
    if (this.status != null) {
      data['status'] = this.status!;
    }
    if (this.warranty != null) {
      data['warranty'] = this.warranty!;
    }
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v).toList();
    }
    if (this.makerWeb != null) {
      data['maker_web'] = this.makerWeb;
    }
    if (this.total != null) {
      data['total'] = this.total!.toMap();
    }
    if (this.brandFavicon != null) {
      data['brand_favicon'] = this.brandFavicon!;
    }
    if (this.selected != null) {
      data['selected'] = this.selected!;
    }
    if (this.bestSupplier != null) {
      data['best_supplier'] = this.bestSupplier!.toMap();
    }
    return data;
  }
}

class BestSupplier {
  double? priceBest;
  double? price1;
  String? supplierCode;

  BestSupplier({this.priceBest = 0, this.price1 = 0, this.supplierCode,});

  BestSupplier.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('price_best')) {
      priceBest = json['price_best'] * 1.0;
    }
    if (json.containsKey('price_1')) {
      price1 = json['price_1'] * 1.0;
    }
    if (json.containsKey('supplier_code')) {
      supplierCode = json['supplier_code'];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceBest != null) {
      data['price_best'] = this.priceBest;
    }
    if (this.price1 != null) {
      data['price_1'] = this.price1;
    }
    if (this.supplierCode != null) {
      data['supplier_code'] = this.supplierCode;
    }
    return data;
  }
}

class Price {
  double? priceBest;
  double? price1;
  double? price2;
  String? currency;
  double? stock;
  String? supplierCode;
  String? supplierName;
  DollarConversion? dollarConversion;

  Price({this.priceBest = 0, this.price1 = 0, this.price2 = 0, this.currency, this.stock = 0, this.supplierCode, this.supplierName, this.dollarConversion});

  Price.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('price_best')) {
      priceBest = json['price_best'] * 1.0;
    }
    if (json.containsKey('price_1')) {
      price1 = json['price_1'] * 1.0;
    }
    if (json.containsKey('price_2')) {
      price2 = json['price_2'] * 1.0;
    }
    if (json.containsKey('currency')) {
      currency = json['currency'];
    }
    if (json.containsKey('stock')) {
      stock = json['stock'] * 1.0;
    }
    if (json.containsKey('supplier_code')) {
      supplierCode = json['supplier_code'];
    }
    if (json.containsKey('supplier_name')) {
      supplierName = json['supplier_name'];
    }
    if (json.containsKey('dollar_conversion')) {
      dollarConversion = DollarConversion.fromJson(json['dollar_conversion']);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priceBest != null) {
      data['price_best'] = this.priceBest;
    }
    if (this.price1 != null) {
      data['price_1'] = this.price1;
    }
    if (this.price2 != null) {
      data['price_2'] = this.price2;
    }
    if (this.currency != null) {
      data['currency'] = this.currency;
    }
    if (this.stock != null) {
      data['stock'] = this.stock;
    }
    if (this.dollarConversion != null) {
      data['dollar_conversion'] = this.dollarConversion!.toMap();
    }
    if (this.supplierCode != null) {
      data['supplier_code'] = this.supplierCode;
    }
    if (this.supplierName != null) {
      data['supplier_name'] = this.supplierName;
    }
    if (this.dollarConversion != null) {
      data['dollar_conversion'] = this.dollarConversion!.toMap();
    }
    return data;
  }
}

class DollarConversion {
  String? currency;
  double? value;
  String? source;
  Timestamp? date;

  DollarConversion({this.currency, this.value, this.source, this.date});

  DollarConversion.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('currency')) {
      currency = json['currency'];
    }
    if (json.containsKey('value')) {
      value = json['value'];
    }
    if (json.containsKey('source')) {
      source = json['source'];
    }
    if (json.containsKey('date')) {
      date = json['date'];
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['value'] = this.value;
    data['source'] = this.source;
    data['date'] = this.date;
    return data;
  }
}

class Total {
  double? beforeDiscount = 0;
  double? afterDiscount = 0;
  double? discount = 0;

  Total({this.beforeDiscount = 0, this.afterDiscount = 0, this.discount = 0});

  Total.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('before_discount')) {
      beforeDiscount = json['before_discount'] * 1.0;
    }
    if (json.containsKey('after_discount')) {
      afterDiscount = json['after_discount'] * 1.0;
    }
    if (json.containsKey('discount')) {
      discount = json['discount'] * 1.0;
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['before_discount'] = this.beforeDiscount;
    data['after_discount'] = this.afterDiscount;
    data['discount'] = this.discount;
    return data;
  }
}
