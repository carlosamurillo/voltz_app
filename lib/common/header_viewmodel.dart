
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/common/open_search_service.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:maketplace/app/app.locator.dart';

class HeaderViewModel extends ReactiveViewModel {

  final InputSearchRepository _inputSearchRepository = locator<InputSearchRepository>();
  final NavigationService _navigationService = locator<NavigationService>();
  final OpenSearchService _openSearchService = locator<OpenSearchService>();
  final _authService = locator<AuthService>();
  bool get isSearchOpened => _openSearchService.isSearchOpened;

  @override
  List<ListenableServiceMixin> get listenableServices => [_authService, _openSearchService];

  UserSignStatus get authSignStatus => _authService.userSignStatus;

  signOut() => _authService.signOut();

  navigateToLogin() async {
    return _navigationService.navigateToLoginView();
  }

  showSearchWidget() {
    _openSearchService.changeSearchOpened(true);
    _inputSearchRepository.changeSearchSelected(true);
  }

}