
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class OpenSearchService with ListenableServiceMixin {
  ///Notifica a todas los viewmodel-vistas para que se ajusten
  ///al activarse o desactivarse la busqueda
  final RxValue<bool> _rxSearchOpened = RxValue<bool>(false);

  bool get isSearchOpened => _rxSearchOpened.value;
  OpenSearchService() {
    listenToReactiveValues([_rxSearchOpened,]);
  }

  Future<void> changeSearchOpened(bool selected) async {
    _rxSearchOpened.value = selected;
    notifyListeners();
  }
}