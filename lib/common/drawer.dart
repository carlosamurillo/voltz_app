import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/auth/gate_simple_viewmodel.dart';
import 'package:maketplace/quote_detail/quote_detail_view.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GateSimpleViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      builder: (context, viewModel, child) {
        var media = MediaQuery.of(context).size;
        return SizedBox(
          width: 300,
          height: media.height,
          child: Drawer(
            backgroundColor: CustomColors.blueVoltz,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/logo_voltz_white.svg',
                          width: 120,
                          height: 52,
                        ),
                        IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 50),
                    DrawerItem(
                      icondata: Icons.home_outlined,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => QuoteDetailListView(),
                          ),
                        );
                      },
                      selected: true,
                      text: "Inicio",
                    ),
                    const SizedBox(height: 10),
                    DrawerItem(
                      icondata: Icons.bookmark_added_sharp,
                      onPressed: () => viewModel.navigateToHome(),
                      selected: false,
                      text: "Catálogo",
                    ),
                    const Spacer(),
                    DrawerItem(
                      icondata: Icons.close,
                      onPressed: () {
                        viewModel.signOut();
                        Navigator.of(context).pop();
                      },
                      selected: false,
                      text: "Cerrar sesión",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => GateSimpleViewModel(),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({Key? key, required this.selected, required this.icondata, required this.text, required this.onPressed}) : super(key: key);

  final bool selected;
  final IconData icondata;
  final String text;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        decoration: BoxDecoration(
          color: selected ? CustomColors.bluePlusOne : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(200)),
            hoverColor: CustomColors.bluePlusOne.withOpacity(.7),
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Icon(icondata, color: Colors.white),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
