import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/common/open_search_service.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class AddToQuoteViewModel extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  final _quoteService = locator<QuoteService>();
  final InputSearchRepository _inputSearchRepository = locator<InputSearchRepository>();
  final OpenSearchService _openSearchService = locator<OpenSearchService>();

  List<QuoteModel> _quoteList = [];
  List<QuoteModel> get quoteList => _quoteList;
  late Product _product;
  late QuoteModel _quoteModel;
  QuoteModel get quoteModel => _quoteModel;

  GetQuoteState getQuoteState = GetQuoteState.initial;
  AddProductToQuoteState addProductToQuoteState = AddProductToQuoteState.initial;
  CreateQuoteWithProductState createQuoteWithProductState = CreateQuoteWithProductState.initial;

  late Query quotesTempQuery;
  StreamSubscription<List<QuoteModel>>? quoteListStreamSubscription;

  void init() {
    quoteListStreamSubscription?.cancel();
    initQuotesTemp();
  }

  void initProduct(Product product) {
    addProductToQuoteState = AddProductToQuoteState.initial;
    createQuoteWithProductState = CreateQuoteWithProductState.initial;
    _product = product;
    notifyListeners();
  }

  void initQuotesTemp() {
    getQuoteState = GetQuoteState.loading;
    notifyListeners();
    if (_quoteService.quote.customer != null && _quoteService.quote.customer!.id != null) {
      quotesTempQuery = FirebaseFirestore.instance
          .collection('quote-detail')
          .where("customer.id", isEqualTo: _quoteService.quote.customer!.id)
          .where("accepted", isEqualTo: false)
          .orderBy("created_at", descending: true);
    } else {
      quotesTempQuery = FirebaseFirestore.instance.collection('quote-detail').where("customer.id", isEqualTo: '');
    }
    quoteListStreamSubscription?.cancel();
    quoteListStreamSubscription = getQuoteListStream().listen(
      (list) {
        _quoteList = list;
        getQuoteState = GetQuoteState.loaded;
        notifyListeners();
      },
    );
  }

  Stream<List<QuoteModel>> getQuoteListStream() async* {
    yield* quotesTempQuery.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => QuoteModel.fromJson(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
        );
  }

  Future<void> addProductToQuote(QuoteModel quoteModel) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    //
    _quoteModel = quoteModel;
    addProductToQuoteState = AddProductToQuoteState.loading;
    notifyListeners();
    //
    if (_quoteModel.detail != null && !_quoteModel.detail!.any((productQuote) => productQuote.id == _product.id)) {
      final newProductDetail = Detail.fromJson({
        "id": const Uuid().v4(),
        "position": 0,
        "product_requested": _product.skuDescription,
        "products_suggested": [
          _product.toJson(),
        ]
      });
      // await FirebaseFirestore.instance.collection('quote-detail').doc(quoteModel.id).update({
      //   "detail": [
      //     ...quoteModel.detail!.map((item) => item.toJson()).toList(),
      //     newProductDetail.toJson(),
      //   ],
      //   "record": {
      //     "next_action": "calculate_totals",
      //   }
      // });
      await FirebaseFirestore.instance.collection('quote-detail').doc(quoteModel.id).update(
        {'record.next_action': 'add_product', 'record.meta_data': _product.id},
      );
      _quoteModel.detail!.add(newProductDetail);
      // return;
    }
    addProductToQuoteState = AddProductToQuoteState.loaded;
    notifyListeners();
  }

  void createQuote(String alias) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    createQuoteWithProductState = CreateQuoteWithProductState.loading;
    notifyListeners();
    final productDetail = Detail(
      id: const Uuid().v4(),
      position: 0,
      productRequested: _product.skuDescription,
      productsSuggested: [_product],
    );
    _quoteModel = QuoteModel(
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
          _quoteModel.toJsonCreate(),
        );
    final response = await addReference.get();
    if (response.exists) {
      _quoteModel = QuoteModel.fromJson(response.data()!, response.id);
      await FirebaseFirestore.instance.collection('quote-detail').doc(quoteModel.id).update(
        {'record.next_action': 'add_product', 'record.meta_data': _product.id},
      );
      createQuoteWithProductState = CreateQuoteWithProductState.loaded;
      notifyListeners();
    } else {
      //
      createQuoteWithProductState = CreateQuoteWithProductState.loadFailure;
      notifyListeners();
    }
  }

  Future<void> navigateToQuoteDetail(String quoteId) async {
    _inputSearchRepository.cancelSearch();
    _openSearchService.changeSearchOpened(false);
    final args = CartViewArguments(quoteId: quoteId);
    return _navigationService.replaceWith(Routes.cartView, arguments: args);
  }
}

enum GetQuoteState { initial, loading, loaded, loadFailure }

enum AddProductToQuoteState { initial, loading, loaded, loadFailure }

enum CreateQuoteWithProductState { initial, loading, loaded, loadFailure }
