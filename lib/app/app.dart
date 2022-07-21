
import 'package:maketplace/quote/quote_service.dart';
import 'package:maketplace/quote/quote_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  dependencies: [
    LazySingleton(classType: QuoteService),
  ],
  routes: [

    /** Onboarding and signup **/
    CupertinoRoute(page: QuoteView,  initial: true),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}