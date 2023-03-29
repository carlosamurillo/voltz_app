import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import '../quote/quote_model.dart';

class AddToQuoteService with ListenableServiceMixin {
  final RxValue<List<QuoteModel>> _rxQuoteModelList = RxValue<List<QuoteModel>>([]);
  List<QuoteModel> get quoteModelList => _rxQuoteModelList.value;

  final RxValue<Product> _rxProduct = RxValue<Product>(Product());
  Product get product => _rxProduct.value;

  final RxValue<QuoteModel> _rxQuoteModel = RxValue<QuoteModel>(QuoteModel());
  QuoteModel get quoteModel => _rxQuoteModel.value;

  final RxValue<GetQuoteState> _rxGetQuoteState = RxValue<GetQuoteState>(GetQuoteState.initial);
  GetQuoteState get getQuoteState => _rxGetQuoteState.value;

  final RxValue<AddProductToQuoteState> _rxaddProductToQuoteState = RxValue<AddProductToQuoteState>(AddProductToQuoteState.initial);
  AddProductToQuoteState get addProductToQuoteState => _rxaddProductToQuoteState.value;

  final RxValue<CreateQuoteWithProductState> _rxCreateQuoteWithProductState = RxValue<CreateQuoteWithProductState>(CreateQuoteWithProductState.initial);
  CreateQuoteWithProductState get createQuoteWithProductState => _rxCreateQuoteWithProductState.value;

  late Query _quoteListQuery;

  init() {
    _quoteListQuery = FirebaseFirestore.instance.collection('quote-detail').orderBy("created_at", descending: true).limit(3);
    getQuoteList();
  }

  void initProduct(Product product) {
    _rxaddProductToQuoteState.value = AddProductToQuoteState.initial;
    _rxCreateQuoteWithProductState.value = CreateQuoteWithProductState.initial;
    _rxProduct.value = product;
    notifyListeners();
  }

  Future<void> getQuoteList() async {
    _rxGetQuoteState.value = GetQuoteState.loading;
    // notifyListeners();
    final response = await _quoteListQuery.get();
    if (response.docs.isNotEmpty) {
      _rxQuoteModelList.value = response.docs
          .map(
            (doc) => QuoteModel.fromJson(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
      // notifyListeners();
    }
    _rxGetQuoteState.value = GetQuoteState.loaded;
    // notifyListeners();
  }

  Future<void> addProductToQuote(QuoteModel quoteModel) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    //
    _rxQuoteModel.value = quoteModel;
    _rxaddProductToQuoteState.value = AddProductToQuoteState.loading;
    notifyListeners();
    //
    if (_rxQuoteModel.value.detail != null && !_rxQuoteModel.value.detail!.any((productQuote) => productQuote.id == _rxProduct.value.id)) {
      final newProductDetail = Detail.fromJson({
        "id": const Uuid().v4(),
        "position": 0,
        "product_requested": _rxProduct.value.skuDescription,
        "products_suggested": [
          _rxProduct.value.toJson(),
        ]
      });
      await FirebaseFirestore.instance.collection('quote-detail').doc(quoteModel.id).update({
        "detail": [
          ...quoteModel.detail!.map((item) => item.toJson()).toList(),
          newProductDetail.toJson(),
        ],
        "record": {
          "next_action": "calculate_totals",
        }
      });
      // await FirebaseFirestore.instance.collection('quote-detail').doc(quoteModel.id).update({'record.next_action': 'add_product', 'record.meta_data': _product.id});
      _rxQuoteModel.value.detail!.add(newProductDetail);
      // return;
    }
    _rxaddProductToQuoteState.value = AddProductToQuoteState.loaded;
    notifyListeners();
  }

  void createQuote(String alias) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _rxCreateQuoteWithProductState.value = CreateQuoteWithProductState.loading;
    notifyListeners();

    _rxQuoteModel.value = QuoteModel(
      accepted: false,
      alias: alias,
      author: Author(
        id: currentUser.uid,
        email: currentUser.email,
      ),
      consecutive: null,
      customer: Customer(
        category: "C",
        id: "QbjkZZG7gP0PH5dkUcwP",
      ),
      detail: [
        Detail(
          id: const Uuid().v4(),
          position: 0,
          productRequested: _rxProduct.value.skuDescription,
          productsSuggested: [_rxProduct.value],
        ),
      ],
      discardedProducts: [],
      quoteCategory: null,
      record: Record(nextAction: "calculate_totals"),
      shipping: Shipping(total: 0),
      version: 2,
    );
    final addReference = await FirebaseFirestore.instance.collection('quote-detail').add(
          _rxQuoteModel.value.toJsonCreate(),
        );
    final response = await addReference.get();
    if (response.exists) {
      _rxQuoteModel.value = QuoteModel.fromJson(response.data()!, response.id);
      _rxCreateQuoteWithProductState.value = CreateQuoteWithProductState.loaded;
      notifyListeners();
      getQuoteList();
    } else {
      //
      _rxCreateQuoteWithProductState.value = CreateQuoteWithProductState.loadFailure;
      notifyListeners();
    }
  }
}

enum GetQuoteState { initial, loading, loaded, loadFailure }

enum AddProductToQuoteState { initial, loading, loaded, loadFailure }

enum CreateQuoteWithProductState { initial, loading, loaded, loadFailure }
