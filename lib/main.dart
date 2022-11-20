
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote/quote_view.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:flutter/foundation.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'cart/cart_view.dart';

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  VoltzKeys _config = VoltzKeys();



  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    // Some android/ios specific code
  }
  else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows) {
    // Some desktop specific code there
  }
  else {
    // Some web specific code there

  }

  await Firebase.initializeApp(
    options: _config.firebaseOptions,
  );
  String quoteId = Uri.base.queryParameters["cotz"]!;
  String? version = Uri.base.queryParameters["version"];
  print("el id cotizacion es : ${quoteId}");
  setupLocator();
  runApp( MyApp(quoteId: quoteId, version: version,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.quoteId, required this.version});
  final String quoteId;
  final String? version;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        SegmentObserver(),
      ],
      title: 'Voltz - Cotización',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: CustomColors.safeBlue,
        fontFamily: "Hellix",
      ),
      //home: QuoteView(quoteId: quoteId, version: version,),
      home: CartView(quoteId: quoteId, version: version,),
      navigatorKey: StackedService.navigatorKey,
      // home: AddCardView(), // Used when testing a view
      initialRoute: Routes.quoteView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
