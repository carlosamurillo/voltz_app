import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;

class GridViewModel extends ReactiveViewModel {
  final _quoteService = locator<QuoteService>();

  final _inputSearchRepository = locator<InputSearchRepository>();

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _quoteService,
      ];

  QuoteModel get quote => _quoteService.quote;
  List<Product> get selectedProducts => _quoteService.selectedProducts;

  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;
}
