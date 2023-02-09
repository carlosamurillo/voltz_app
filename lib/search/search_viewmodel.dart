import 'package:flutter/cupertino.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/search/search_model.dart';
import 'package:maketplace/search/serarch_repository.dart';
import 'package:stacked/stacked.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart' as intl;

class ProductSearchViewModel extends StreamViewModel<List<ProductSuggested>> {
  final ProductSearchRepository _productSearchRepository = ProductSearchRepository();
  init() {
  }

  @override
  Stream<List<ProductSuggested>> get stream => _productSearchRepository.products;

  @override
  void dispose() {
    _productSearchRepository.dispose();
    super.dispose();
  }
}

class ProductSearchViewModelPaged extends StreamViewModel<HitsPage> {

  final ProductSearchRepository _productSearchRepository = ProductSearchRepository();
  final PagingController<int, ProductSuggested> pagingController = PagingController(firstPageKey: 0);

  init() {
    _initPageController();
  }

  void _initPageController(){
    stream.listen((page) {
      if (page.pageKey == 0) {
        pagingController.refresh();
      }
      pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => pagingController.error = error);

    stream.listen((page) {
      if (page.pageKey == 0) {
        pagingController.refresh();
      }
      pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => pagingController.error = error);

    pagingController.addPageRequestListener((pageKey) => _productSearchRepository.applyState(pageKey));
  }

  @override
  Stream<HitsPage> get stream => _productSearchRepository.searchPage;

  @override
  void dispose() {
    _productSearchRepository.dispose();
    pagingController.dispose();
    super.dispose();
  }
}

class ProductCardViewModel extends BaseViewModel {
  late ProductSuggested product;
  var currencyFormat =
  intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  void init(ProductSuggested productSuggested){
    product = productSuggested;
  }

  //desactivada la linea mientras se optimiza para
  Future<void> expandOrCollapseCard() async {
    product.isCardExpanded = !product.isCardExpanded;
    return notifyListeners();
  }

  final shimmerGradientWhiteBackground = const LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}