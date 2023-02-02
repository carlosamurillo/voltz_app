
import 'package:maketplace/products/products_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart' as intl;
import '../app/app.locator.dart';
import '../cart/product_model.dart';
import 'dart:js' as js;

class ProductViewModel  extends ReactiveViewModel  {
  final _productsService = ProductsService();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_productsService];

  Product get product => _productsService.product;
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  init(String productId) async {
    _productsService.init(productId);
    return notifyListeners();
  }

  Future<void> openTechFile(String url) async {
    js.context.callMethod('open', [url]);
  }

  Future<void> openWebPage(String url) async {
    js.context.callMethod('open', [url]);
  }

  navigateBack() async {
    _navigationService.back();
  }

}