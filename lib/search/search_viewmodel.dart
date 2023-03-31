import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/search/search_model.dart';
import 'package:maketplace/search/search_repository.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductSearchViewModel extends StreamViewModel<List<Product>> {
  final NavigationService _navigationService = locator<NavigationService>();
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();

  List<Product>? _productsData;
  List<Product>? get productsData => _productsData;

  StreamSubscription<SearchMetadata>? _skuCountSubscription;
  bool? _areStillProductsToShow;
  bool? get areStillProductsToShow => _areStillProductsToShow;

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _productSearchRepository,
      ];

  String? get lastQuery => _productSearchRepository.lastQuery;

  init() async {
    _skuCountSubscription?.cancel();
    _skuCountSubscription = _productSearchRepository.searchMetaData().listen((meta) {
      _areStillProductsToShow = meta.nbHits > (10 * (_productSearchRepository.pageKey + 1));
      notifyListeners();
    });
    showLastSearch();
  }

  showLastSearch() async {
    if (lastQuery != null && lastQuery!.isNotEmpty) {
      return _productSearchRepository.query('');
    }
  }

  @override
  Stream<List<Product>> get stream => _productSearchRepository.products();

  @override
  void onData(List<Product>? data) {
    // data?.add(Product());
    if (_productSearchRepository.isSearching) {
      _productSearchRepository.restartFilters();
      _productsData?.clear();
    }
    if (_productsData == null) {
      _productsData = data;
    } else {
      _productsData!.addAll(data ?? []);
    }
    notifyListeners();
    super.onData(_productsData);
  }

  navigateToLogin() async {
    return _navigationService.navigateToLoginView();
  }

  updatePage() {
    _productSearchRepository.applyState();
    notifyListeners();
  }
}

class ProductSearchViewModelPaged extends StreamViewModel<HitsPage> {
  final ProductSearchRepository _productSearchRepository = ProductSearchRepository();
  final PagingController<int, Product> pagingController = PagingController(firstPageKey: 0);

  init() {
    _initPageController();
  }

  void _initPageController() {
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

    pagingController.addPageRequestListener((pageKey) => _productSearchRepository.applyState());
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

class SearchStatsViewModel extends StreamViewModel<SearchMetadata> {
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _productSearchRepository,
      ];

  @override
  Stream<SearchMetadata> get stream => _productSearchRepository.searchMetaData();
}
