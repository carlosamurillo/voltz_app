
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';

class GateSimpleViewModel extends ReactiveViewModel {

  final NavigationService _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_authService,];

  UserSignStatus get authSignStatus => _authService.userSignStatus;

  signOut() => _authService.signOut();

  navigateToLogin() async {
    return _navigationService.navigateToLoginView();
  }
}