
import 'package:firebase_core/firebase_core.dart';

class VoltzKeys {
  final String? cloudFunctionsUrl;
  final String? algoliaAppId;
  final String? algoliaApiKey;
  final FirebaseOptions? firebaseOptions;

  static VoltzKeys? _instance;

  factory VoltzKeys({
    String? cloudFunctionsUrl,
    String? algoliaAppId,
    String? algoliaApiKey,
    FirebaseOptions? firebaseOptions,
  }) =>
      _instance ??= VoltzKeys._(
        cloudFunctionsUrl: cloudFunctionsUrl,
        algoliaAppId: algoliaAppId,
        algoliaApiKey: algoliaApiKey,
        firebaseOptions: firebaseOptions,
      );

  VoltzKeys._({
    this.cloudFunctionsUrl,
    this.algoliaAppId,
    this.algoliaApiKey,
    this.firebaseOptions,
  });
}
