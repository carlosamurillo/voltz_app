import 'package:maketplace/firebase_options_jetz_dev.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/main_jetz.dart';
import 'package:maketplace/pdf_quote_order/svg_icons.dart';
import 'package:maketplace/utils/custom_colors.dart';

void main() async {
  // Init flavor config

  AppKeys(
      cloudFunctionsUrl: 'https://us-central1-voltz-develop.cloudfunctions.net',
      //estas dos son para algolia que se crea desde marketplace
      algoliaAppId: '8329NI8LQK', // Voltz id
      algoliaApiKey: '61ba6b16dc3f69daf2cf20997e42bce1', // Voltz id
      //este es para firebase
      firebaseOptions: DefaultFirebaseOptionsJetzDevelop.currentPlatform,
      //estas dos son para segment
      segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9',
      appUrl: 'https://voltz-develop.web.app/', // Dev y Pro usan el mismo destino en Segment
      //
      customColors: JeztCustomColors(),
      logo: 'assets/svg/jetz_logo.svg',
      logoWhite: 'assets/svg/logo_jetz_white.svg',
      logoWhiteBackground: 'assets/svg/logo_jetz_white_background.svg',
      logoMobile: 'assets/svg/logo_mobile.svg',
      logoIcon: SVGIcons.logo_jetz,
      assistantIcon: "assets/images/assistant_jetz.png",
      howToSearch: "assets/images/assistant_jetz.png");

  mainCommonJetz();
}
