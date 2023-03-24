import 'package:maketplace/firebase_options_voltz_dev.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/main_voltz.dart';
import 'package:maketplace/pdf_quote/svg_icons.dart';
import 'package:maketplace/utils/custom_colors.dart';

void main() async {
  // Init flavor config

  AppKeys(
    cloudFunctionsUrl: 'https://us-central1-voltz-develop.cloudfunctions.net',
    algoliaAppId: '8329NI8LQK', // Voltz id
    algoliaApiKey: '61ba6b16dc3f69daf2cf20997e42bce1', // Voltz id
    firebaseOptions: DefaultFirebaseOptionsVoltzDevelop.currentPlatform,
    segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9',
    appUrl: 'https://voltz-develop.web.app/', // Dev y Pro usan el mismo destino en Segment
    //
    customColors: CustomColors(),
    logo: 'assets/svg/voltz_logo.svg',
    logoWhite: 'assets/svg/logo_voltz_white.svg',
    logoWhiteBackground: 'assets/svg/logo_voltz_white_background.svg',
    logoMobile: 'assets/svg/logo_mobile.svg',
    logoIcon: SVGIcons.logo_votz,
    assistantIcon: "assets/images/assistant_icon.png",
    howToSearch: 'assets/images/how_search.png',
  );

  mainCommonVoltz();
}
