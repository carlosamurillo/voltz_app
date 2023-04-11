import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/notifications/notifications_service.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart' show NavigationService;

class QuoteService with ListenableServiceMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final RxValue<QuoteModel> _rxQuote = RxValue<QuoteModel>(QuoteModel());
  QuoteModel get quote => _rxQuote.value;

  final RxValue<String?> _rxCompanyName = RxValue<String?>(null);
  String? get companyName => _rxCompanyName.value;

  final RxValue<String?> _rxCustomerName = RxValue<String?>(null);
  String? get customerName => _rxCustomerName.value;

  final RxValue<List<Product>> _rxSelectedProducts = RxValue<List<Product>>([]);
  List<Product> get selectedProducts => _rxSelectedProducts.value;

  QuoteService() {
    listenToReactiveValues([_rxQuote, _rxSelectedProducts, _rxCompanyName, _rxCustomerName]);
  }

  String recordLastAction = '';

  void init(
    String quoteId,
  ) async {
    _initReference(quoteId);
    _getQuote();
    await _listenChanges();
    //_updateTotals();
  }

  late DocumentReference reference;
  _initReference(
    String quoteId,
  ) {
    reference = FirebaseFirestore.instance.collection('quote-detail').doc(quoteId);
  }

  final StreamController<List<Product>> _streamController = StreamController<List<Product>>();
// Creating a new stream through the controller
  Stream<List<Product>> get getStream => _streamController.stream;

  streamProducts() async {
    print('se llamo el servicio streamProducts');
    _rxSelectedProducts.value = [];
    //List<ProductsSuggested> filtered = [];
    if (_rxQuote.value.detail != null && _rxQuote.value.detail!.isNotEmpty) {
      for (int i = 0; i < _rxQuote.value.detail!.length; i++) {
        bool firstAdded = false;
        for (int e = 0; _rxQuote.value.detail![i].productsSuggested!.length > e; e++) {
          if (_rxQuote.value.detail![i].productsSuggested![e].selected == true && !firstAdded) {
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

  Future<void> _getQuote() async {
    DocumentSnapshot documentSnapshot = await reference.get();
    if (documentSnapshot.exists) {
      print('si existe data de quote, se guarda en primera consulta individual');
      _rxQuote.value = await _processQuote(documentSnapshot);

      streamProducts();
      _getCustomerName(id: _rxQuote.value.customer!.id);
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
      (value) => print("DocumentSnapshot successfully updated!" + quote.id!),
      onError: (e) => print("Error updating document $e"),
    );
    return true;
  }

  final _notificationService = locator<NotificationService>();
  Future<void> addProductToQuote(
    String idProduct,
  ) async {
    if (_rxQuote.value.detail != null) {
      _notificationService.emitDialogNotification(
        "Recalculando totales...",
        "Ir a la cotización",
        "Seguir agregando",
        false,
      );
      notifyListeners();
      DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_rxQuote.value.id);
      recordLastAction = 'add_product';
      await reference.update({'record.next_action': 'add_product', 'record.meta_data': idProduct});
    } else {
      throw Exception('No hay una cotizacion activa, debe asegurarse que primero se inicialice el servicio de QuoteService con una cotizacion');
    }
  }

  Future<void> _updateTotalsCommand() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc(_rxQuote.value.id);
    await reference.update({'record.next_action': 'calculate_totals'});
  }

  Future<void> _getCustomerName({required id}) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('profile-user').doc(id);
    DocumentSnapshot res = await reference.get();
    var json = res.data() as Map<String, dynamic>;
    _rxCustomerName.value = json['full_name'];
    notifyListeners();
    if (json.containsKey('companies') && json['companies'].length > 0) {
      _getCompanyName(id: json['companies'][0]);
    }
  }

  Future<void> _getCompanyName({required id}) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('company').doc(id);
    DocumentSnapshot res = await reference.get();
    var json = res.data() as Map<String, dynamic>;
    _rxCompanyName.value = json['name'];
    notifyListeners();
  }

  Future<void> _listenChanges() async {
    reference.snapshots().listen(
      (documentSnapshot) async {
        print("Se recibe data nueva desde el servidor");
        if (documentSnapshot.exists) {
          QuoteModel data = await _processQuote(documentSnapshot);

          if (data.accepted) {
            final args = OrderViewArguments(orderId: data.id!, fromQuote: true);
            _navigationService.replaceWith(Routes.orderView, arguments: args);
          } else if (!viewRecorded) {
            //TODO mejorar esto y porque no da
            // Stats.QuoteViewed(_rxQuote.value.id!);
            viewRecorded = true;
          }

          if (data.record != null && data.record!.nextAction == null) {
            _rxQuote.value = data;
            await streamProducts();
            _getCustomerName(id: _rxQuote.value.customer!.id);
            notifyListeners();
            if (recordLastAction == 'add_product') {
              _notificationService.emitDialogNotification(
                "¡Agregado a la cotización!",
                "Ir a la cotización",
                "Seguir agregando",
                true,
              );
              recordLastAction = '';
              notifyListeners();
            }
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

  void loadingQuoteTotals() {
    _rxQuote.value.isCalculatingTotals = true;
    notifyListeners();
  }

  void loadingAll() {
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
