
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class QuoteService with ReactiveServiceMixin {

  final RxValue<QuoteModel> _rxQuote = RxValue<QuoteModel>(QuoteModel());

  QuoteModel get quote => _rxQuote.value;

  QuoteService() {
    listenToReactiveValues([_rxQuote,]);
  }

  void init() async {
    _listenChanges();
  }

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection(
        'quote-detail').doc("SWCTsMKJJ9mvatWyNuxQ");
    reference.snapshots().listen((documentSnapshot) async {
      if (documentSnapshot.exists) {
        _rxQuote.value = QuoteModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>,
            documentSnapshot.id);
        notifyListeners();
      } else {
        _rxQuote.value = QuoteModel();
      }
    });
  }
}