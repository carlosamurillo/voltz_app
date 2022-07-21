
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote/quote_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../order/oder_view.dart';

@StackedApp(
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: QuoteService),
  ],
  routes: [

    /** Onboarding and signup **/
    CupertinoRoute(page: QuoteView,  initial: true),
    CupertinoRoute(page: OrderView),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
