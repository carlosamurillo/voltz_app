// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';

import '../add_to_quote/add_to_quote_service.dart';
import '../auth/login/login_service.dart';
import '../common/open_search_service.dart';
import '../gate/auth_service.dart';
import '../notifications/notifications_service.dart';
import '../product/product_service.dart';
import '../quote/quote_service.dart';
import '../quote_detail/quote_service.dart';
import '../search/input_search_repository.dart';
import '../search/search_repository.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => QuoteService());
  locator.registerLazySingleton(() => QuoteDetailService());
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => ProductSearchRepository());
  locator.registerLazySingleton(() => InputSearchRepository());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => LoginService());
  locator.registerLazySingleton(() => OpenSearchService());
  locator.registerLazySingleton(() => AddToQuoteService());
}
