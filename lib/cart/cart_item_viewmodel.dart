import 'dart:async';

import 'package:intl/intl.dart' as intl;
import 'package:flutter/cupertino.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../quote/quote_model.dart';
import '../quote/quote_service.dart';
import '../utils/stats.dart';

class CardItemViewModel extends QuoteViewModel {

  var currencyFormat =
  intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  final TextEditingController textEditingController = TextEditingController();
  double lastValue = 0;

  bool isQtyControlOpen = false;
  bool isCalculatorActive = false;

  final shimmerGradientDarkBackground = const LinearGradient(
    colors: [
      Color(0xFF4C5365),
      Color(0xFF4C5367),
      Color(0xFF4C5370),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  final _quoteService = locator<QuoteService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [_quoteService,];

  /**Variables para manejar el foco de los imput y botones*/
  final FocusNode _focusNodeInput = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;
  FocusNode get focusNodeButton => _focusNodeButton;
  
  void requestFocusAdd(){
    product.focusAdd.requestFocus();
  }
  void unFocusAdd(){
    product.focusAdd.unfocus();
  }
  void requestFocusRemove(){
    product.focusRemove.requestFocus();
  }
  void unFocusRemove(){
    product.focusRemove.unfocus();
  }

  /**Producto sugerido seleccionado, es decir selected = true*/
  late ProductsSuggested product;
  /**Pocision del producto seleccionado, es decir selected = true*/
  late int cardIndex;
  
  void initCartView({required int cartIndex, required productSuggested}) {
    cardIndex = cartIndex;
    print('line 1');
    product = productSuggested;

    print('line 2');
    _focusNodeInput.addListener(() => _onFocusInputChange());
    _focusNodeButton.addListener(() => _onFocusButtonChange());
    product.focusAdd.addListener(() => _onFocusAddChange());
    product.focusRemove.addListener(() => _onFocusRemoveChange());

    print('line 3');
    textEditingController.text = productSuggested.quantity!.toString();

    print('line 5');
    return notifyListeners();
  }

  void initExpandableCard({required int cartIndex}){

  }

  Future<void> activateCalculator() async {
    isCalculatorActive = true;
    _focusNodeInput.requestFocus();
    notifyListeners();
  }

  Future<void> deactivateCalculator() async {
    isCalculatorActive = false;
    return notifyListeners();
  }

  Future<void> expandOrCollapseCard() async {
    print(cardIndex);
    await resetCards();
    product.isCardExpanded = !product.isCardExpanded;
    return notifyListeners();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textEditingController.dispose();
    super.dispose();
  }

  /// Estos proceso de poner en Cola los Future debe ir por el hilo principal para evitar que
  /// se desordenen, y se ejecuten en orden inesperado **/
  ///

  Future<double> onTextQtyChanged(String value) async {
    double qty = double.tryParse(value) ?? 0;
    if (value.isEmpty) {
      setCalculateVisibility(false);
    } else if (lastValue != qty) {
      setCalculateVisibility(true);
    } else {
      setCalculateVisibility(false);
    }
    return qty;
  }

  _onFocusInputChange() async {
    if (!_focusNodeInput.hasFocus && !_focusNodeButton.hasFocus) {
      areaLostFocus();
    }
  }

  _onFocusButtonChange() async {
    print('Button Has Focus:  ${_focusNodeButton.hasFocus}');
    if (_focusNodeButton.hasFocus) {
    } else {
    }
  }

  Future<void> _onFocusAddChange() async {
    print('From viemodel focusAdd Has Focus:  ${product.focusAdd.hasFocus}');
    if (!product.focusAdd.hasFocus && !product.focusRemove.hasFocus) {
      print('xxxxxx');
      saveQty();
      return highlightQtyLabel(false);
    }
  }

  Future<void> _onFocusRemoveChange() async {
    print('From viemodel focusRemove Has Focus:  ${product.focusRemove.hasFocus}');
    if (!product.focusRemove.hasFocus && !product.focusAdd.hasFocus) {
      print('bbbbbb');
      saveQty();
      highlightQtyLabel(false);
    }
  }

  onPressCalculate(BuildContext context) async {
    deactivateCalculator();
    await setCalculateVisibility(false);
    lastValue = double.tryParse(
        textEditingController
            .text) ??
        0;

    await onUpdateQuote(
        cardIndex,
        0,
        double.tryParse(
            textEditingController
                .text) ??
            0);

  }

  areaLostFocus() async {
    print('areaLostFocus metodo...');
    if (!quote.isCalculatingTotals) {
      textEditingController.text = product.quantity!.toString();
    }
    deactivateCalculator();
    await setCalculateVisibility(false);
  }

  setCalculateVisibility(bool isVisible) async {
    isQtyControlOpen = isVisible;
    return notifyListeners();
  }

  void requestFocusInput(BuildContext context) {
    _focusNodeInput.requestFocus();
  }

  void requestFocusButton(BuildContext context) {
    _focusNodeButton.requestFocus();
  }

  Future<void> loadingProductTotals() async {
    product.isCalculatingProductTotals = !product.isCalculatingProductTotals;
    return notifyListeners();
  }

  Future<void> onUpdateQuote(int i, int b, double quantity) async {
    loadingProductTotals();
    loadingTotals();
    //setQuantity(i, b, quantity);
    calculateTotals();
    return Future.delayed(const Duration(milliseconds: 0), () async {
      await updateQuote(quote);
      return loadingProductTotals();
    });
  }

  Future<void> onSelectedSku(bool value, int i, int b) async {
    loadingProductTotals();
    product.selected = value;
    loadingTotals();
    calculateTotals();
    await updateQuote(quote);
    loadingProductTotals();
    return Stats.SkuSeleccionado(quoteId: quote.id!, skuSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true,  orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: quote.detail![i].productRequested!,
        countProductsSuggested: quote.detail![i].productsSuggested!.length);
  }

  Future<void> onDeleteSku(Detail value) async {
    loadingTotals();
    quote.detail!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.productRequested, reason: "No lo quiero.", position: value.position));
    calculateTotals();
    await updateQuote(quote);
    return Stats.SkuBorrado(quoteId: quote.id!, skuSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: value.productRequested!,
        countProductsSuggested: value.productsSuggested!.length);
  }

  Future<void> addOne() async {
    highlightQtyLabel(true);
    product.quantity = product.quantity! + 1;
    textEditingController.text = product.quantity!.toString();
    return notifyListeners();
  }

  Future<void> removeOne() async {
    if(product.quantity! > 1) {
      highlightQtyLabel(true);
      product.quantity = product.quantity! - 1;
      textEditingController.text = product.quantity!.toString();
      return notifyListeners();
    }
  }

  Future<void> saveQty () async {
    await loadingProductTotals();
    loadingTotals();
    calculateTotals();
    return Future.delayed(const Duration(milliseconds: 0), () async {
      await updateQuote(quote);
      return loadingProductTotals();
    });
  }

  Future<void> highlightQtyLabel(bool value) async {
    product.isQtyLabelHighlight = value;
    return notifyListeners();
  }

}