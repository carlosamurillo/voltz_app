import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:maketplace/app/app.router.dart';
import 'package:maketplace/gate/auth_gate.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked_services/stacked_services.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.quoteId,
  });
  final String? quoteId;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('es'),
        ],
        //home: QuoteView(quoteId: quoteId, version: version,),
        // home: LoginView(),
        // home: RegisterView(),
        // home: CodeValidatorView(),
        home: AuthGate(
          quoteId: quoteId,
        ),
        navigatorKey: StackedService.navigatorKey,
        // home: AddCardView(), // Used when testing a view
        //initialRoute: Routes.cartView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
      ),
    );
  }
}
