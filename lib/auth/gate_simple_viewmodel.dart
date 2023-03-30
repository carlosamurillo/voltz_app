import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/common/open_search_service.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GateSimpleViewModel extends ReactiveViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final InputSearchRepository _inputSearchRepository = locator<InputSearchRepository>();
  final OpenSearchService _openSearchService = locator<OpenSearchService>();
  final _authService = locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _authService,
      ];

  UserSignStatus get authSignStatus => _authService.userSignStatus;

  signOut() {
    _authService.setRedirect(false);
    _authService.signOut();
    _navigationService.clearStackAndShow(Routes.authGate, arguments: AuthGateArguments(quoteId: null));
  }

  navigateToLogin() async {
    _inputSearchRepository.cancelSearch();
    _openSearchService.changeSearchOpened(false);
    return _navigationService.navigateToLoginView();
  }

  navigateToHome() async {
    _navigationService.back();
    _inputSearchRepository.cancelSearch();
    _openSearchService.changeSearchOpened(false);
    return _navigationService.pushNamedAndRemoveUntil(
      Routes.homeView,
      predicate: (route) {
        return route.settings.name != Routes.homeView;
      },
    );
    // return _navigationService.clearStackAndShow(Routes.homeView);
  }

  navigateToQuotes() async {
    _navigationService.back();
    _inputSearchRepository.cancelSearch();
    _openSearchService.changeSearchOpened(false);
    return _navigationService.pushNamedAndRemoveUntil(Routes.quoteDetailListView, predicate: (route) => route.settings.name != Routes.quoteDetailListView);
    // return _navigationService.clearStackAndShow(Routes.quoteDetailListView);
  }
}
