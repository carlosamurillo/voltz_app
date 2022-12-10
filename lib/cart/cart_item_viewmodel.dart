import 'package:intl/intl.dart' as intl;
import 'package:flutter/cupertino.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';

import '../quote/quote_model.dart';

class CartItemViewModel extends QuoteViewModel {

  var currencyFormat =
  intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();
  double lastValue = 0;
  final ValueNotifier<bool> _notifier = ValueNotifier(false);
  ValueNotifier<bool> get notifier => _notifier;

  /**Variables para manejar el foco de los imput y botones*/
  final FocusNode _focusNodeInput = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;
  FocusNode get focusNodeButton => _focusNodeButton;

  /**Producto sugerido seleccionado, es decir selected = true*/
  late ProductsSuggested product;
  /**Pocision del producto seleccionado, es decir selected = true*/
  late int suggestedIndex;
  late int cartIndex;
  
  void initCartView({required int cartIndex}) {
    this.cartIndex = cartIndex;
    int count = 0;
    print('line 1');
    quote.detail![count].productsSuggested
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
    print('line 3');
    textEditingController.text = quote.detail![cartIndex]
        .productsSuggested![suggestedIndex].quantity!
        .toString();
    print('line 4');
    textEditingController.text = quote.detail![count]
        .productsSuggested![suggestedIndex].quantity!
        .toString();
    print('line 5');
    notifyListeners();
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
      changeStatusModify(false);
    } else if (lastValue != qty) {
      changeStatusModify(true);
    } else {
      changeStatusModify(false);
    }
    return qty;
  }

  _onFocusInputChange() async {
    print('Input Has Focus:  ${_focusNodeInput.hasFocus}');
    if (_focusNodeInput.hasFocus) {
      //changeStatusModify(true);
    } else {
      areaLostFocus();
      //await showModifyLabel(false);
    }
  }

  _onFocusButtonChange() async {
    print('Button Has Focus:  ${_focusNodeButton.hasFocus}');
    if (_focusNodeButton.hasFocus) {
      //changeStatusModify(true);
    } else {
      areaLostFocus();
      //await showModifyLabel(false);
    }
  }

  areaLostFocus() async {
    //lastValue =  quote.detail![i].productsSuggested![selectedPosition].quantity!;
    if (!isCalculatingProductTotal &&
        !_focusNodeButton.hasFocus) {
      textEditingController.text = quote.detail![cartIndex]
          .productsSuggested![suggestedIndex].quantity!
          .toString();
      await changeStatusModify(false);
    }
  }

  changeStatusModify(bool value) async {
    _notifier.value = value;
  }

  void setFocusInput(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNodeInput);
  }

  void setFocusButton(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNodeButton);
  }

}