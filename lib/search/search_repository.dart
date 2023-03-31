import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/search/search_model.dart';
import 'package:stacked/stacked.dart';

class ProductSearchRepository with ListenableServiceMixin {
  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int _pageKey = 0;
  int get pageKey => _pageKey;

  /// Hits Searcher with default search .
  final _productsSearcher = HitsSearcher.create(
    applicationID: AppKeys().algoliaAppId!,
    apiKey: AppKeys().algoliaApiKey!,
    state: SearchState(
      indexName: 'ecommerce_products',
      facetFilters: List.from(['status:Disponible']),
      // hitsPerPage: 0,
      page: 0,
      hitsPerPage: 10,
    ),
  );

  /// Disposable components composite
  final CompositeDisposable _components = CompositeDisposable();

  /// Product repository constructor.
  ProductSearchRepository() {
    _components
      ..add(
        _productsSearcher,
      );
  }

  /// Get stream of products.
  Stream<HitsPage> get searchPage => _productsSearcher.responses.map(HitsPage.fromResponse);

  /// Get stream of products.
  Stream<List<Product>> products() async* {
    yield* _productsSearcher.responses.map((response) => response.hits.map(Product.fromJson).toList());
  }

  /// Get stream of metadata.
  Stream<SearchMetadata> searchMetaData() async* {
    yield* _productsSearcher.responses.map(SearchMetadata.fromResponse);
  }

  /// Ultima cadena de texto de busqueda digitada por el usuario
  String? _lastQuery;
  String? get lastQuery => _lastQuery;
  Future<void> setupLastQuery() async {
    _productsSearcher.state.listen((searchState) async => (_lastQuery = searchState.query));
  }

  /// Execute a query in products
  Future<void> query(String string) async {
    if (string.isNotEmpty && string.length >= 3) {
      _isSearching = true;
      notifyListeners();
      _productsSearcher.query(string);
    } else {
      _productsSearcher.query('');
    }
  }

  void restartFilters() async {
    _productsSearcher.applyState((state) => state.copyWith(page: 0));
    _pageKey = 0;
    _isSearching = false;
    notifyListeners();
  }

  void applyState() async {
    _productsSearcher.applyState((state) => state.copyWith(page: ++_pageKey));
    notifyListeners();
  }

  /// Dispose of underlying resources.
  void dispose() {
    _components.dispose();
  }
}
