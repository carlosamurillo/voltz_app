import 'package:maketplace/firebase_options_voltz_pro.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/main_voltz.dart';

void main() async {
  // Init flavor config
  AppKeys(
    cloudFunctionsUrl: 'https://us-central1-voltz-pro.cloudfunctions.net',
    algoliaAppId: 'N2BMFF9FQC', // Voltz id
    algoliaApiKey: 'a40f00c73cca354f32ceae2aadcf769e', // Voltz id
    firebaseOptions: DefaultFirebaseOptionsVoltzProduction.currentPlatform,
    segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9',
    appUrl: 'https://app.voltz.mx/',
  );

  mainCommonVoltz();
}
