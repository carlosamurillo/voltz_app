
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart'  show ListenableServiceMixin;
import '../cart/product_model.dart';

class ProductsService with ListenableServiceMixin {
  final RxValue<Product> _rxProduct = RxValue<Product>(Product());
  Product get product => _rxProduct.value;

  ProductsService() {
    listenToReactiveValues([_rxProduct,]);
  }

  void init(String productId) async {
    _initReference(productId);
    await _getProduct();
    notifyListeners();
  }

  late DocumentReference reference;
  _initReference(String productId){
    reference = FirebaseFirestore.instance.collection('products').doc(productId);
  }

  Future<void> _getProduct() async {
    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      _rxProduct.value = await _processProduct(documentSnapshot);
      print("se consulto un producto..." + product.skuDescription.toString());
    } else {
      print("no existe el producto...");
      _rxProduct.value = Product();
    }
  }

  bool viewRecorded = false;
  Future<Product> _processProduct(DocumentSnapshot documentSnapshot) async {
    return Product.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
  }

}