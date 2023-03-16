import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote_detail/quote_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' show NavigationService;

class QuoteDetailViewModel extends ReactiveViewModel {
  final _quoteDetailService = locator<QuoteDetailService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final _quoteService = locator<QuoteService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_quoteDetailService];

  bool updateGrid = true;

  List<QuoteModel> get quoteDetailList => _quoteDetailService.quoteDetailList;

  int documentLimit = 20;
  QueryDocumentSnapshot? lastDocument = null;
  ScrollController scrollController = ScrollController();
  late DocumentSnapshot postByUser;
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  StreamSubscription<List<QuoteModel>>? _quoteModelSubscription;

  late Stream<QuerySnapshot> quotesTemp;

  @override
  void dispose() {
    // Optional teardown:
    super.dispose();
  }

  init() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      quotesTemp = FirebaseFirestore.instance.collection('quote-detail').where("customer.id", isEqualTo: currentUser.uid).snapshots();
      if (_quoteService.quote.customer != null && _quoteService.quote.customer!.id != null) {}
      _quoteDetailService.init(currentUser.uid);
    } else {
      quotesTemp = FirebaseFirestore.instance.collection('quote-detail').where("customer.id", isEqualTo: '').snapshots();
    }
    _streamQuotes();

    return notifyListeners();
  }

  void _streamQuotes() async {
    _quoteModelSubscription?.cancel();
    _quoteModelSubscription = _quoteDetailService.streamQuotes().listen((event) => _quoteDetailService.changeQuoteDetailList(event));
  }

  void goToCart(String? id) async {
    if (id == null) return;
    final args = CartViewArguments(quoteId: id);
    return _navigationService.navigateTo(Routes.cartView, arguments: args);
  }
}
