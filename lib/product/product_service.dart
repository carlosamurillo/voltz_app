import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class ProductService with ListenableServiceMixin {
  final RxValue<Product?> _rxProduct = RxValue<Product?>(null);
  Product? get product => _rxProduct.value;

  final RxValue<double> _rxPriceToMultiply = RxValue<double>(0);
  double get priceToMultiply => _rxPriceToMultiply.value;

  Product? getCopyOfProduct() {
    if (_rxProduct.value != null) {
      return Product.copyWith(_rxProduct.value!.toJson(), _rxProduct.value!.id!);
    } else {
      return null;
    }
  }

  ProductService() {
    listenToReactiveValues([
      _rxProduct,
    ]);
  }

  init(String productId) async {
    _initReference(productId);
    return _getProduct();
  }

  late DocumentReference reference;
  _initReference(String productId) {
    reference = FirebaseFirestore.instance.collection('products').doc(productId);
  }

  Future<void> _getProduct() async {
    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      _rxProduct.value = await _processProduct(documentSnapshot);
      print("se consulto un producto..." + product!.skuDescription.toString());
    } else {
      print("no existe el producto...");
      _rxProduct.value = null;
    }
    notifyListeners();
  }

  bool viewRecorded = false;
  Future<Product> _processProduct(DocumentSnapshot documentSnapshot) async {
    final toReturn = Product.fromJsonWithId(json: documentSnapshot.data() as Map<String, dynamic>, id: documentSnapshot.id);
    if (toReturn.bestSupplier?.priceBest != null) {
      _rxPriceToMultiply.value = toReturn.bestSupplier!.priceBest!;
    } else if (toReturn.price?.price2 != null) {
      _rxPriceToMultiply.value = toReturn.price!.price2!;
    } else if (toReturn.pricePublic != null) {
      _rxPriceToMultiply.value = toReturn.pricePublic!;
    }
    notifyListeners();
    return toReturn;
  }
}
