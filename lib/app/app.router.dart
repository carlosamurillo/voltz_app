// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/cupertino.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:flutter/material.dart';
import 'package:maketplace/auth/login/code_validator_view.dart' as _i10;
import 'package:maketplace/auth/login/login_view.dart' as _i8;
import 'package:maketplace/auth/register/register_view.dart' as _i9;
import 'package:maketplace/cart/buy_now_view.dart' as _i7;
import 'package:maketplace/cart/cart_confirmation.dart' as _i5;
import 'package:maketplace/cart/cart_view.dart' as _i3;
import 'package:maketplace/gate/auth_gate.dart' as _i2;
import 'package:maketplace/home/home_view.dart' as _i6;
import 'package:maketplace/order/oder_view.dart' as _i4;
import 'package:maketplace/quote_detail/quote_detail_view.dart' as _i11;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i14;

class Routes {
  static const authGate = '/auth-gate';

  static const cartView = '/cart-view';

  static const orderView = '/order-view';

  static const cartConfirmation = '/cart-confirmation';

  static const homeView = '/home-view';

  static const buyNowView = '/buy-now-view';

  static const loginView = '/login-view';

  static const registerView = '/register-view';

  static const codeValidatorView = '/code-validator-view';

  static const quoteDetailListView = '/quote-detail-list-view';

  static const all = <String>{
    authGate,
    cartView,
    orderView,
    cartConfirmation,
    homeView,
    buyNowView,
    loginView,
    registerView,
    codeValidatorView,
    quoteDetailListView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.authGate,
      page: _i2.AuthGate,
    ),
    _i1.RouteDef(
      Routes.cartView,
      page: _i3.CartView,
    ),
    _i1.RouteDef(
      Routes.orderView,
      page: _i4.OrderView,
    ),
    _i1.RouteDef(
      Routes.cartConfirmation,
      page: _i5.CartConfirmation,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i6.HomeView,
    ),
    _i1.RouteDef(
      Routes.buyNowView,
      page: _i7.BuyNowView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i8.LoginView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i9.RegisterView,
    ),
    _i1.RouteDef(
      Routes.codeValidatorView,
      page: _i10.CodeValidatorView,
    ),
    _i1.RouteDef(
      Routes.quoteDetailListView,
      page: _i11.QuoteDetailListView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.AuthGate: (data) {
      final args = data.getArgs<AuthGateArguments>(
        orElse: () => const AuthGateArguments(),
      );
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => _i2.AuthGate(
            key: args.key, quoteId: args.quoteId, orderId: args.orderId),
        settings: data,
      );
    },
    _i3.CartView: (data) {
      final args = data.getArgs<CartViewArguments>(nullOk: false);
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i3.CartView(key: args.key, quoteId: args.quoteId),
        settings: data,
      );
    },
    _i4.OrderView: (data) {
      final args = data.getArgs<OrderViewArguments>(nullOk: false);
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => _i4.OrderView(
            key: args.key, orderId: args.orderId, fromQuote: args.fromQuote),
        settings: data,
      );
    },
    _i5.CartConfirmation: (data) {
      final args = data.getArgs<CartConfirmationArguments>(nullOk: false);
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i5.CartConfirmation(key: args.key, quoteId: args.quoteId),
        settings: data,
      );
    },
    _i6.HomeView: (data) {
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => const _i6.HomeView(),
        settings: data,
      );
    },
    _i7.BuyNowView: (data) {
      final args = data.getArgs<BuyNowViewArguments>(nullOk: false);
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i7.BuyNowView(key: args.key, productId: args.productId),
        settings: data,
      );
    },
    _i8.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => _i8.LoginView(
            key: args.key, quoteId: args.quoteId, orderId: args.orderId),
        settings: data,
      );
    },
    _i9.RegisterView: (data) {
      final args = data.getArgs<RegisterViewArguments>(nullOk: false);
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => _i9.RegisterView(
            key: args.key,
            phoneNumber: args.phoneNumber,
            quoteId: args.quoteId,
            orderId: args.orderId),
        settings: data,
      );
    },
    _i10.CodeValidatorView: (data) {
      final args = data.getArgs<CodeValidatorViewArguments>(
        orElse: () => const CodeValidatorViewArguments(),
      );
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => _i10.CodeValidatorView(
            key: args.key, quoteId: args.quoteId, orderId: args.orderId),
        settings: data,
      );
    },
    _i11.QuoteDetailListView: (data) {
      return _i12.CupertinoPageRoute<dynamic>(
        builder: (context) => const _i11.QuoteDetailListView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class AuthGateArguments {
  const AuthGateArguments({
    this.key,
    this.quoteId,
    this.orderId,
  });

  final _i13.Key? key;

  final String? quoteId;

  final String? orderId;
}

class CartViewArguments {
  const CartViewArguments({
    this.key,
    required this.quoteId,
  });

  final _i13.Key? key;

  final String quoteId;
}

class OrderViewArguments {
  const OrderViewArguments({
    this.key,
    required this.orderId,
    required this.fromQuote,
  });

  final _i13.Key? key;

  final String orderId;

  final bool fromQuote;
}

class CartConfirmationArguments {
  const CartConfirmationArguments({
    this.key,
    required this.quoteId,
  });

  final _i13.Key? key;

  final String quoteId;
}

class BuyNowViewArguments {
  const BuyNowViewArguments({
    this.key,
    required this.productId,
  });

  final _i13.Key? key;

  final String productId;
}

class LoginViewArguments {
  const LoginViewArguments({
    this.key,
    this.quoteId,
    this.orderId,
  });

  final _i13.Key? key;

  final String? quoteId;

  final String? orderId;
}

class RegisterViewArguments {
  const RegisterViewArguments({
    this.key,
    required this.phoneNumber,
    this.quoteId,
    this.orderId,
  });

  final _i13.Key? key;

  final String phoneNumber;

  final String? quoteId;

  final String? orderId;
}

class CodeValidatorViewArguments {
  const CodeValidatorViewArguments({
    this.key,
    this.quoteId,
    this.orderId,
  });

  final _i13.Key? key;

  final String? quoteId;

  final String? orderId;
}

extension NavigatorStateExtension on _i14.NavigationService {
  Future<dynamic> navigateToAuthGate({
    _i13.Key? key,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.authGate,
        arguments:
            AuthGateArguments(key: key, quoteId: quoteId, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartView({
    _i13.Key? key,
    required String quoteId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.cartView,
        arguments: CartViewArguments(key: key, quoteId: quoteId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderView({
    _i13.Key? key,
    required String orderId,
    required bool fromQuote,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderView,
        arguments: OrderViewArguments(
            key: key, orderId: orderId, fromQuote: fromQuote),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartConfirmation({
    _i13.Key? key,
    required String quoteId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.cartConfirmation,
        arguments: CartConfirmationArguments(key: key, quoteId: quoteId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBuyNowView({
    _i13.Key? key,
    required String productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.buyNowView,
        arguments: BuyNowViewArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i13.Key? key,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments:
            LoginViewArguments(key: key, quoteId: quoteId, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView({
    _i13.Key? key,
    required String phoneNumber,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.registerView,
        arguments: RegisterViewArguments(
            key: key,
            phoneNumber: phoneNumber,
            quoteId: quoteId,
            orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCodeValidatorView({
    _i13.Key? key,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.codeValidatorView,
        arguments: CodeValidatorViewArguments(
            key: key, quoteId: quoteId, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToQuoteDetailListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.quoteDetailListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAuthGate({
    _i13.Key? key,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.authGate,
        arguments:
            AuthGateArguments(key: key, quoteId: quoteId, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartView({
    _i13.Key? key,
    required String quoteId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.cartView,
        arguments: CartViewArguments(key: key, quoteId: quoteId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderView({
    _i13.Key? key,
    required String orderId,
    required bool fromQuote,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderView,
        arguments: OrderViewArguments(
            key: key, orderId: orderId, fromQuote: fromQuote),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartConfirmation({
    _i13.Key? key,
    required String quoteId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.cartConfirmation,
        arguments: CartConfirmationArguments(key: key, quoteId: quoteId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBuyNowView({
    _i13.Key? key,
    required String productId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.buyNowView,
        arguments: BuyNowViewArguments(key: key, productId: productId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i13.Key? key,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments:
            LoginViewArguments(key: key, quoteId: quoteId, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView({
    _i13.Key? key,
    required String phoneNumber,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.registerView,
        arguments: RegisterViewArguments(
            key: key,
            phoneNumber: phoneNumber,
            quoteId: quoteId,
            orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCodeValidatorView({
    _i13.Key? key,
    String? quoteId,
    String? orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.codeValidatorView,
        arguments: CodeValidatorViewArguments(
            key: key, quoteId: quoteId, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithQuoteDetailListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.quoteDetailListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
