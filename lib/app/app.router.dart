// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../cart/cart_confirmation.dart';
import '../cart/cart_view.dart';
import '../order/oder_view.dart';

class Routes {
  static const String cartView = '/cart-view';
  static const String orderView = '/order-view';
  static const String cartConfirmation = '/cart-confirmation';
  static const all = <String>{
    cartView,
    orderView,
    cartConfirmation,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.cartView, page: CartView),
    RouteDef(Routes.orderView, page: OrderView),
    RouteDef(Routes.cartConfirmation, page: CartConfirmation),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    CartView: (data) {
      var args = data.getArgs<CartViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => CartView(
          key: args.key,
          quoteId: args.quoteId,
          version: args.version,
        ),
        settings: data,
      );
    },
    OrderView: (data) {
      var args = data.getArgs<OrderViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => OrderView(
          key: args.key,
          orderId: args.orderId,
        ),
        settings: data,
      );
    },
    CartConfirmation: (data) {
      var args = data.getArgs<CartConfirmationArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => CartConfirmation(
          key: args.key,
          quoteId: args.quoteId,
          version: args.version,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// CartView arguments holder class
class CartViewArguments {
  final Key? key;
  final String quoteId;
  final String? version;
  CartViewArguments({this.key, required this.quoteId, required this.version});
}

/// OrderView arguments holder class
class OrderViewArguments {
  final Key? key;
  final String orderId;
  OrderViewArguments({this.key, required this.orderId});
}

/// CartConfirmation arguments holder class
class CartConfirmationArguments {
  final Key? key;
  final String quoteId;
  final String? version;
  CartConfirmationArguments(
      {this.key, required this.quoteId, required this.version});
}

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToCartView({
    Key? key,
    required String quoteId,
    required String? version,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.cartView,
      arguments:
          CartViewArguments(key: key, quoteId: quoteId, version: version),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToOrderView({
    Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.orderView,
      arguments: OrderViewArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCartConfirmation({
    Key? key,
    required String quoteId,
    required String? version,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.cartConfirmation,
      arguments: CartConfirmationArguments(
          key: key, quoteId: quoteId, version: version),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
