
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;

import '../app/app.locator.dart';

class GridViewModel extends ReactiveViewModel  {

  final _quoteService = locator<QuoteService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [_quoteService,];

  QuoteModel get quote => _quoteService.quote;
  List<ProductSuggested> get selectedProducts => _quoteService.selectedProducts;

}