
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart' show NavigationService;

import '../app/app.locator.dart';
import '../utils/stats.dart';

class QuoteService with ListenableServiceMixin {

  final NavigationService _navigationService = locator<NavigationService>();
  final RxValue<QuoteModel> _rxQuote = RxValue<QuoteModel>(QuoteModel());
  QuoteModel get quote => _rxQuote.value;

  final RxValue<List<ProductsSuggested>> _rxSelectedProducts = RxValue<List<ProductsSuggested>>([]);
  List<ProductsSuggested> get selectedProducts => _rxSelectedProducts.value;

  QuoteService() {
    listenToReactiveValues([_rxQuote, _rxSelectedProducts]);
  }
  
  void init(String quoteId, String? version) async {
    _initReference(quoteId, version);
    _getQuote();
    await _listenChanges(version);
    //_updateTotals();
  }

  late DocumentReference reference;
  _initReference(String quoteId, String? version){
    if(version == "original"){
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(quoteId).collection('version').doc(quoteId);
    } else {
      reference = FirebaseFirestore.instance.collection('quote-detail').doc(quoteId);
    }
  }

  final StreamController<List<ProductsSuggested>> _streamController = StreamController<List<ProductsSuggested>>();
// Creating a new stream through the controller
  Stream<List<ProductsSuggested>> get getStream => _streamController.stream;

  streamProducts() async {
    print('se llamo el servicio streamProducts');
    _rxSelectedProducts.value = [];
    //List<ProductsSuggested> filtered = [];
    if(_rxQuote.value.detail != null && _rxQuote.value.detail!.isNotEmpty){
      for(int i = 0; i < _rxQuote.value.detail!.length; i++){
        bool firstAdded = false;
        for(int e = 0; _rxQuote.value.detail![i].productsSuggested!.length > e; e++){
          if (_rxQuote.value.detail![i].productsSuggested![e].selected == true && !firstAdded){
            _rxSelectedProducts.value.add(_rxQuote.value.detail![i].productsSuggested![e]);
            // _streamController.add(_rxQuote.value.detail![i].productsSuggested![e]);
            //filtered.add(_rxQuote.value.detail![i].productsSuggested![e]);
            print('se anadio un producto desde el servicio');
            firstAdded = true;
          }
        }
      }
      _streamController.add(_rxSelectedProducts.value);
    } else {
      print('NEGATIVA servicio streamProducts .............. 2');
    }
  }

  /*Stream<ProductsSuggested> streamProducts() async* {
    print('se llamo el servicio streamProducts');
    //_rxSelectedProducts.value = [];
    if(_rxQuote.value.detail != null && _rxQuote.value.detail!.isNotEmpty){
      print('se llamo el servicio streamProducts .............. 2');
      for(int i = 0; i < _rxQuote.value.detail!.length; i++){
        print('se llamo el servicio streamProducts .............. 3');
        bool firstAdded = false;
        for(int e = 0; _rxQuote.value.detail![i].productsSuggested!.length > e; e++){
          print('se llamo el servicio streamProducts .............. 4');
          if (_rxQuote.value.detail![i].productsSuggested![e].selected == true && !firstAdded){
            print('Se va a agregar prodcuto ..............>>>>>');
            _rxSelectedProducts.value.add(_rxQuote.value.detail![i].productsSuggested![e]);
            print('se anadira un producto desde el servicio');
            yield _rxQuote.value.detail![i].productsSuggested![e];
            print('se anadio un producto desde el servicio');
            firstAdded = true;
          }
        }
      }
    } else {
      print('NEGATIVA servicio streamProducts .............. 2');
    }
  }*/

  Future<void> _getQuote() async {
    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      print('si existe data de quote, se guarda en primera consulta individual');
      _rxQuote.value = await _processQuote(documentSnapshot);
      streamProducts();
    } else {
      _rxQuote.value = QuoteModel();
    }
  }

  Future<bool> updateQuote(QuoteModel quote) async {
    print('ejecutando updateQuote en servicio quote_service');
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(quote.id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(reference, quote.toJson());
    }).then(
          (value) => print("DocumentSnapshot successfully updated!" + quote.id! ),
      onError: (e) => print("Error updating document $e"),
    );
    return true;
  }

  Future<void> _updateTotals() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_rxQuote.value.id);
    await reference.update({'record.next_action': 'calculate_totals'});
  }

  _getCustomerDetail({required customerId}){

  }

  Future<Map<String, dynamic>> _getCustomerName({required id}) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('profile-user').doc(id);
    DocumentSnapshot res = await reference.get();
    return res.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _getCompanyName({required id}) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('company').doc(id);
    DocumentSnapshot res = await reference.get();
    return res.data() as Map<String, dynamic>;
  }
  
  Future<void> _listenChanges(String? version) async {
    reference.snapshots().listen(
          (documentSnapshot) async {
        print("Se recibe data nueva desde el servidor");
        if (documentSnapshot.exists) {
          QuoteModel data = await _processQuote(documentSnapshot);

          if(version == null && quote.accepted){
            Future.delayed(const Duration(milliseconds: 1500), () {
              _navigationService.navigateToOrderView(orderId: quote.id!);
            });
          } else if(!viewRecorded) {
            Stats.QuoteViewed(_rxQuote.value.id!);
            viewRecorded = true;
          }

          if (data.record != null && data.record!.nextAction == null) {
            _rxQuote.value = data;
            await streamProducts();
            notifyListeners();
            print("Se llamo notifyListeners desde Servicio QuoteService");
          }
        } else {
          _rxQuote.value = QuoteModel();
        }
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  bool viewRecorded = false;
  Future<QuoteModel> _processQuote(DocumentSnapshot documentSnapshot) async {
    return QuoteModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
  }

  void loadingQuoteTotals () {
    _rxQuote.value.isCalculatingTotals = true;
    notifyListeners();
  }

  void loadingAll(){
    _rxQuote.value.isCalculatingTotals = true;
    notifyListeners();
  }

  Future<void> resetCards() async {
    print('reset card');
    _rxQuote.value.detail!.forEach((element) {
      element.productsSuggested!.forEach((element2) {
        element2.isCardExpanded = false;
      });
    });
    return notifyListeners();
  }

}