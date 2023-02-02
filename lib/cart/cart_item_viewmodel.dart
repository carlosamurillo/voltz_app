import 'dart:async';

import 'package:intl/intl.dart' as intl;
import 'package:flutter/cupertino.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';

import '../quote/quote_model.dart';
import '../utils/stats.dart';

class CartItemViewModel extends QuoteViewModel {

  bool isCardExpanded = false;

  var currencyFormat =
  intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();
  double lastValue = 0;
  final ValueNotifier<bool> _notifier = ValueNotifier(false);
  ValueNotifier<bool> get notifier => _notifier;

  bool isQtyControlOpen = false;
  bool isQtyLabelElevated = false;

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


  /**Variables para manejar el foco de los imput y botones*/
  final FocusNode _focusNodeInput = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;
  FocusNode get focusNodeButton => _focusNodeButton;

  final FocusNode _focusAdd = FocusNode();
  FocusNode get focusAdd => _focusAdd;

  final FocusNode _focusRemove = FocusNode();
  FocusNode get focusRemove => _focusRemove;

  /**Producto sugerido seleccionado, es decir selected = true*/
  late ProductsSuggested product;
  /**Pocision del producto seleccionado, es decir selected = true*/
  late int suggestedIndex;
  late int cartIndex;
  
  void initCartView({required int cartIndex}) {
    this.cartIndex = cartIndex;
    int count = 0;
    print('line 1');
    quote.detail![this.cartIndex].productsSuggested
        ?.forEach((element) {
      if (element.selected == true) {
        product = element;
        suggestedIndex = count;
        return;
      }
      count = count + 1;
    });
    print('line 2');
    _focusNodeInput.addListener(() => _onFocusInputChange());
    _focusNodeButton.addListener(() => _onFocusButtonChange());
    _focusAdd.addListener(() => _onFocusAddChange());
    _focusRemove.addListener(() => _onFocusRemoveChange());
    print('line 3');
    textEditingController.text = quote.detail![cartIndex]
        .productsSuggested![suggestedIndex].quantity!
        .toString();
    print('line 4');
    textEditingController.text = quote.detail![cartIndex]
        .productsSuggested![suggestedIndex].quantity!
        .toString();
    print('line 5');
    return notifyListeners();
  }

  void initExpandableCard({required int cartIndex}){

  }

  Future<void> activateCalculator() async {
    product.isCalculatorActive = true;
    _focusNodeInput.requestFocus();
    notifyListeners();
  }

  Future<void> deactivateCalculator() async {
    product.isCalculatorActive = false;
    return notifyListeners();
  }

  Future<void> expandOrCollapseCard() async {
    print('expandida...' + isCardExpanded.toString());
    print(cartIndex);
    print(suggestedIndex);
    print(quote.detail.toString());
    await resetCards();
    isCardExpanded = !isCardExpanded;
    print('toma 1');
    quote.detail![cartIndex]
        .productsSuggested![suggestedIndex].isCardExpanded = isCardExpanded;
    print('toma 2');
    return notifyListeners();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textEditingController.dispose();
    _notifier.dispose();
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

  _onFocusAddChange() async {
    print('From viemodel focusAdd Has Focus:  ${_focusAdd.hasFocus}');
    if (!_focusAdd.hasFocus && !_focusRemove.hasFocus) {
      saveQty();
      deElevateQty();
    }
  }

  _onFocusRemoveChange() async {
    print('From viemodel focusRemove Has Focus:  ${_focusRemove.hasFocus}');
    if (!_focusRemove.hasFocus && !_focusAdd.hasFocus) {
      saveQty();
      deElevateQty();
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
        cartIndex,
        suggestedIndex,
        double.tryParse(
            textEditingController
                .text) ??
            0);

  }

  areaLostFocus() async {
    if (!quote.isCalculatingTotals) {
      deactivateCalculator();
      textEditingController.text = quote.detail![cartIndex]
          .productsSuggested![suggestedIndex].quantity!
          .toString();
      await setCalculateVisibility(false);
    }
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

  Future<void> onUpdateQuote(int i, int b, double quantity) async {
    loadingAll(i);
    setQuantity(i, b, quantity);
    calculateTotals();
    return Future.delayed(const Duration(milliseconds: 0), () async {
      await updateQuote(quote);
    });
  }

  Future<void> onSelectedSku(bool value, int i, int b) async {
    loadingAll(i);
    quote.detail![i].productsSuggested![b].selected = value;
    calculateTotals();
    await updateQuote(quote);
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
    elevateQty();
    textEditingController.text = (double.parse(textEditingController.text) + 1).toString();
    return notifyListeners();
  }

  Future<void> removeOne() async {
    if(quote.detail![cartIndex].productsSuggested![suggestedIndex].quantity! > 1) {
      elevateQty();
      textEditingController.text = (double.parse(textEditingController.text) - 1).toString();
      return notifyListeners();
    }
  }

  Future<void> saveQty () async {
    if(quote.detail![cartIndex].productsSuggested![suggestedIndex].quantity != double.parse(textEditingController.text)) {
      loadingAll(cartIndex);
      quote.detail![cartIndex].productsSuggested![suggestedIndex].quantity =
          double.parse(textEditingController.text);
      calculateTotals();
      return Future.delayed(const Duration(milliseconds: 0), () async {
        await updateQuote(quote);
      });
    }
  }

  Future<void> elevateQty() async {
    isQtyLabelElevated = true;
    return notifyListeners();
  }

  Future<void> deElevateQty() async {
    isQtyLabelElevated = false;
    return notifyListeners();
  }



}