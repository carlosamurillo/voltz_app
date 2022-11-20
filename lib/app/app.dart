
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote/quote_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../order/oder_view.dart';
import '../quote/quote_confirmation.dart';

/**  flutter pub run build_runner build --delete-conflicting-outputs
 * Anterior es la linea de comando para generar  **/
@StackedApp(
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: QuoteService),
  ],
  routes: [
    /** Onboarding and signup **/
    CupertinoRoute(page: QuoteView,  initial: true),
    CupertinoRoute(page: OrderView),
    CupertinoRoute(page: QuoteConfirmation,),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
