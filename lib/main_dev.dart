
import 'package:flutter/cupertino.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:maketplace/firebase_options_dev.dart';
import 'package:maketplace/main.dart';
import 'keys_model.dart';

void main() async {
  // Init flavor config

  VoltzKeys(
    cloudFunctionsUrl: 'https://us-central1-voltz-develop.cloudfunctions.net',
    algoliaAppId: '8329NI8LQK', // Voltz id
    algoliaApiKey: '61ba6b16dc3f69daf2cf20997e42bce1', // Voltz id
    firebaseOptions: DefaultFirebaseOptionsDevelop.currentPlatform,
    segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9', // Dev y Pro usan el mismo destino en Segment
  );

  mainCommon();

}
