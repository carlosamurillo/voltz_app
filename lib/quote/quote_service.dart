
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import '../utils/stats.dart';

class QuoteService with ReactiveServiceMixin {

  final RxValue<QuoteModel> _rxQuote = RxValue<QuoteModel>(QuoteModel());
  QuoteModel get quote => _rxQuote.value;

  QuoteService() {
    listenToReactiveValues([_rxQuote,]);
  }
  
  void init(String quoteId, String? version) async {
    _initReference(quoteId, version);
    _getQuote();
    _listenChanges(version);
  }

  late DocumentReference reference;
  _initReference(String quoteId, String? version){
    if(version == "original"){
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(quoteId).collection('version').doc(quoteId);
    } else {
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(quoteId);
    }
  }

  Future<void> _getQuote() async {
    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      print('si existe data de quote, se guarda en primera consulta individual');
      _rxQuote.value = await _processQuote(documentSnapshot);
    } else {
      _rxQuote.value = QuoteModel();
    }
  }
  
  Future<void> _listenChanges(String? version) async {
    reference.snapshots().listen(
          (documentSnapshot) async {
        print("Llego data nueva...1");
        if (documentSnapshot.exists) {
          QuoteModel data = await _processQuote(documentSnapshot);

          if(version == null && quote.accepted){
            Future.delayed(const Duration(milliseconds: 1500), () {
              //_navigationService.navigateToOrderView(orderId: quote.id!);
            });
          } else if(!viewRecorded) {
            Stats.QuoteViewed(_rxQuote.value.id!);
            viewRecorded = true;
          }

          print("Llego data nueva...");
          if (data.record != null && data.record!.nextAction == null) {
            _rxQuote.value = data;
            notifyListeners();
            print("se actualiza la pantalla");
          }
          print('Ult. cantidad recibida fue: ' + quote.detail![0].productsSuggested![0].quantity.toString());
        } else {
          _rxQuote.value = QuoteModel();
        }
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  bool viewRecorded = false;
  Future<QuoteModel> _processQuote(DocumentSnapshot documentSnapshot) async {
    _rxQuote.value = QuoteModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
    return quote;
  }

  void loadingQuoteTotals () {
    quote.isCalculatingTotals = true;
    notifyListeners();
  }

  void loadingAll(int productIndex){
    quote.isCalculatingTotals = true;
    quote.detail![productIndex].isCalculatingProductTotals = true;
    notifyListeners();
  }

}