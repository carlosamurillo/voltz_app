import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/utils/stats.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;

class CardItemViewModel extends ReactiveViewModel {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  final TextEditingController textEditingController = TextEditingController();
  double lastValue = 0;

  bool isQtyControlOpen = false;
  bool isCalculatorActive = false;
  bool isCardExpanded = false;

  bool get isQtyLabelHighlight => _isQtyLabelHighlight;
  bool _isQtyLabelHighlight = false;

  //estado para verificar si un producto esta siendo quitado
  QuoteModelRemoveStatus _modelRemoveStatus = QuoteModelRemoveStatus.initial;
  QuoteModelRemoveStatus get modelRemoveStatus => _modelRemoveStatus;

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

  final _authService = locator<AuthService>();
  UserSignStatus get userSignStatus => _authService.userSignStatus;

  final _quoteService = locator<QuoteService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [_quoteService, _authService];
  QuoteModel get quote => _quoteService.quote;
  List<Product> get selectedProducts => _quoteService.selectedProducts;

  /**Variables para manejar el foco de los imput y botones*/
  final FocusNode _focusNodeInput = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;
  FocusNode get focusNodeButton => _focusNodeButton;

  /*final FocusNode _focusAdd = FocusNode();
  final FocusNode _focusRemove = FocusNode();
  FocusNode get focusAdd => _focusAdd;
  FocusNode get focusRemove => _focusRemove;*/

  /*void requestFocusAdd(int cardIndex){
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
  }*/

  initCartView({
    required int cardIndex,
  }) {
    print('Se ejecuta initCardView de cart_item_viewmodel');
    selectedProducts[cardIndex].cardIndex = cardIndex;
    _focusNodeInput.addListener(() => _onFocusInputChange(cardIndex));
    _focusNodeButton.addListener(() => _onFocusButtonChange());
    /*_focusAdd.addListener(() => _onFocusAddChange(cardIndex));
    _focusRemove.addListener(() => _onFocusRemoveChange(cardIndex));*/
    textEditingController.text = selectedProducts[cardIndex].quantity!.toString();
  }

  void activateCalculator() async {
    isCalculatorActive = true;
    _focusNodeInput.requestFocus();
    notifyListeners();
  }

  void deactivateCalculator() async {
    isCalculatorActive = false;
    notifyListeners();
  }

  //desactivada la linea mientras se optimiza para
  void expandOrCollapseCard(int cardIndex) async {
    //await _quoteService.resetCards();
    selectedProducts[cardIndex].isCardExpanded = !selectedProducts[cardIndex].isCardExpanded;
    //isCardExpanded = !isCardExpanded;
    notifyListeners();
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
    } else {}
  }

  onPressCalculate(BuildContext context, int cardIndex) async {
    deactivateCalculator();
    await setCalculateVisibility(false);
    lastValue = double.tryParse(textEditingController.text) ?? 0;
    print('La cantidad que se va a guardar es ${textEditingController.text}');
    await onUpdateQuote(
      double.tryParse(textEditingController.text) ?? 0,
      cardIndex,
    );
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
      //return loadingProductTotals(cardIndex);
    });
  }

  setQuantity(int i, double quantity) {
    selectedProducts[i].quantity = quantity;
  }

  Future<void> onSelectedSku(bool value, int i, int b, int cardIndex) async {
    loadingProductTotals(cardIndex);
    selectedProducts[cardIndex].selected = value;
    loadingTotals();
    calculateTotals();
    await _quoteService.updateQuote(quote);
    loadingProductTotals(cardIndex);
    return Stats.SkuSeleccionado(
        quoteId: quote.id!,
        skuSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => Product(sku: null)).sku,
        productIdSuggested: quote.detail![i].productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => Product(id: null)).id,
        productRequested: quote.detail![i].productRequested!,
        countProductsSuggested: quote.detail![i].productsSuggested!.length);
  }

  Future<void> onDeleteSku(Detail value, context) async {
    _modelRemoveStatus = QuoteModelRemoveStatus.removing;
    notifyListeners();
    loadingTotals();
    quote.detail!.remove(value);
    quote.discardedProducts!.add(
      DiscardedProducts(
        requestedProducts: value.productRequested,
        reason: "No lo quiero.",
        position: value.position,
      ),
    );
    calculateTotals();
    await _quoteService.updateQuote(quote);
    _modelRemoveStatus = QuoteModelRemoveStatus.removed;
    notifyListeners();
    _showRemoveModelSnackbar(context);
    return Stats.SkuBorrado(
        quoteId: quote.id!,
        skuSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => Product(sku: null)).sku,
        productIdSuggested: value.productsSuggested?.firstWhere((element) => element.selected == true, orElse: () => Product(id: null)).id,
        productRequested: value.productRequested!,
        countProductsSuggested: value.productsSuggested!.length);
  }

  Future<void> addOne(int cardIndex) async {
    await highlightQtyLabel(true, cardIndex);
    selectedProducts[cardIndex].quantity = selectedProducts[cardIndex].quantity! + 1;
    textEditingController.text = selectedProducts[cardIndex].quantity!.toString();
    return notifyListeners();
  }

  Future<void> removeOne(int cardIndex) async {
    if (selectedProducts[cardIndex].quantity! > 1) {
      await highlightQtyLabel(true, cardIndex);
      selectedProducts[cardIndex].quantity = selectedProducts[cardIndex].quantity! - 1;
      textEditingController.text = selectedProducts[cardIndex].quantity!.toString();
      return notifyListeners();
    }
  }

  Future<void> saveQty(int cardIndex) async {
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
  void calculateTotals() {
    quote.record!.nextAction = 'calculate_totals';
  }

  void loadingAll(int productIndex) {
    _quoteService.loadingAll();
  }

  void loadingTotals() {
    _quoteService.loadingQuoteTotals();
  }

  void _showRemoveModelSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SelectableText(
        "Producto removido.",
        style: CustomStyles.styleVolcanicDos,
      ),
      backgroundColor: AppKeys().customColors!.energyGreen,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1000),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
      onVisible: () async {},
    ));
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

enum QuoteModelRemoveStatus { initial, removing, removed, none }
