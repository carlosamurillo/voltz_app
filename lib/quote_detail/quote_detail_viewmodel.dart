import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote_detail/quote_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' show NavigationService;

class QuoteDetailViewModel extends ReactiveViewModel {
  final _quoteDetailService = locator<QuoteDetailService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final _quoteService = locator<QuoteService>();
  final _authService = locator<AuthService>();

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
    quotesTemp = FirebaseFirestore.instance.collection('quote-detail').where("customer.id", isEqualTo: _authService.signedUserData!.profileUserId).snapshots();
    _quoteDetailService.init(_authService.signedUserData!.profileUserId);
    // _streamQuotes();

    return notifyListeners();
  }

  // void _streamQuotes() async {
  //   _quoteModelSubscription?.cancel();
  //   _quoteModelSubscription = _quoteDetailService.streamQuotes().listen((event) => _quoteDetailService.changeQuoteDetailList(event));
  // }

  void goToCart(String? id) async {
    if (id == null) return;
    final args = CartViewArguments(quoteId: id);
    return _navigationService.navigateTo(Routes.cartView, arguments: args);
  }
}
