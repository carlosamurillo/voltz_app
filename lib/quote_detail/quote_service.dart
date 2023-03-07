import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart' show NavigationService;

class QuoteDetailService with ListenableServiceMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  final RxValue<List<QuoteModel>> _rxQuoteDetailList = RxValue<List<QuoteModel>>([]);
  List<QuoteModel> get quoteDetailList => _rxQuoteDetailList.value;

  late CollectionReference reference;

  QuoteService() {
    listenToReactiveValues([_rxQuoteDetailList]);
  }

  void init() async {
    _initReference();
  }

  _initReference() {
    reference = FirebaseFirestore.instance.collection('quote-detail');
  }

  Stream<List<QuoteModel>> streamQuotes() async* {
    yield* reference
        .where("customer_id", isEqualTo: "112") //
        // .orderBy("consecutive", descending: true)
        // .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => QuoteModel.fromJson(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList(),
        );
  }

  void changeQuoteDetailList(List<QuoteModel> modelList) {
    _rxQuoteDetailList.value = modelList;
    notifyListeners();
  }
}
