
import 'package:maketplace/quote/quote_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../cart/cart_view.dart';
import '../cart/product_detail_view.dart';
import '../order/oder_view.dart';
import '../cart/cart_confirmation.dart';
import '../products/products_service.dart';

/**  flutter pub run build_runner build --delete-conflicting-outputs
 * Anterior es la linea de comando para generar  **/
@StackedApp(
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: QuoteService),
    LazySingleton(classType: ProductsService),
  ],
  routes: [
    /** Onboarding and signup **/
    CupertinoRoute(page: CartView),
    CupertinoRoute(page: OrderView),
    CupertinoRoute(page: CartConfirmation,),
    CupertinoRoute(page: ProductViewMobile,),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
