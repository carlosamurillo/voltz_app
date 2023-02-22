
import 'package:firebase_auth/firebase_auth.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';

class AuthService  with ListenableServiceMixin {

  final NavigationService _navigationService = locator<NavigationService>();

  final RxValue<bool> _rxIsLogged = RxValue<bool>(false);
  bool get isLogged => _rxIsLogged.value;
  final RxValue<String?> _rxQuoteId = RxValue<String?>(null);
  String? get quoteId => _rxQuoteId.value;
  Routes? routeRedirect;

  initAuthGate(String? quoteId) async {
    _rxQuoteId.value = quoteId;
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      if (user == null) {
        print('Usuario no esta logueado, procediendo a autenticar como anonimo');
        //_rxIsLogged.value = false;
        _rxIsLogged.value = false; //Para probar
        redirect();
      } else {
        print('Usuario loqueado, notificando a las vistas');
        _rxIsLogged.value = true;
        redirect();
      }});
  }

  signInAnonymously() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  redirect() async {
    if(quoteId == null) {
      if (isLogged) {
        //Si el usuario esta logueado siempre se redirecciona a
        _navigationService.clearStackAndShow(Routes.homeView);
      } else {
        _navigationService.clearStackAndShow(Routes.homeView);
      }
    } else {
      final args = CartViewArguments(quoteId: quoteId!);
      _navigationService.clearStackAndShow(Routes.cartView, arguments: args);
    }
  }

}