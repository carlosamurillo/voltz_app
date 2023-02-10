import 'package:flutter/cupertino.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/search/search_model.dart';
import 'package:maketplace/search/serarch_repository.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pdf/widgets.dart' show Context;
import 'package:stacked/stacked.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart' as intl;

import '../app/app.locator.dart';
import '../notifications/notifications_view.dart';

class ProductSearchViewModel extends StreamViewModel<List<ProductSuggested>> {
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_productSearchRepository,];

  String? get lastQuery => _productSearchRepository.lastQuery;

  init() {
  }

  @override
  Stream<List<ProductSuggested>> get stream => _productSearchRepository.products();

  @override
  void onData(List<ProductSuggested>? data) {
    // TODO: implement onData
    data?.add(ProductSuggested());
    super.onData(data);
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

  void init(ProductSuggested productSuggested) async {
    product = productSuggested;
  }

  bool isCardExpanded = false;
  //desactivada la linea mientras se optimiza para
  Future<void> expandOrCollapseCard() async {
    isCardExpanded = !isCardExpanded;
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

  ///Se trae el servicio QuoteService para anadir productos a una cotizacion
  final _quoteService = locator<QuoteService>();
  addProductToQuote(String idProduct) async {
    _quoteService.addProductToQuote(idProduct);
    _showNotification();
  }

  _showNotification() async {
    return showOverlayNotification((context) {
      return const SimpleNotificationWidget();
    }, duration: const Duration(seconds: 45), position: NotificationPosition.bottom);
  }
}