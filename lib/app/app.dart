
import 'package:maketplace/auth/login/login_service.dart';
import 'package:maketplace/auth/login/login_view.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/home/home_view.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../cart/cart_view.dart';
import '../cart/buy_now_view.dart';
import '../notifications/notifications_service.dart';
import '../order/oder_view.dart';
import '../cart/cart_confirmation.dart';
import '../product/product_service.dart';
import '../search/input_search_repository.dart';
import '../search/search_repository.dart';

/// flutter pub run build_runner build --delete-conflicting-outputs
/// Anterior es la linea de comando para generar  *
@StackedApp(
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: QuoteService),
    LazySingleton(classType: ProductService),
    LazySingleton(classType: ProductSearchRepository),
    LazySingleton(classType: InputSearchRepository),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: LoginService),
  ],
  routes: [
    /** Onboarding and signup **/
    CupertinoRoute(page: CartView),
    CupertinoRoute(page: OrderView),
    CupertinoRoute(page: CartConfirmation,),
    CupertinoRoute(page: HomeView),
    CupertinoRoute(page: BuyNowView),
    CupertinoRoute(page: LoginView),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
