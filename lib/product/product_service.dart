import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class ProductService with ListenableServiceMixin {
  final RxValue<Product?> _rxProduct = RxValue<Product?>(null);
  Product? get product => _rxProduct.value;

  final RxValue<QuoteModel?> _rxQuoteModel = RxValue<QuoteModel?>(null);
  QuoteModel? get quoteModel => _rxQuoteModel.value;

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
    await _getProduct();
    await _createQuote(productId);
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

  Future<void> _createQuote(String productId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    notifyListeners();

    final quoteModel = QuoteModel(
      accepted: false,
      alias: 'QbjkZZG7gP0PH5dkUcwP $productId', //se llena cuando se crea la orden
      author: Author(
        id: currentUser.uid,
        email: currentUser.email,
      ),
      consecutive: null,
      customer: Customer(
        category: "C",
        id: "QbjkZZG7gP0PH5dkUcwP",
      ),
      detail: [],
      discardedProducts: [],
      pendingProducts: [],
      quoteCategory: null,
      record: Record(nextAction: null),
      shipping: Shipping(total: 0),
      totals: Totals(),
      version: 2,
    );
    final addReference = await FirebaseFirestore.instance.collection('quote-detail').add(
          quoteModel.toJsonCreate(),
        );
    final response = await addReference.get();
    if (response.exists) {
      _rxQuoteModel.value = QuoteModel.fromJson(response.data()!, response.id);
      await FirebaseFirestore.instance.collection('quote-detail').doc(response.id).update(
        {
          'record.next_action': 'add_product',
          'record.meta_data': productId,
        },
      );
      notifyListeners();
    } else {
      //
      _rxQuoteModel.value = null;
      notifyListeners();
    }
    return;
  }

  Future<bool> createOrder() async {
    if (_rxQuoteModel.value != null) {
      await FirebaseFirestore.instance.collection('quote-detail').doc(_rxQuoteModel.value!.id).update({'accepted': true});
      return true;
    } else {
      return false;
    }
  }
}
