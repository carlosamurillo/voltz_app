import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:stacked/stacked.dart';

class ContainerViewModel extends ReactiveViewModel {
  final _inputSearchRepository = locator<InputSearchRepository>();
  final _authService = locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_inputSearchRepository, _authService,];

  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;
  UserSignStatus get userSignStatus => _authService.userSignStatus;
}