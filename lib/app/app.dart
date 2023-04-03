import 'package:maketplace/add_to_quote/add_to_quote_service.dart';
import 'package:maketplace/auth/login/code_validator_view.dart';
import 'package:maketplace/auth/login/login_service.dart';
import 'package:maketplace/auth/login/login_view.dart';
import 'package:maketplace/auth/register/register_view.dart';
import 'package:maketplace/cart/buy_now_view.dart';
import 'package:maketplace/cart/cart_confirmation.dart';
import 'package:maketplace/cart/cart_view.dart';
import 'package:maketplace/common/open_search_service.dart';
import 'package:maketplace/gate/auth_gate.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/home/home_view.dart';
import 'package:maketplace/notifications/notifications_service.dart';
import 'package:maketplace/order/oder_view.dart';
import 'package:maketplace/product/product_service.dart';
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote_detail/quote_detail_view.dart';
import 'package:maketplace/quote_detail/quote_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:maketplace/search/search_repository.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

/// flutter pub run build_runner build --delete-conflicting-outputs
/// Anterior es la linea de comando para generar  *
@StackedApp(
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: QuoteService),
    LazySingleton(classType: QuoteDetailService),
    LazySingleton(classType: ProductService),
    LazySingleton(classType: ProductSearchRepository),
    LazySingleton(classType: InputSearchRepository),
    LazySingleton(classType: NotificationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: LoginService),
    LazySingleton(classType: OpenSearchService),
    LazySingleton(classType: AddToQuoteService),
  ],
  routes: [
    /** Onboarding and signup **/
    CupertinoRoute(page: AuthGate),
    CupertinoRoute(page: CartView),
    CupertinoRoute(page: OrderView),
    CupertinoRoute(page: CartConfirmation),
    CupertinoRoute(page: HomeView),
    CupertinoRoute(page: BuyNowView),
    CupertinoRoute(page: LoginView),
    CupertinoRoute(page: RegisterView),
    CupertinoRoute(page: CodeValidatorView),
    CupertinoRoute(page: QuoteDetailListView),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
