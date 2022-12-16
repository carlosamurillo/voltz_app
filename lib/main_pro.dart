
import 'package:flutter_segment/flutter_segment.dart';
import 'package:maketplace/firebase_options_pro.dart';
import 'keys_model.dart';
import 'main.dart';

void main() async {

  // Init flavor config
  VoltzKeys(
      cloudFunctionsUrl: 'https://us-central1-voltz-pro.cloudfunctions.net',
      algoliaAppId: 'N2BMFF9FQC', // Voltz id
      algoliaApiKey: 'a40f00c73cca354f32ceae2aadcf769e', // Voltz id
      firebaseOptions: DefaultFirebaseOptionsProduction.currentPlatform,
      segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9',
      appUrl: 'https://app.voltz.mx/',
  );

  mainCommon();
}
