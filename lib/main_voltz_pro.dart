import 'package:maketplace/firebase_options_voltz_pro.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/main_voltz.dart';
import 'package:maketplace/pdf_quote_order/svg_icons.dart';
import 'package:maketplace/utils/custom_colors.dart';

void main() async {
  // Init flavor config
  AppKeys(
    cloudFunctionsUrl: 'https://us-central1-voltz-pro.cloudfunctions.net',
    algoliaAppId: 'N2BMFF9FQC', // Voltz id
    algoliaApiKey: 'a40f00c73cca354f32ceae2aadcf769e', // Voltz id
    firebaseOptions: DefaultFirebaseOptionsVoltzProduction.currentPlatform,
    segmentWriteKey: 'kjvSHxgKXqtlLdxHf92dv5Jrf8hWl0B9',
    appUrl: 'https://app.voltz.mx/',
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
