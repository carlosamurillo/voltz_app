
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginService  with ListenableServiceMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  final RxValue<bool> _rxAcceptWhatsapp = RxValue<bool>(false);
  bool get acceptWhatsapp => _rxAcceptWhatsapp.value;

  final RxValue<Either<String, String>> _rxPhoneNumber = RxValue<Either<String, String>>(left(''));
  Either<String, String> get phoneNumber => _rxPhoneNumber.value;

  final RxValue<Either<String, String>> _rxCodeNumber = RxValue<Either<String, String>>(left(''));
  Either<String, String> get codeNumber => _rxCodeNumber.value;

  final RxValue<bool> _rxIsProcessing = RxValue<bool>(false);
  bool get isProcessing => _rxIsProcessing.value;

  final RxValue<bool> _rxShowErrorMessages = RxValue<bool>(false);
  bool get showErrorMessages => _rxShowErrorMessages.value;

  final RxValue<String> _rxVerificationId = RxValue<String>('');
  String get _verificationId => _rxVerificationId.value;

  final RxValue<LoginScreenStatus> _rxLoginScreenStatus = RxValue<LoginScreenStatus>(LoginScreenStatus.loginScreen);
  LoginScreenStatus get loginScreenStatus => _rxLoginScreenStatus.value;

  LoginService() {
    listenToReactiveValues([_rxAcceptWhatsapp, _rxPhoneNumber, _rxCodeNumber, _rxIsProcessing,
      _rxShowErrorMessages, _rxVerificationId, _rxLoginScreenStatus, ]);
  }

  Future<void> login() async {
    _rxShowErrorMessages.value = true;
    notifyListeners();
    if (phoneNumber.isLeft() && !acceptWhatsapp) return;
    _rxIsProcessing.value = true;
    notifyListeners();
    try {
      print("*luis  +52${phoneNumber.getOrElse(() => "INCORRECT NUMBER")}");

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+52${phoneNumber.getOrElse(() => "INCORRECT NUMBER")}",
        verificationCompleted: (credential) {
          //hacer login directo
        },
        verificationFailed: (exception) {
          //show exception
        },
        codeSent: (verificationId, _) {
          _rxLoginScreenStatus.value = LoginScreenStatus.inputCodeScreen;
          _rxIsProcessing.value = false;
          notifyListeners();
          _rxVerificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _rxVerificationId.value  = verificationId;
        },
      );
    } on Exception catch (e) {
      print("*luis inicio sesion  $e");
      _rxLoginScreenStatus.value = LoginScreenStatus.failure;
    } catch (e) {
      print("*luis error inicio sesion  $e");
      _rxLoginScreenStatus.value  = LoginScreenStatus.failure;
    }
    _rxIsProcessing.value = false;
    notifyListeners();
  }

  Future<void> validateCode() async {
    try {
      _rxShowErrorMessages.value = true;
      notifyListeners();
      if (codeNumber.isLeft()) return;

      _rxIsProcessing.value = true;
      notifyListeners();

      print("*luis $codeNumber");

      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: codeNumber.getOrElse(() => "INCORRECT CODE"),
      );

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      _verifySignedInUser();
    } on Exception catch (e) {
      print("*luis exception codigo  $e");
      _rxLoginScreenStatus.value = LoginScreenStatus.failure;
    } catch (e) {
      print("*luis error codigo  $e");
      _rxLoginScreenStatus.value = LoginScreenStatus.failure;
    }

    _rxIsProcessing.value = false;
    notifyListeners();
  }

  changePhoneNumber(String? newPhoneNumber) async {
    final regExp = RegExp(r'(^[0-9]{10,10}$)');
    if (newPhoneNumber == null) return;
    if (regExp.hasMatch(newPhoneNumber)) {
      _rxPhoneNumber.value = right(newPhoneNumber);
    } else {
      _rxPhoneNumber.value = left(newPhoneNumber);
    }
    notifyListeners();
  }

  changeCode(String? value) async {
    if (value == null) return;
    final codeValidatorRegExp = RegExp('[0-9]{6}');
    if (codeValidatorRegExp.hasMatch(value)) {
      _rxCodeNumber.value = right(value);
    } else {
      _rxCodeNumber.value  = left(value);
    }
  }

  Future<void> _verifySignedInUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _verifyUserRegister(user.uid);
    }
    notifyListeners();
  }

  Future<void> _verifyUserRegister(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        print("*luis  enviar al overview  $userDoc");
        _rxLoginScreenStatus.value = LoginScreenStatus.overview;
      } else {
        print("*luis  enviar a la pantalla de registro ");
        _rxLoginScreenStatus.value = LoginScreenStatus.registerScreen;
      }
      notifyListeners();
    } catch (e) {
      _rxLoginScreenStatus.value = LoginScreenStatus.failure;
      print("*luis error verificar usuario  $e");
    }
  }

  checkboxWhatsappChanged() async {
    _rxAcceptWhatsapp.value = !acceptWhatsapp;
    notifyListeners();
  }
}

enum LoginScreenStatus { loginScreen, inputCodeScreen, registerScreen, overview, failure, none }