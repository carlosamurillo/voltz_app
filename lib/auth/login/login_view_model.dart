import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  late bool _acceptWhatsapp;
  late Either<String, String> _phoneNumber;
  late Either<String, String> _codeNumber;
  late bool _isProcessing;
  late bool _showErrorMessages;
  late String _verificationId;
  late LoginScreenStatus _loginScreenStatus;

  bool get isWhatsappCheckboxAccepted => _acceptWhatsapp;
  bool get showErrorMessages => _showErrorMessages;
  bool get isProcessing => _isProcessing;
  Either<String, String> get phoneNumber => _phoneNumber;
  Either<String, String> get codeNumber => _codeNumber;
  LoginScreenStatus get loginScreenStatus => _loginScreenStatus;

  void init() {
    _acceptWhatsapp = false;
    _showErrorMessages = false;
    _isProcessing = false;
    _phoneNumber = left('');
    _codeNumber = left('');
    _verificationId = '';
    _loginScreenStatus = LoginScreenStatus.loginScreen;
  }

  void checkboxWhatsappChanged() {
    _acceptWhatsapp = !_acceptWhatsapp;
    notifyListeners();
  }

  Future<void> login() async {
    _showErrorMessages = true;
    notifyListeners();
    if (_phoneNumber.isLeft() && !_acceptWhatsapp) return;
    _isProcessing = true;
    notifyListeners();
    try {
      print("*luis  +52${_phoneNumber.getOrElse(() => "INCORRECT NUMBER")}");

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+52${_phoneNumber.getOrElse(() => "INCORRECT NUMBER")}",
        verificationCompleted: (credential) {
          //hacer login directo
        },
        verificationFailed: (exception) {
          //show exception
        },
        codeSent: (verificationId, _) {
          _loginScreenStatus = LoginScreenStatus.inputCodeScreen;
          _isProcessing = false;
          notifyListeners();
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = _verificationId;
        },
      );
    } on Exception catch (e) {
      print("*luis inicio sesion  $e");
      _loginScreenStatus = LoginScreenStatus.failure;
    } catch (e) {
      print("*luis error inicio sesion  $e");
      _loginScreenStatus = LoginScreenStatus.failure;
    }
    _isProcessing = false;
    notifyListeners();
  }

  Future<void> validateCode() async {
    try {
      _showErrorMessages = true;
      notifyListeners();
      if (_codeNumber.isLeft()) return;

      _isProcessing = true;
      notifyListeners();

      print("*luis $_codeNumber");

      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _codeNumber.getOrElse(() => "INCORRECT CODE"),
      );

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      _verifiySignedInUser();
    } on Exception catch (e) {
      print("*luis exception codigo  $e");
      _loginScreenStatus = LoginScreenStatus.failure;
    } catch (e) {
      print("*luis error codigo  $e");
      _loginScreenStatus = LoginScreenStatus.failure;
    }

    _isProcessing = false;
    notifyListeners();
  }

  void changePhoneNumber(String? newPhoneNumber) {
    final regExp = RegExp(r'(^[0-9]{10,10}$)');
    if (newPhoneNumber == null) return;
    if (regExp.hasMatch(newPhoneNumber)) {
      _phoneNumber = right(newPhoneNumber);
    } else {
      _phoneNumber = left(newPhoneNumber);
    }
    notifyListeners();
  }

  void changeCode(String? value) {
    if (value == null) return;
    final codeValidatorRegExp = RegExp('[0-9]{6}');
    if (codeValidatorRegExp.hasMatch(value)) {
      _codeNumber = right(value);
    } else {
      _codeNumber = left(value);
    }
  }

  Future<void> _verifiySignedInUser() async {
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
        _loginScreenStatus = LoginScreenStatus.overview;
      } else {
        print("*luis  enviar a la pantalla de registro ");
        _loginScreenStatus = LoginScreenStatus.registerScreen;
      }
      notifyListeners();
    } catch (e) {
      _loginScreenStatus = LoginScreenStatus.failure;
      print("*luis error verificar usuario  $e");
    }
  }
}

enum LoginScreenStatus { loginScreen, inputCodeScreen, registerScreen, overview, failure, none }
