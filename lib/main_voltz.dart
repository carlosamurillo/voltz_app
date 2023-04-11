import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/keys_model.dart';

import 'app.dart';

// http://localhost:8080/?cotz=LDviRW7F3hoBPZ4LzWfN

void mainCommonVoltz() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppKeys _config = AppKeys();

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
  String? quoteId = Uri.base.queryParameters["cotz"];
  String? orderId = Uri.base.queryParameters["order"];

  // String? quoteId = "xpo9J6xHvLknQv07kG4G";
  //id de una orden
  // String? orderId = "rqz1gZjEa3Plg34mAwty";

  // print("el id cotizacion es : ${quoteId}");
  setupLocator();
  runApp(MyApp(
    quoteId: quoteId,
    orderId: orderId,
  ));
  /*runApp(MyApp(
    quoteId: "adsf",
    version: "asdf",
  ));*/
}
