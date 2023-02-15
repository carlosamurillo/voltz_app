import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  late bool _acceptWhatsapp;
  late TextEditingController _loginController;

  bool get isWhatsappCheckboxAccepted => _acceptWhatsapp;
  TextEditingController get loginController => _loginController;

  void init() {
    _acceptWhatsapp = false;
    _loginController = TextEditingController();
  }

  void checkboxWhatsappChanged() {
    _acceptWhatsapp = !_acceptWhatsapp;
    notifyListeners();
  }

  Future<void> login() async {}
}
