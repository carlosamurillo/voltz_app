import 'package:flutter/material.dart';
import 'package:maketplace/add_to_quote/add_to_quote_service.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:stacked_services/stacked_services.dart';

class AddToQuoteViewModel extends ChangeNotifier {
  final _addToQuoteService = AddToQuoteService();
  final NavigationService _navigationService = locator<NavigationService>();

  List<QuoteModel> get quoteModelList => _addToQuoteService.quoteModelList;

  Product get product => _addToQuoteService.product;

  QuoteModel get quoteModel => _addToQuoteService.quoteModel;

  GetQuoteState get getQuoteState => _addToQuoteService.getQuoteState;

  AddProductToQuoteState get addProductToQuoteState => _addToQuoteService.addProductToQuoteState;

  CreateQuoteWithProductState get createQuoteWithProductState => _addToQuoteService.createQuoteWithProductState;

  void init() => _addToQuoteService.init();

  void initProduct(Product product) => _addToQuoteService.initProduct(product);

  Future<void> getQuoteList() async => _addToQuoteService.getQuoteList();

  Future<void> addProductToQuote(QuoteModel quoteModel) async => _addToQuoteService.addProductToQuote(quoteModel);

  void createQuote(String alias) async => _addToQuoteService.createQuote(alias);

  Future<void> navigateToQuoteDetail(String quoteId) async {
    final args = CartViewArguments(quoteId: quoteId);
    return _navigationService.replaceWith(Routes.cartView, arguments: args);
  }
}
