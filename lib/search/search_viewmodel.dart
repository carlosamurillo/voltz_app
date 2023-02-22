
import 'package:maketplace/search/search_model.dart';
import 'package:maketplace/search/search_repository.dart';
import 'package:stacked/stacked.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../app/app.locator.dart';
import '../product/product_model.dart';

class ProductSearchViewModel extends StreamViewModel<List<Product>> {
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_productSearchRepository,];

  String? get lastQuery => _productSearchRepository.lastQuery;

  init() {
  }

  @override
  Stream<List<Product>> get stream => _productSearchRepository.products();

  @override
  void onData(List<Product>? data) {
    data?.add(Product());
    super.onData(data);
  }
}

class ProductSearchViewModelPaged extends StreamViewModel<HitsPage> {

  final ProductSearchRepository _productSearchRepository = ProductSearchRepository();
  final PagingController<int, Product> pagingController = PagingController(firstPageKey: 0);

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

class SearchStatsViewModel extends StreamViewModel<SearchMetadata>{
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();

  init() {
  }

  @override
  Stream<SearchMetadata> get stream => _productSearchRepository.searchMetaData();

}