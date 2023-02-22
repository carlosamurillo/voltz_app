
import 'package:maketplace/login/auth_service.dart';
import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';

class HeaderViewModel extends ReactiveViewModel {

  final _authService = locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_authService,];

  bool get isLogged => _authService.isLogged;
}