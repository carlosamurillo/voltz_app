// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/cupertino.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:flutter/material.dart';
import 'package:maketplace/cart/cart_confirmation.dart' as _i4;
import 'package:maketplace/cart/cart_view.dart' as _i2;
import 'package:maketplace/order/oder_view.dart' as _i3;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i7;

class Routes {
  static const cartView = '/cart-view';

  static const orderView = '/order-view';

  static const cartConfirmation = '/cart-confirmation';

  static const all = <String>{
    cartView,
    orderView,
    cartConfirmation,
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
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.CartView: (data) {
      final args = data.getArgs<CartViewArguments>(nullOk: false);
      return _i5.CupertinoPageRoute<dynamic>(
        builder: (context) => _i2.CartView(
            key: args.key, quoteId: args.quoteId, version: args.version),
        settings: data,
      );
    },
    _i3.OrderView: (data) {
      final args = data.getArgs<OrderViewArguments>(nullOk: false);
      return _i5.CupertinoPageRoute<dynamic>(
        builder: (context) =>
            _i3.OrderView(key: args.key, orderId: args.orderId),
        settings: data,
      );
    },
    _i4.CartConfirmation: (data) {
      final args = data.getArgs<CartConfirmationArguments>(nullOk: false);
      return _i5.CupertinoPageRoute<dynamic>(
        builder: (context) => _i4.CartConfirmation(
            key: args.key, quoteId: args.quoteId, version: args.version),
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
    required this.version,
  });

  final _i6.Key? key;

  final String quoteId;

  final String? version;
}

class OrderViewArguments {
  const OrderViewArguments({
    this.key,
    required this.orderId,
  });

  final _i6.Key? key;

  final String orderId;
}

class CartConfirmationArguments {
  const CartConfirmationArguments({
    this.key,
    required this.quoteId,
    required this.version,
  });

  final _i6.Key? key;

  final String quoteId;

  final String? version;
}

extension NavigatorStateExtension on _i7.NavigationService {
  Future<dynamic> navigateToCartView({
    _i6.Key? key,
    required String quoteId,
    required String? version,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.cartView,
        arguments:
            CartViewArguments(key: key, quoteId: quoteId, version: version),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderView({
    _i6.Key? key,
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
    _i6.Key? key,
    required String quoteId,
    required String? version,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.cartConfirmation,
        arguments: CartConfirmationArguments(
            key: key, quoteId: quoteId, version: version),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartView({
    _i6.Key? key,
    required String quoteId,
    required String? version,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.cartView,
        arguments:
            CartViewArguments(key: key, quoteId: quoteId, version: version),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderView({
    _i6.Key? key,
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
    _i6.Key? key,
    required String quoteId,
    required String? version,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.cartConfirmation,
        arguments: CartConfirmationArguments(
            key: key, quoteId: quoteId, version: version),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
