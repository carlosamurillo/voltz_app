
import 'package:flutter/material.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class InputSearchRepository with ListenableServiceMixin {
  ///Notifica a todas los viewmodel-vistas para que se ajusten
  ///al activarse o desactivarse la busqueda
  final RxValue<bool> _rxSearchSelected = RxValue<bool>(false);

  final TextEditingController _searchTextController = TextEditingController();
  TextEditingController get searchTextController => _searchTextController;

  final FocusNode focusNodeSearch = FocusNode();

  bool get isSearchSelected => _rxSearchSelected.value;
  InputSearchRepository() {
    listenToReactiveValues([_rxSearchSelected,]);
  }

  changeSearchSelected(bool selected) async {
    _rxSearchSelected.value = selected;
    return notifyListeners();
  }

  cancelSearch() async {
    _searchTextController.text = '';
    focusNodeSearch.unfocus();
    return changeSearchSelected(false);
  }

  onDispose(){
    _searchTextController.dispose();
    focusNodeSearch.dispose();
  }
}