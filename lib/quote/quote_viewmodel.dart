
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';

class QuoteViewModel  extends ReactiveViewModel  {


  @override
  List<ReactiveServiceMixin> get reactiveServices => [QuoteService(),];
  final _quoteService = locator<QuoteService>();
  QuoteModel get quote => _quoteService.quote;

  init() async {
    _quoteService.init();
  }

  onChangeDetailQuantity(int detailProductRequestedIndex, int detailProductSuggestedIndex, int quantity){
    _quoteService.onQuantityChange(detailProductRequestedIndex, detailProductSuggestedIndex, quantity);
  }

}