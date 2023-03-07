// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/cupertino.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:maketplace/auth/login/login_view.dart' as _i7;
import 'package:maketplace/cart/buy_now_view.dart' as _i6;
import 'package:maketplace/cart/cart_confirmation.dart' as _i4;
import 'package:maketplace/cart/cart_view.dart' as _i2;
import 'package:maketplace/home/home_view.dart' as _i5;
import 'package:maketplace/order/oder_view.dart' as _i3;
import 'package:maketplace/quote_detail/quote_detail_view.dart' as _i8;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i10;

class Routes {
  static const cartView = '/cart-view';

  static const orderView = '/order-view';

  static const cartConfirmation = '/cart-confirmation';

  static const homeView = '/home-view';

  static const buyNowView = '/buy-now-view';

  static const loginView = '/login-view';

  static const quoteDetailListView = '/quote-detail-list-view';

  static const all = <String>{
    cartView,
    orderView,
    cartConfirmation,
    homeView,
    buyNowView,
    loginView,
    quoteDetailListView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.cartView,
      page: _i2.CartView,
    ),
    _i1.RouteDef(
      Routes.orderView,
      page: _i3.OrderView,
    ),
    _i1.RouteDef(
      Routes.cartConfirmation,
      page: _i4.CartConfirmation,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i5.HomeView,
    ),
    _i1.RouteDef(
      Routes.buyNowView,
      page: _i6.BuyNowView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i7.LoginView,
    ),
    _i1.RouteDef(
      Routes.quoteDetailListView,
      page: _i8.QuoteDetailListView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.CartView: (data) {
      final args = data.getArgs<CartViewArguments>(nullOk: false);
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i2.CartView(key: args.key, quoteId: args.quoteId),
        settings: data,
      );
    },
    _i3.OrderView: (data) {
      final args = data.getArgs<OrderViewArguments>(nullOk: false);
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i3.OrderView(key: args.key, orderId: args.orderId),
        settings: data,
      );
    },
    _i4.CartConfirmation: (data) {
      final args = data.getArgs<CartConfirmationArguments>(nullOk: false);
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i4.CartConfirmation(key: args.key, quoteId: args.quoteId),
        settings: data,
      );
    },
    _i5.HomeView: (data) {
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) => const _i5.HomeView(),
        settings: data,
      );
    },
    _i6.BuyNowView: (data) {
      final args = data.getArgs<BuyNowViewArguments>(nullOk: false);
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i6.BuyNowView(key: args.key, productId: args.productId),
        settings: data,
      );
    },
    _i7.LoginView: (data) {
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) => const _i7.LoginView(),
        settings: data,
      );
    },
    _i8.QuoteDetailListView: (data) {
      return _i9.CupertinoPageRoute<dynamic>(
        builder: (context) => const _i8.QuoteDetailListView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class CartViewArguments {
  const CartViewArguments({
    this.key,
    required this.quoteId,
  });

  final _i9.Key? key;

  final String quoteId;
}

class OrderViewArguments {
  const OrderViewArguments({
    this.key,
    required this.orderId,
  });

  final _i9.Key? key;

  final String orderId;
}

class CartConfirmationArguments {
  const CartConfirmationArguments({
    this.key,
    required this.quoteId,
  });

  final _i9.Key? key;

  final String quoteId;
}

class BuyNowViewArguments {
  const BuyNowViewArguments({
    this.key,
    required this.productId,
  });

  final _i9.Key? key;

  final String productId;
}

extension NavigatorStateExtension on _i10.NavigationService {
  Future<dynamic> navigateToCartView({
    _i9.Key? key,
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
    _i9.Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderView,
        arguments: OrderViewArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartConfirmation({
    _i9.Key? key,
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
    _i9.Key? key,
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

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
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

  Future<dynamic> replaceWithCartView({
    _i9.Key? key,
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
    _i9.Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderView,
        arguments: OrderViewArguments(key: key, orderId: orderId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartConfirmation({
    _i9.Key? key,
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
    _i9.Key? key,
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

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
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
