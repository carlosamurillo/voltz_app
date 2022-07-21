// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../quote/quote_view.dart';

class Routes {
  static const String quoteView = '/';
  static const all = <String>{
    quoteView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.quoteView, page: QuoteView),
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
  QuoteViewArguments({this.key, required this.quoteId});
}

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToQuoteView({
    Key? key,
    required String quoteId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.quoteView,
      arguments: QuoteViewArguments(key: key, quoteId: quoteId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
