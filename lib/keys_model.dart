import 'package:firebase_core/firebase_core.dart';

class AppKeys {
  final String? cloudFunctionsUrl;
  final String? algoliaAppId;
  final String? algoliaApiKey;
  final FirebaseOptions? firebaseOptions;
  final String? segmentWriteKey;
  final String? appUrl;

  static AppKeys? _instance;

  factory AppKeys({
    String? cloudFunctionsUrl,
    String? algoliaAppId,
    String? algoliaApiKey,
    FirebaseOptions? firebaseOptions,
    String? segmentWriteKey,
    String? appUrl,
  }) =>
      _instance ??= AppKeys._(
        cloudFunctionsUrl: cloudFunctionsUrl,
        algoliaAppId: algoliaAppId,
        algoliaApiKey: algoliaApiKey,
        firebaseOptions: firebaseOptions,
        segmentWriteKey: segmentWriteKey,
        appUrl: appUrl,
      );

  AppKeys._({
    this.cloudFunctionsUrl,
    this.algoliaAppId,
    this.algoliaApiKey,
    this.firebaseOptions,
    this.segmentWriteKey,
    this.appUrl,
  });
}
