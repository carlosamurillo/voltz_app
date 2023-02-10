
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class InputSearchRepository with ListenableServiceMixin {
  ///Notifica a todas los viewmodel-vistas para que se ajusten
  ///al activarse o desactivarse la busqueda
  bool _searchSelected = false;
  bool get isSearchSelected => _searchSelected;
  void changeSearchSelected(bool selected) async {
    _searchSelected = selected;
    notifyListeners();
  }
}