import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/search/search_model.dart';
import 'package:stacked/stacked.dart';
import '../keys_model.dart';

class ProductSearchRepository with ListenableServiceMixin  {

  /// Hits Searcher with default search .
  final _productsSearcher = HitsSearcher.create(
    applicationID: VoltzKeys().algoliaAppId!,
    apiKey: VoltzKeys().algoliaApiKey!,
    state: const SearchState(
      indexName: 'ecommerce_products',
    ),
  );

  /// Disposable components composite
  final CompositeDisposable _components = CompositeDisposable();

  /// Product repository constructor.
  ProductSearchRepository() {
    _components
      ..add(_productsSearcher,);
    _productsSearcher.state.listen((searchState) => (_lastQuery = searchState.query));
  }

  Stream<SearchMetadata> get searchMetadata => _productsSearcher.responses.map(SearchMetadata.fromResponse);

  /// Get stream of products.
  Stream<HitsPage> get searchPage => _productsSearcher.responses.map(HitsPage.fromResponse);

  /// Get stream of products.
  Stream<List<ProductSuggested>> products() async* {
    yield* _productsSearcher.responses
        .map((response) => response.hits.map(ProductSuggested.fromJson).toList());
  }

  /// Ultima cadena de texto de busqueda digitada por el usuario
  String? _lastQuery;
  String? get lastQuery => _lastQuery;
  /// Execute a query in products
  void query(String string) async {
    if(string.isNotEmpty && string.length >= 3) {
      _productsSearcher.query(string);
    } else {
      _productsSearcher.query('');
    }
  }

  void applyState(int? pageKey) async {
    _productsSearcher.applyState((state)  => state.copyWith(page: pageKey));
  }

  /// Dispose of underlying resources.
  void dispose() {
    _components.dispose();
  }
}