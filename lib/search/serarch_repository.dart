import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/search/search_model.dart';

import '../keys_model.dart';

class ProductSearchRepository {

  /// Hits Searcher with default search .
  final _productsSearcher = HitsSearcher.create(
    applicationID: VoltzKeys().algoliaAppId!,
    apiKey: VoltzKeys().algoliaApiKey!,
    state: const SearchState(
      indexName: 'ecommerce',
    ),
  );

  /// Disposable components composite
  final CompositeDisposable _components = CompositeDisposable();

  /// Product repository constructor.
  ProductSearchRepository() {
    _components
      ..add(_productsSearcher);
  }

  Stream<SearchMetadata> get searchMetadata => _productsSearcher.responses.map(SearchMetadata.fromResponse);

  /// Get stream of products.
  Stream<HitsPage> get searchPage => _productsSearcher.responses.map(HitsPage.fromResponse);

  /// Get stream of products.
  Stream<List<ProductSuggested>> get products => _productsSearcher.responses
      .map((response) => response.hits.map(ProductSuggested.fromJson).toList());

  /// Execute a query in products
  void query(String string) {
    _productsSearcher.query(string);
  }

  void applyState(int? pageKey){
    _productsSearcher.applyState((state) => state.copyWith(page: pageKey));
  }

  /// Dispose of underlying resources.
  void dispose() {
    _components.dispose();
  }
}