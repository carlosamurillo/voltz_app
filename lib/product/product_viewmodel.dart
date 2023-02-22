import 'package:intl/intl.dart' as intl;
import 'package:maketplace/product/product_service.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import 'product_model.dart';
// import 'dart:js' as js;

class ProductViewModel extends ReactiveViewModel {
  final _productsService = ProductService();

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_productsService];

  Product? get product => _productsService.getCopyOfProduct();
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  void init(String productId) async {
    print('ProductViewModel ... productId ... ' + productId);
    _productsService.init(productId);
    notifyListeners();
  }

  Future<void> openTechFile(String url) async {
    // js.context.callMethod('open', [url]);
  }

  Future<void> openWebPage(String url) async {
    // js.context.callMethod('open', [url]);
  }

  navigateBack() async {
    _navigationService.back();
  }
}
