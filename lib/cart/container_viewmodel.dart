import 'package:stacked/stacked.dart';
import '../search/input_search_repository.dart';
import '../app/app.locator.dart';

class ContainerViewModel extends ReactiveViewModel {
  final _inputSearchRepository = locator<InputSearchRepository>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_inputSearchRepository];

  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;
}