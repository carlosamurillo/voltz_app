import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/product/product_model.dart';
import 'package:maketplace/product/product_service.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ToBuyNowViewModel extends ReactiveViewModel {
  final _productService = locator<ProductService>();
  final NavigationService _navigationService = locator<NavigationService>();
  Product? get product => _productService.product;
  double get priceToMultiply => _productService.priceToMultiply;

  @override
  List<ListenableServiceMixin> get listenableServices => [_productService];

  final TextEditingController textEditingController = TextEditingController(text: '0');

  double currentValue = 0;
  double changedValue = 0;
  bool showUpdateButton = false;
  bool disappearButtons = false;
  double totalCalculateValue = 0;
  double subtotalValue = 0;

  final FocusNode _focusNodeInput = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;

  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  init(String productId) async {
    return _productService.init(productId);
  }

  void onQuantityChanged() {
    if (double.tryParse(textEditingController.text) != null) {
      changedValue = double.parse(textEditingController.text);
      showUpdateButton = true;
    }
    notifyListeners();
  }

  void onTap() {
    if (!_focusNodeInput.hasFocus) {
      _focusNodeInput.requestFocus();
    }

    disappearButtons = true;
    notifyListeners();
  }

  void disappearButtonsFunc() {
    disappearButtons = true;
    if (!_focusNodeInput.hasFocus) {
      _focusNodeInput.requestFocus();
    }
    notifyListeners();
  }

  void onQuantityUpdated() {
    focusNodeInput.unfocus();
    disappearButtons = false;
    showUpdateButton = false;
    if (changedValue != currentValue) {
      currentValue = changedValue;
      totalCalculateValue = priceToMultiply * currentValue;
      subtotalValue = totalCalculateValue * 0.74;
    }
    notifyListeners();
  }

  // void reduceQuantity() {
  //   if (lastValue <= 1) return;
  //   lastValue = lastValue - 1;
  //   textEditingController.text = lastValue.toString();
  //   print(product);
  //   totalCalculateValue = priceToMultiply * lastValue;
  //   subtotalValue = totalCalculateValue * 0.74;
  //   notifyListeners();
  // }

  // void addQuantity() {
  //   lastValue = lastValue + 1;
  //   textEditingController.text = lastValue.toString();
  //   totalCalculateValue = priceToMultiply * lastValue;
  //   subtotalValue = totalCalculateValue * 0.74;
  //   notifyListeners();
  // }

  void onSavedChanges() {
    showUpdateButton = false;
    _focusNodeInput.unfocus();
    notifyListeners();
  }

  void onGenerateOrder(BuildContext context) async {
    final created = await _productService.createOrder();
    if (created) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText(
          "Gracias, hemos recibido tu orden.",
          style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
        ),
        backgroundColor: AppKeys().customColors!.energyColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 5000),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
        onVisible: () async {},
      ));
      _navigationService.replaceWithOrderView(orderId: _productService.quoteModel!.id!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: SelectableText(
          "No se ha podido crear tu orden.",
          style: CustomStyles.styleVolcanicDos.copyWith(color: Colors.white),
        ),
        backgroundColor: AppKeys().customColors!.redAlert,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 5000),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 40, right: 20, left: 20),
        onVisible: () async {},
      ));
    }
  }

//
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
