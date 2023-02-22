import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:maketplace/auth/auth_view_model.dart';
import 'package:maketplace/auth/login/login_view_model.dart';
import 'package:maketplace/cart/cart_view.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.locator.dart';
import 'app/app.router.dart';

// http://localhost:8080/?cotz=LDviRW7F3hoBPZ4LzWfN

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  VoltzKeys _config = VoltzKeys();

  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    // Some android/ios specific code
  } else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows) {
    // Some desktop specific code there
  } else {
    // Some web specific code there
  }

  await Firebase.initializeApp(
    options: kIsWeb ? _config.firebaseOptions : null,
  );
  // String quoteId = Uri.base.queryParameters["cotz"]!;
  // String? version = Uri.base.queryParameters["version"];
  // print("el id cotizacion es : ${quoteId}");
  setupLocator();
  // runApp(MyApp(
  //   quoteId: quoteId,
  //   version: version,
  // ));
  runApp(MyApp(
    quoteId: "LDviRW7F3hoBPZ4LzWfN",
    version: "1.71.0",
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.quoteId, required this.version});
  final String quoteId;
  final String? version;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthViewModel()..init()),
          ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ],
        child: MaterialApp(
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
          home: CartView(
            quoteId: quoteId,
            version: version,
          ),
          // home: LoginView(),
          // home: RegisterView(),
          // home: CodeValidatorView(),

          navigatorKey: StackedService.navigatorKey,
          // home: AddCardView(), // Used when testing a view
          //initialRoute: Routes.cartView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
        ),
      ),
    );
  }
}
