import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  late bool _isBussiness;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _rfcController;

  bool get isBusiness => _isBussiness;
  TextEditingController get nameController => _nameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get rfcController => _rfcController;

  void init() {
    _isBussiness = false;
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _rfcController = TextEditingController();
  }

  void isBusinessChanged() {
    _isBussiness = !_isBussiness;
    notifyListeners();
  }

  Future<void> register() async {}
}
