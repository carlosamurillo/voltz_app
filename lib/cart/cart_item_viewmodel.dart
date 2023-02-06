import 'dart:async';

import 'package:intl/intl.dart' as intl;
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

import '../app/app.locator.dart';
import '../quote/quote_model.dart';
import '../quote/quote_service.dart';
import '../utils/stats.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;

class CardItemViewModel extends ReactiveViewModel {

  var currencyFormat =
  intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  final TextEditingController textEditingController = TextEditingController();
  double lastValue = 0;

  bool isQtyControlOpen = false;
  bool isCalculatorActive = false;
 
  bool get isQtyLabelHighlight => _isQtyLabelHighlight;
  bool _isQtyLabelHighlight = false;

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
  QuoteModel get quote => _quoteService.quote;
  List<ProductsSuggested> get selectedProducts => _quoteService.selectedProducts;

  /**Variables para manejar el foco de los imput y botones*/
  final FocusNode _focusNodeInput = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;
  FocusNode get focusNodeButton => _focusNodeButton;

  final FocusNode _focusAdd = FocusNode();
  final FocusNode _focusRemove = FocusNode();
  FocusNode get focusAdd => _focusAdd;
  FocusNode get focusRemove => _focusRemove;
  
  void requestFocusAdd(int cardIndex){
    _focusAdd.requestFocus();
  }
  void unFocusAdd(int cardIndex){
    _focusAdd.unfocus();
  }
  void requestFocusRemove(int cardIndex){
    _focusRemove.requestFocus();
  }
  void unFocusRemove(int cardIndex){
    _focusRemove.unfocus();
  }

  _onFocusAddChange(int cardIndex) async {
    print('From viemodel focusAdd con indice $cardIndex Has Focus:  ${_focusAdd.hasFocus}');
    if (!_focusAdd.hasFocus && !_focusRemove.hasFocus) {
      print('xxxxxx');
      saveQty(cardIndex);
      await highlightQtyLabel(false, cardIndex);
    }
  }

  _onFocusRemoveChange(int cardIndex) async {
    print('From viemodel focusRemove con indice $cardIndex Has Focus:  ${_focusRemove.hasFocus}');
    if (!_focusRemove.hasFocus && !_focusAdd.hasFocus) {
      print('bbbbbb');
      saveQty(cardIndex);
      await highlightQtyLabel(false, cardIndex);
    }
  }

  void initCartView({required int cardIndex,}) {
    print('Se ejecuta initCardView de cart_item_viewmodel');

    selectedProducts[cardIndex].cardIndex = cardIndex;
    _focusNodeInput.addListener(() => _onFocusInputChange(cardIndex));
    _focusNodeButton.addListener(() => _onFocusButtonChange());
    _focusAdd.addListener(() => _onFocusAddChange(cardIndex));
    _focusRemove.addListener(() => _onFocusRemoveChange(cardIndex));
    textEditingController.text = selectedProducts[cardIndex].quantity!.toString();

    return notifyListeners();
  }

  Future<void> activateCalculator() async {
    isCalculatorActive = true;
    _focusNodeInput.requestFocus();
    return notifyListeners();
  }

  Future<void> deactivateCalculator() async {
    isCalculatorActive = false;
    return notifyListeners();
  }

  Future<void> expandOrCollapseCard(int cardIndex) async {
    await _quoteService.resetCards();
    selectedProducts[cardIndex].isCardExpanded = !selectedProducts[cardIndex].isCardExpanded;
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

  _onFocusInputChange(int cardIndex) async {
    print('_onFocusInputChange con indice $cardIndex Has Focus: ${_focusNodeButton.hasFocus}');
    if (!_focusNodeInput.hasFocus && !_focusNodeButton.hasFocus) {
      areaLostFocus(cardIndex);
    }
  }

  _onFocusButtonChange() async {
    print('Button Has Focus:  ${_focusNodeButton.hasFocus}');
    if (_focusNodeButton.hasFocus) {
    } else {
    }
  }

  onPressCalculate(BuildContext context, int cardIndex) async {
    deactivateCalculator();
    await setCalculateVisibility(false);
    lastValue = double.tryParse(textEditingController.text) ?? 0;
    print('La cantidad que se va a guardar es ${textEditingController.text}');
    await onUpdateQuote(double.tryParse(textEditingController.text) ?? 0,
      cardIndex,);

  }

  areaLostFocus(int cardIndex) async {
    print('areaLostFocus metodo...');
    if (!quote.isCalculatingTotals) {
      textEditingController.text = selectedProducts[cardIndex].quantity!.toString();
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

  Future<void> loadingProductTotals(int cardIndex) async {
    selectedProducts[cardIndex].isCalculatingProductTotals = !selectedProducts[cardIndex].isCalculatingProductTotals;
    return notifyListeners();
  }

  Future<void> onUpdateQuote(double quantity, int cardIndex) async {
    loadingProductTotals(cardIndex);
    loadingTotals();
    setQuantity(cardIndex, quantity);
    calculateTotals();
    return Future.delayed(const Duration(milliseconds: 0), () async {
      await _quoteService.updateQuote(quote);
      return loadingProductTotals(cardIndex);
    });
  }

  setQuantity(int i, double quantity){
    selectedProducts[i].quantity = quantity;
  }

  Future<void> onSelectedSku(bool value, int i, int b, int cardIndex) async {
    loadingProductTotals(cardIndex);
    selectedProducts[cardIndex].selected = value;
    loadingTotals();
    calculateTotals();
    await _quoteService.updateQuote(quote);
    loadingProductTotals(cardIndex);
    return Stats.SkuSeleccionado(quoteId: quote.id!, skuSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true,  orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: quote.detail![i].productRequested!,
        countProductsSuggested: quote.detail![i].productsSuggested!.length);
  }

  Future<void> onDeleteSku(Detail value) async {
    loadingTotals();
    quote.detail!.remove(value);
    quote.discardedProducts!.add(DiscardedProducts(requestedProducts: value.productRequested, reason: "No lo quiero.", position: value.position));
    calculateTotals();
    await _quoteService.updateQuote(quote);
    return Stats.SkuBorrado(quoteId: quote.id!, skuSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(sku: null)).sku,
        productIdSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => ProductsSuggested(productId: null)).productId, productRequested: value.productRequested!,
        countProductsSuggested: value.productsSuggested!.length);
  }

  Future<void> addOne(int cardIndex) async {
    await highlightQtyLabel(true, cardIndex);
    selectedProducts[cardIndex].quantity = selectedProducts[cardIndex].quantity! + 1;
    textEditingController.text = selectedProducts[cardIndex].quantity!.toString();
    return notifyListeners();
  }

  Future<void> removeOne(int cardIndex) async {
    if(selectedProducts[cardIndex].quantity! > 1) {
      await highlightQtyLabel(true, cardIndex);
      selectedProducts[cardIndex].quantity = selectedProducts[cardIndex].quantity! - 1;
      textEditingController.text = selectedProducts[cardIndex].quantity!.toString();
      return notifyListeners();
    }
  }

  Future<void> saveQty (int cardIndex) async {
    await loadingProductTotals(cardIndex);
    loadingTotals();
    calculateTotals();
    return Future.delayed(const Duration(milliseconds: 0), () async {
      await _quoteService.updateQuote(quote);
      return loadingProductTotals(cardIndex);
    });
  }

  highlightQtyLabel(bool value, int cardIndex) async {
    print('highlightQtyLabel ... $value');
    _isQtyLabelHighlight = value;
    return notifyListeners();
  }

  // instruccion para que el backend calcule totales
  void calculateTotals(){
    quote.record!.nextAction = 'calculate_totals';
  }

  void loadingAll (int productIndex) {
    _quoteService.loadingAll();
  }

  void loadingTotals () {
    _quoteService.loadingQuoteTotals();
  }

  final shimmerGradientWhiteBackground = const LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
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

}