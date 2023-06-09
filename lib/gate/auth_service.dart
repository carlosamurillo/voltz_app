import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/auth/user_data_model.dart';
import 'package:observable_ish/value/value.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthService with ListenableServiceMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  final RxValue<UserSignStatus> _rxUserStatus = RxValue<UserSignStatus>(UserSignStatus.unauthenticated);
  UserSignStatus get userSignStatus => _rxUserStatus.value;

  final RxValue<UserData?> _rxSignedUserData = RxValue<UserData?>(null);
  UserData? get signedUserData => _rxSignedUserData.value;

  final RxValue<String?> _rxQuoteId = RxValue<String?>(null);
  String? get quoteId => _rxQuoteId.value;
  final RxValue<String?> _rxOrderId = RxValue<String?>(null);
  String? get orderId => _rxOrderId.value;
  Routes? routeRedirect;

  bool _redirect = true;

  AuthService() {
    listenToReactiveValues([_rxUserStatus, _rxSignedUserData, _rxQuoteId]);
  }

  initAuthGate(String? quoteId, String? orderId) async {
    _rxQuoteId.value = quoteId;
    _rxOrderId.value = orderId;
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      await _verifySignedInUser(user);
    });
    redirect();
  }

  setRedirect(bool value) {
    _redirect = value;
  }

  _verifySignedInUser(User? user) async {
    if (user != null) {
      if (user.isAnonymous) {
        _rxUserStatus.value = UserSignStatus.anonymous;
      } else {
        _rxUserStatus.value = UserSignStatus.authenticated;
      }
      await verifyUserRegister(user.uid);
    } else {
      await signInAnonymously();
      _rxUserStatus.value = UserSignStatus.anonymous;
    }
  }

  signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
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

  redirect() {
    if (_redirect) {
      if (quoteId != null) {
        final args = CartViewArguments(quoteId: quoteId!);
        _navigationService.clearStackAndShow(Routes.cartView, arguments: args);
        return;
      } else if (orderId != null) {
        final args = OrderViewArguments(orderId: orderId!, fromQuote: false);
        _navigationService.clearStackAndShow(Routes.orderView, arguments: args);
        return;
      } else {
        _navigationService.clearStackAndShow(Routes.homeView);
        return;
      }
    } else {
      _redirect = true;
      notifyListeners();
    }
  }

  verifyUserRegister(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      _rxSignedUserData.value = UserData.fromJson(userDoc.data() as Map<String, dynamic>);
      print("verifyUserRegister  autenticado, enviar a usuario al overview");
      _rxUserStatus.value = UserSignStatus.authenticated;
    } else {
      //print("verifyUserRegister  no autenticado, indicar al usuario que puede registrarse ");
      //_rxUserStatus.value = UserSignStatus.pendingToRegister;
    }
    notifyListeners();
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    _rxUserStatus.value = UserSignStatus.unauthenticated;
    notifyListeners();
  }
}

enum UserSignStatus { authenticated, pendingToRegister, anonymous, unauthenticated, none }
