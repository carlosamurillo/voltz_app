
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin, ReactiveViewModel;
import '../app/app.locator.dart';

class AuthGateViewModel extends ReactiveViewModel {

  final _authService = locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_authService,];
  UserSignStatus get userSignStatus => _authService.userSignStatus;

  init({String? quoteId}) async {
    _authService.initAuthGate(quoteId);
  }
}