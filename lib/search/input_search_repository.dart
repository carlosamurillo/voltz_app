
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class InputSearchRepository with ListenableServiceMixin {
  ///Notifica a todas los viewmodel-vistas para que se ajusten
  ///al activarse o desactivarse la busqueda
  final RxValue<bool> _rxSearchSelected = RxValue<bool>(false);

  bool get isSearchSelected => _rxSearchSelected.value;
  InputSearchRepository() {
    listenToReactiveValues([_rxSearchSelected,]);
  }

  Future<void> changeSearchSelected(bool selected) async {
    _rxSearchSelected.value = selected;
    notifyListeners();
  }
}