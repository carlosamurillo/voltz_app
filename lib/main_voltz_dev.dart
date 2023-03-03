import 'package:maketplace/firebase_options_voltz_dev.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/main_voltz.dart';

void main() async {
  // Init flavor config

  AppKeys(
    cloudFunctionsUrl: 'https://us-central1-voltz-develop.cloudfunctions.net',
    algoliaAppId: '8329NI8LQK', // Voltz id
    algoliaApiKey: '61ba6b16dc3f69daf2cf20997e42bce1', // Voltz id
    firebaseOptions: DefaultFirebaseOptionsVoltzDevelop.currentPlatform,
    segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9',
    appUrl: 'https://voltz-develop.web.app/', // Dev y Pro usan el mismo destino en Segment
  );

  mainCommonVoltz();
}
