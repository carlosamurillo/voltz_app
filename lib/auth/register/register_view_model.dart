import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends ReactiveViewModel {
  final _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [
        _authService,
      ];

  UserSignStatus get authSignStatus => _authService.userSignStatus;

  late bool _isBussiness;
  late Either<String, String> _nameOption;
  late Either<String, String> _lastNameOption;
  late Either<String, String> _emailOption;
  late Either<String, String> _rfcOption;
  late String _phoneNumber;

  late bool _showErrorMessages;
  late RegisterStatus _registerStatus;
  late bool _isProcessing;

  late bool _isValidForm;

  bool get isBusiness => _isBussiness;
  Either<String, String> get nameOption => _nameOption;
  Either<String, String> get lastNameOption => _lastNameOption;
  Either<String, String> get emailOption => _emailOption;
  Either<String, String> get rfcOption => _rfcOption;
  String get phoneNumber => _phoneNumber;
  bool get isValidForm => _isValidForm;

  RegisterStatus get registerStatus => _registerStatus;
  bool get isProcessing => _isProcessing;
  bool get showErrorMessages => _showErrorMessages;

  String? _quoteId;
  String? _orderId;

  void init(String phoneNumber, String? quoteId, String? orderId) {
    _quoteId = quoteId;
    _orderId = orderId;
    _isBussiness = false;
    _nameOption = left('');
    _lastNameOption = left('');
    _emailOption = left('');
    _rfcOption = left('');
    _phoneNumber = phoneNumber;
    _isProcessing = false;
    _showErrorMessages = false;
    _isValidForm = false;
    _registerStatus = RegisterStatus.initial;
  }

  void changeName(String? value) {
    if (value == null) return;
    _nameOption = value.length > 3 ? right(value) : left(value);
    validateFields();
    notifyListeners();
  }

  void changeLastName(String? value) {
    if (value == null) return;
    _lastNameOption = value.length > 3 ? right(value) : left(value);
    validateFields();
    notifyListeners();
  }

  void changeEmailAddress(String? value) {
    if (value == null) return;

    final regExp = RegExp(r"^([0-9a-zA-Z]([\+\-_\.][0-9a-zA-Z]+)*)+@(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]*\.)+[a-zA-Z0-9]{2,17})$");
    if (regExp.hasMatch(value)) {
      _emailOption = right(value);
    } else {
      _emailOption = left(value);
    }
    validateFields();
    notifyListeners();
  }

  void changeRfc(String? value) {
    if (value == null) return;
    final regExp = RegExp(r'^([A-ZÑ&]{3,4}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$');
    if (regExp.hasMatch(value)) {
      _rfcOption = right(value);
    } else {
      _rfcOption = left(value);
    }
    validateFields();
    notifyListeners();
  }

  void isBusinessChanged() {
    _isBussiness = !_isBussiness;
    validateFields();
    notifyListeners();
  }

  bool validateFields() {
    _isValidForm = nameOption.isRight() && //
        lastNameOption.isRight() &&
        emailOption.isRight() &&
        ((isBusiness && rfcOption.isRight()) || !isBusiness);
    _showErrorMessages = true;
    notifyListeners();
    return _isValidForm;
  }

  Future<void> register() async {
    _showErrorMessages = true;
    _isProcessing = true;
    _registerStatus = RegisterStatus.processing;
    notifyListeners();
    try {
      if (validateFields()) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Map<String, dynamic> data = {
            'created': FieldValue.serverTimestamp(),
            'email': emailOption.getOrElse(() => "INVALID EMAIL"),
            'full_name': nameOption.getOrElse(() => "INVALID NAME"),
            'last_name': lastNameOption.getOrElse(() => "INVALID NAME"),
            'phone': _phoneNumber,
            'role': "UserRole.User",
            'record': {'next_action': 'create_user', 'metadata': _quoteId}
          };
          if (isBusiness) {
            data["rfc"] = rfcOption.getOrElse(() => "INVALID RFC");
          }
          print(data);
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(data);
          _registerStatus = RegisterStatus.success;
          _isProcessing = false;
        } else {
          _registerStatus = RegisterStatus.failure;
          //deberia existir, sino no se deberia poder registrar
        }
        notifyListeners();
      } else {
        _registerStatus = RegisterStatus.initial;
        _isProcessing = false;
        notifyListeners();
      }
    } catch (e) {
      print("*luis error registro  $e");

      _registerStatus = RegisterStatus.failure;
      _isProcessing = false;
      notifyListeners();
    }
  }

  signOut() {
    _authService.signOut();
    navigateToHomeClearingAll();
  }

  navigateToHomeClearingAll() => _navigationService.clearStackAndShow(Routes.authGate, arguments: const AuthGateArguments(quoteId: null, orderId: null));

  navigateToSuccessRegister() {
    if (_quoteId != null) {
      final args = CartViewArguments(quoteId: _quoteId!);
      _navigationService.clearStackAndShow(Routes.cartView, arguments: args);
    } //
    else if (_orderId != null) {
      final args = OrderViewArguments(orderId: _orderId!, fromQuote: false);
      _navigationService.clearStackAndShow(Routes.orderView, arguments: args);
    } //
    else if (_navigationService.previousRoute.isNotEmpty) {
      _navigationService.back();
    } else {
      navigateToHomeClearingAll();
    }
  }
}

enum RegisterStatus { initial, processing, success, failure }
