
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String? sku;
  String? skuDescription;
  String? brand;
  String? techFile;
  double? quantity;
  double? saleValue;
  String? saleUnit;
  double? pricePublic;
  String? priceCurrency;
  String? coverImage;
  Price? price = Price();
  String? source;
  List<String>? imageUrls;
  String? status;
  String? warranty;
  List<String>? features;
  String? featuresString;

  Product(
      {this.id,
        this.sku,
        this.skuDescription,
        this.brand,
        this.quantity,
        this.saleValue,
        this.saleUnit,
        this.pricePublic,
        this.priceCurrency,
        this.coverImage,
        this.price,
        this.source,
      this.imageUrls,
      this.status,
      this.warranty,
      this.features,
      this.featuresString});

  Product.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    sku = json['sku'];
    skuDescription = json['sku_description'];
    brand = json['brand'];
    techFile = json.containsKey("tech_file") ? json['tech_file'] : null;
    quantity = double.tryParse(json['quantity'].toString());
    saleValue = double.tryParse(json['sale_value'].toString());
    saleUnit = json['sale_unit'];
    pricePublic = double.tryParse(json['price_public'].toString());
    priceCurrency = json['price_currency'];
    coverImage = json['image_cover'];
    if (json.containsKey('price')){
      price = Price.fromJson(json['price']);
    }
    if (json.containsKey('source')){
      source = json['source'];
    }
    if (json['image_urls'] != null) {
      imageUrls = <String>[];
      for(int a = 0; a < json['image_urls'].length; a++) {
        imageUrls!.add(json['image_urls'][a]);
      }
    }
    if (json.containsKey('status')){
      status = json['status'];
    }
    if (json.containsKey('warranty')){
      warranty = json['warranty'];
    }
    if (json['features'] != null) {
      features = <String>[];
      for(int a = 0; a < json['features'].length; a++) {
        features!.add(json['features'][a]);
        if(a == 0){
          featuresString = json['features'][a].toString();
        } else {
          featuresString = "${featuresString!}, ${json['features'][a]}";
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['sku_description'] = this.skuDescription;
    data['brand'] = this.brand;
    data['tech_file'] = this.techFile;
    data['quantity'] = this.quantity;
    data['sale_value'] = this.saleValue;
    data['sale_unit'] = this.saleUnit;
    data['price_public'] = this.pricePublic;
    data['image_cover'] = this.coverImage;
    if (this.price != null) {
      data['price'] =
          this.price!.toMap();
    }
    if (this.source != null) {
      data['source'] =
      this.source!;
    }
    if (this.imageUrls != null) {
      data['image_urls'] =
          this.imageUrls!.map((v) => v).toList();
    }
    if (this.status != null) {
      data['status'] =
      this.status!;
    }
    if (this.warranty != null) {
      data['warranty'] =
      this.warranty!;
    }
    if (this.features != null) {
      data['features'] =
          this.features!.map((v) => v).toList();
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
    if(json.containsKey('price_best')) {
      priceBest = json['price_best'];
    }
    if(json.containsKey('price_1')) {
      price1 = json['price_1'];
    }
    if(json.containsKey('price_2')) {
      price2 = json['price_2'];
    }
    if(json.containsKey('currency')) {
      currency = json['currency'];
    }
    if(json.containsKey('stock')) {
      stock = json['stock'];
    }
    if(json.containsKey('supplier_code')) {
      supplierCode = json['supplier_code'];
    }
    if(json.containsKey('supplier_name')) {
      supplierName = json['supplier_name'];
    }
    if(json.containsKey('dollar_conversion')) {
      dollarConversion = DollarConversion.fromJson(json['dollar_conversion']);
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_best'] = this.priceBest;
    data['price_1'] = this.price1;
    data['price_2'] = this.price2;
    data['currency'] = this.currency;
    data['stock'] = this.stock;
    data['supplier_code'] = this.supplierCode;
    data['supplier_name'] = this.supplierName;
    if(this.dollarConversion != null){
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
    currency = json['currency'];
    value = json['value'];
    source = json['source'];
    date = json['date'];
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