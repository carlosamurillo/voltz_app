import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:stacked/stacked.dart';

class ContainerViewModel extends ReactiveViewModel {
  final _inputSearchRepository = locator<InputSearchRepository>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_inputSearchRepository];

  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;
}