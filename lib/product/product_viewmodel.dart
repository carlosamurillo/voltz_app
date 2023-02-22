import 'package:flutter/cupertino.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/product/product_service.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/utils/added_dialog.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart' as intl;
import '../app/app.locator.dart';
import 'product_model.dart';
import 'dart:js' as js;

class ProductViewModel  extends ReactiveViewModel  {
  final _productsService = ProductService();

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_productsService];

  Product? get product => _productsService.getCopyOfProduct();
  final currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  void init(String productId) async {
    print('ProductViewModel ... productId ... ' + productId);
    _productsService.init(productId);
    notifyListeners();
  }

  Future<void> openTechFile(String url) async {
    js.context.callMethod('open', [url]);
  }

  Future<void> openWebPage(String url) async {
    js.context.callMethod('open', [url]);
  }

  navigateBack() async {
    _navigationService.back();
  }
}


class ProductCardViewModel extends ReactiveViewModel {

  final NavigationService _navigationService = locator<NavigationService>();
  late Product product;
  var currencyFormat =
  intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  void init(Product product) async {
    this.product = product;
    _focusNodeInput.addListener(() => _onFocusInputChange());
    _focusNodeButton.addListener(() => _onFocusButtonChange());
    /*_focusAdd.addListener(() => _onFocusAddChange(cardIndex));
    _focusRemove.addListener(() => _onFocusRemoveChange(cardIndex));*/
    textEditingController.text = product.quantity.toString();
  }

  final _authService = locator<AuthService>();
  UserSignStatus get userSignStatus => _authService.userSignStatus;
  @override
  List<ListenableServiceMixin> get listenableServices => [_authService,];

  bool isCardExpanded = false;
  //desactivada la linea mientras se optimiza para
  Future<void> expandOrCollapseCard() async {
    isCardExpanded = !isCardExpanded;
    product.isCardExpanded = !product.isCardExpanded;
    return notifyListeners();
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

  ///Se trae el servicio QuoteService para anadir productos a una cotizacion
  final _quoteService = locator<QuoteService>();
  addProductToQuote(String idProduct, BuildContext context) async {
    _quoteService.addProductToQuote(idProduct);
    _showNotificationDialog(context);
  }

  _showNotificationDialog(BuildContext context) async {
    showNotificationDialog(context);
  }

  _showSimpleNotification() async {
    /*return showOverlayNotification((context) {
      return const BaseNotificationWidget();
    }, duration: const Duration(seconds: 10), position: NotificationPosition.bottom,);*/
  }

  buyNow(String productId) async {
    return _navigationService.navigateToBuyNowView(productId: productId);
  }


  /**Variables para manejar el foco de los imput y botones*/
  final FocusNode _focusNodeInput = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();
  FocusNode get focusNodeInput => _focusNodeInput;
  FocusNode get focusNodeButton => _focusNodeButton;

  final TextEditingController textEditingController = TextEditingController();
  double lastValue = 0;

  bool isQtyControlOpen = false;
  bool isCalculatorActive = false;
  bool get isQtyLabelHighlight => _isQtyLabelHighlight;
  bool _isQtyLabelHighlight = false;


  void activateCalculator() async {
    isCalculatorActive = true;
    _focusNodeInput.requestFocus();
    notifyListeners();
  }

  void deactivateCalculator() async {
    isCalculatorActive = false;
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

  _onFocusInputChange() async {
    print('_onFocusInputChange Has Focus: ${_focusNodeButton.hasFocus}');
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

  areaLostFocus() async {
    print('areaLostFocus metodo...');
    if (!product.isCalculatingProductTotals) {
      textEditingController.text = product.quantity.toString();
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

  onPressCalculate(BuildContext context,) async {
    deactivateCalculator();
    await setCalculateVisibility(false);
    lastValue = double.tryParse(textEditingController.text) ?? 0;
    print('La cantidad que se va a guardar es ${textEditingController.text}');
    setQuantity(double.tryParse(textEditingController.text) ?? 0);
  }

  setQuantity(double quantity){
    product.quantity = quantity;
  }
}