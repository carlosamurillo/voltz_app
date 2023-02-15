import 'package:flutter/material.dart';

class CodeValidatorViewModel extends ChangeNotifier {
  late bool _isCodeError;
  late String? _codeStr;

  bool get isCodeError => _isCodeError;

  void init() {
    _isCodeError = false;
    _codeStr = "";
  }

  void changeCode(String? value) {
    final codeValidatorRegExp = RegExp('[0-9]{6}');
    _codeStr = value;
    _isCodeError = codeValidatorRegExp.hasMatch(value ?? '');
    notifyListeners();
  }

  Future<void> enter() async {}
}
