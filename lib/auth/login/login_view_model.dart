import 'package:dartz/dartz.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/auth/login/login_service.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart' show NavigationService;

class LoginViewModel extends ReactiveViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final _loginService = locator<LoginService>();
  final _authService = locator<AuthService>();

  UserSignStatus get authSignStatus => _authService.userSignStatus;

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _loginService,
        _authService,
      ];

  bool get isWhatsappCheckboxAccepted => _loginService.acceptWhatsapp;
  bool get showErrorMessages => _loginService.showErrorMessages;
  bool get loginButtonEnabled => _loginService.loginButtonEnabled;
  bool get checkCodeButtonEnabled => _loginService.checkCodeButtonEnabled;
  bool get isProcessing => _loginService.isProcessing;
  Either<String, String> get phoneNumber => _loginService.phoneNumber;
  Either<String, String> get codeNumber => _loginService.codeNumber;
  LoginScreenStatus get loginScreenStatus => _loginService.loginScreenStatus;

  String? _quoteId;
  String? _orderId;

  init(String? quoteId, String? ordderId) {
    _quoteId = quoteId;
    _orderId = ordderId;
    notifyListeners();
  }

  void checkboxWhatsappChanged() {
    _loginService.checkboxWhatsappChanged();
    notifyListeners();
  }

  login() => _loginService.login();

  changePhoneNumber(String? newPhoneNumber) => _loginService.changePhoneNumber(newPhoneNumber);

  changeCode(String? value) => _loginService.changeCode(value);

  validateCode() async {
    _authService.setRedirect(false);
    _loginService.validateCode();
  }

  navigateToBack() {
    if (_navigationService.previousRoute.isNotEmpty) {
      _navigationService.back();
    } else {
      navigateToHomeClearingAll();
    }
  }

  navigateToHomeClearingAll() => _navigationService.clearStackAndShow(Routes.authGate, arguments: const AuthGateArguments(quoteId: null, orderId: null));

  navigateLoginSuccess() {
    if (_quoteId != null) {
      final args = CartViewArguments(quoteId: _quoteId!);
      _navigationService.clearStackAndShow(Routes.cartView, arguments: args);
    } //
    else if (_orderId != null) {
      final args = OrderViewArguments(orderId: _orderId!);
      _navigationService.clearStackAndShow(Routes.orderView, arguments: args);
    } //
    else if (_navigationService.previousRoute.isNotEmpty) {
      _navigationService.back();
    } else {
      navigateToHomeClearingAll();
    }
  }

  navigateToCodeValidatorView() {
    _loginService.updateLoginScreenStatus(LoginScreenStatus.none);
    notifyListeners();

    _navigationService.navigateToCodeValidatorView(quoteId: _quoteId, orderId: _orderId);
  }

  navigateToRegisterView(String phoneNumber) {
    _loginService.updateLoginScreenStatus(LoginScreenStatus.none);
    notifyListeners();
    _navigationService.navigateToRegisterView(phoneNumber: phoneNumber, quoteId: _quoteId);
  }
}
