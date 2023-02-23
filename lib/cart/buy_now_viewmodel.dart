
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/product/product_service.dart';
import 'package:stacked/stacked.dart';
import 'package:maketplace/app/app.locator.dart';

class ToBuyNowViewModel extends ReactiveViewModel {

  final _productService = locator<ProductService>();
  Product? get product => _productService.product;
  @override
  List<ListenableServiceMixin> get listenableServices => [_productService,];

  init(String productId) async {
    return _productService.init(productId);
  }
}