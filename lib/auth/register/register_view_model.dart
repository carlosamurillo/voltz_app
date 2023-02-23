import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart';

class RegisterViewModel extends ReactiveViewModel {

  final _authService = locator<AuthService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [ _authService, ];

  UserSignStatus get authSignStatus => _authService.userSignStatus;

  late bool _isBussiness;
  late Either<String, String> _nameOption;
  late Either<String, String> _lastNameOption;
  late Either<String, String> _emailOption;
  late Either<String, String> _rfcOption;

  late bool _showErrorMessages;
  late RegisterStatus _registerStatus;
  late bool _isProcessing;

  bool get isBusiness => _isBussiness;
  Either<String, String> get nameOption => _nameOption;
  Either<String, String> get lastNameOption => _lastNameOption;
  Either<String, String> get emailOption => _emailOption;
  Either<String, String> get rfcOption => _rfcOption;

  RegisterStatus get registerStatus => _registerStatus;
  bool get isProcessing => _isProcessing;
  bool get showErrorMessages => _showErrorMessages;

  void init() {
    _isBussiness = false;
    _nameOption = left('');
    _lastNameOption = left('');
    _emailOption = left('');
    _rfcOption = left('');
    _isProcessing = false;
    _showErrorMessages = false;
    _registerStatus = RegisterStatus.initial;
  }

  void changeName(String? value) {
    if (value == null) return;
    _nameOption = value.length > 5 ? right(value) : left(value);
    notifyListeners();
  }

  void changeLastName(String? value) {
    if (value == null) return;
    _lastNameOption = value.length > 5 ? right(value) : left(value);
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
    notifyListeners();
  }

  void isBusinessChanged() {
    _isBussiness = !_isBussiness;
    notifyListeners();
  }

  Future<void> register(String phoneNumber) async {
    _showErrorMessages = true;
    _isProcessing = true;
    _registerStatus = RegisterStatus.processing;
    notifyListeners();
    try {
      if (nameOption.isRight() && lastNameOption.isRight() && emailOption.isRight() && ((isBusiness && rfcOption.isRight()) || !isBusiness)) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Map<String, dynamic> data = {
            'created': FieldValue.serverTimestamp(),
            'email': emailOption.getOrElse(() => "INVALID EMAIL"),
            'full_name': nameOption.getOrElse(() => "INVALID NAME"),
            'phone': phoneNumber,
            'role': "UserRole.User",
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

  signOut() => _authService.signOut();
}

enum RegisterStatus { initial, processing, success, failure }
