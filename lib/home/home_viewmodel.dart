
import 'package:maketplace/gate/auth_service.dart';
import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';

class HomeViewModel extends ReactiveViewModel {

  final _authService = locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_authService,];

  UserSignStatus get userSignStatus => _authService.userSignStatus;
}