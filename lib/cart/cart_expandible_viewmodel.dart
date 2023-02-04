
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';

class GridViewModel extends StreamViewModel<ProductsSuggested> {

  final _quoteService = locator<QuoteService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [_quoteService,];

  QuoteModel get quote => _quoteService.quote;
  List<ProductsSuggested> productList = [];

  @override
  void onData(ProductsSuggested? data) {
    print('YYYYYYYYYYYYYYYYYYYYYYYYYYYYYy');
    if(data != null) {
      productList.add(data);
    }
    super.onData(data);
  }

  @override
  Stream<ProductsSuggested> get stream => _quoteService.getStream;
}