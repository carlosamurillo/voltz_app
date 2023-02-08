import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/cart/search_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/custom_colors.dart';
import '../utils/style.dart';

class Header extends StatelessWidget {
  const Header({super.key, this.paddingVertical = 14, this.paddingHorizontal = 25});
  final double paddingVertical;
  final double paddingHorizontal;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: media.width >= CustomStyles.desktopBreak ? EdgeInsets.symmetric(vertical: 14, horizontal: 25) : EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: CustomColors.white,
      width: double.infinity,
      height: media.width >= CustomStyles.desktopBreak ? CustomStyles.desktopHeaderHeight : CustomStyles.mobileHeaderHeight,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logo_voltz_white_background.svg',
            width: 120,
            height: 52,
          ),
          const SizedBox(width: 25),
          Expanded(
            child: _TextFormWidget(),
          ),
        ],
      ),
    );
  }
}

class _TextFormWidget extends StatelessWidget {
  const _TextFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = context.watch<SearchViewModel>().isSearchSelected;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Colors.white,
        border: Border.all(
          color: isSelected ? CustomColors.darkVoltz : CustomColors.darkPlusOne,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        onTap: () => context.read<SearchViewModel>().changeSearchSelected(true),
        onEditingComplete: () {
          context.read<SearchViewModel>().changeSearchSelected(false);
          context.read<SearchViewModel>().searchElements();
        },
        onSaved: (v) {
          context.read<SearchViewModel>().changeSearchSelected(false);
          context.read<SearchViewModel>().searchElements();
        },
        controller: context.read<SearchViewModel>().searchTextController,
        focusNode: context.read<SearchViewModel>().focusNodeSearch,
        decoration: InputDecoration(
          hintText: 'Hint Text',
          hintStyle: const TextStyle(color: CustomColors.darkPlusOne),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            size: 24,
            color: isSelected ? CustomColors.darkVoltz : CustomColors.darkMinusOne,
          ),
          suffixIcon: isSelected
              ? IconButton(
                  onPressed: () => context.read<SearchViewModel>().cancelSsarch(),
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: CustomColors.darkVoltz,
                  ),
                )
              : null,
          alignLabelWithHint: true,
          focusColor: CustomColors.darkVoltz,
        ),
      ),
    );
  }
}

class HeaderMobile extends StatelessWidget {
  HeaderMobile({this.paddingVertical = 15, this.paddingHorizontal = 15});
  double paddingVertical;
  double paddingHorizontal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logo_mobile.svg',
            width: 97,
            height: 18,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
