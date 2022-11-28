// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../order/oder_view.dart';
import '../cart/cart_confirmation.dart';
import '../quote/quote_view.dart';

class Routes {
  static const String quoteView = '/';
  static const String orderView = '/order-view';
  static const String quoteConfirmation = '/quote-confirmation';
  static const all = <String>{
    quoteView,
    orderView,
    quoteConfirmation,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.quoteView, page: QuoteView),
    RouteDef(Routes.orderView, page: OrderView),
    RouteDef(Routes.quoteConfirmation, page: CartConfirmation),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    QuoteView: (data) {
      var args = data.getArgs<QuoteViewArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => QuoteView(
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
      var args = data.getArgs<QuoteConfirmationArguments>(nullOk: false);
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

/// QuoteView arguments holder class
class QuoteViewArguments {
  final Key? key;
  final String quoteId;
  final String? version;
  QuoteViewArguments({this.key, required this.quoteId, required this.version});
}

/// OrderView arguments holder class
class OrderViewArguments {
  final Key? key;
  final String orderId;
  OrderViewArguments({this.key, required this.orderId});
}

/// QuoteConfirmation arguments holder class
class QuoteConfirmationArguments {
  final Key? key;
  final String quoteId;
  final String? version;
  QuoteConfirmationArguments(
      {this.key, required this.quoteId, required this.version});
}

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToQuoteView({
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
      Routes.quoteView,
      arguments:
          QuoteViewArguments(key: key, quoteId: quoteId, version: version),
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

  Future<dynamic> navigateToQuoteConfirmation({
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
      Routes.quoteConfirmation,
      arguments: QuoteConfirmationArguments(
          key: key, quoteId: quoteId, version: version),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
