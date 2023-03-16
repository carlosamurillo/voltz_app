import 'package:firebase_core/firebase_core.dart';
import 'package:maketplace/utils/custom_colors.dart';

class AppKeys {
  final String? cloudFunctionsUrl;
  final String? algoliaAppId;
  final String? algoliaApiKey;
  final FirebaseOptions? firebaseOptions;
  final String? segmentWriteKey;
  final String? appUrl;

  //theming
  final CustomColors? customColors;
  final String? logo;
  final String? logoWhite;
  final String? logoWhiteBackground;
  final String? logoMobile;
  final String? logoIcon;

  static AppKeys? _instance;

  factory AppKeys({
    String? cloudFunctionsUrl,
    String? algoliaAppId,
    String? algoliaApiKey,
    FirebaseOptions? firebaseOptions,
    String? segmentWriteKey,
    String? appUrl,
    CustomColors? customColors,
    String? logo,
    String? logoWhite,
    String? logoWhiteBackground,
    String? logoMobile,
    String? logoIcon,
  }) =>
      _instance ??= AppKeys._(
        cloudFunctionsUrl: cloudFunctionsUrl,
        algoliaAppId: algoliaAppId,
        algoliaApiKey: algoliaApiKey,
        firebaseOptions: firebaseOptions,
        segmentWriteKey: segmentWriteKey,
        appUrl: appUrl,
        customColors: customColors,
        logo: logo,
        logoWhite: logoWhite,
        logoWhiteBackground: logoWhiteBackground,
        logoMobile: logoMobile,
        logoIcon: logoIcon,
      );

  AppKeys._({
    this.cloudFunctionsUrl,
    this.algoliaAppId,
    this.algoliaApiKey,
    this.firebaseOptions,
    this.segmentWriteKey,
    this.appUrl,
    this.customColors,
    this.logo,
    this.logoWhite,
    this.logoWhiteBackground,
    this.logoMobile,
    this.logoIcon,
  });
}
