import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/auth/auth_view_model.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:provider/provider.dart';

class VoltzDrawer extends StatelessWidget {
  const VoltzDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Drawer(
        backgroundColor: CustomColors.blueVoltz,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/logo_mobile.svg',
                      width: 97,
                      height: 18,
                    ),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 50),
                DrawerItem(
                  icondata: Icons.home_outlined,
                  onPressed: () {},
                  selected: true,
                  text: "Inicio",
                ),
                const SizedBox(height: 10),
                DrawerItem(
                  icondata: Icons.bookmark_added_sharp,
                  onPressed: () {},
                  selected: false,
                  text: "Catálogo",
                ),
                const Spacer(),
                DrawerItem(
                  icondata: Icons.close,
                  onPressed: () {
                    context.read<AuthViewModel>().signOut();
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
