
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';


class QuoteService with ReactiveServiceMixin {

  final RxValue<QuoteModel> _rxQuote = RxValue<QuoteModel>(QuoteModel());
  QuoteModel get quote => _rxQuote.value;

  QuoteService(){
    listenToReactiveValues([_rxQuote,]);
  }

  void init() async {
    _listenChanges();
  }

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc("SWCTsMKJJ9mvatWyNuxQ");
    reference.snapshots().listen((documentSnapshot) async {
      print(documentSnapshot.data().toString());
      print("AAA");
      if (documentSnapshot.exists) {
        print("BB");
        _rxQuote.value = QuoteModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        print("CC");
        notifyListeners();
        print("DD");
      } else {
        _rxQuote.value = QuoteModel();
      }
    });
  }

  onQuantityChange(int detailProductRequestedIndex, int detailProductSuggestedIndex, int quantity){
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    var fieldName = "detail.$detailProductRequestedIndex.products_suggested.$detailProductSuggestedIndex.quantity";
    print (fieldName);

    print('TTTTTTTTTTTTTTTTTTTTT');
  }
}