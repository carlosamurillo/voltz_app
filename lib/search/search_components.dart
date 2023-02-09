import 'package:flutter/material.dart';
import 'package:maketplace/search/input_view_model.dart';
import 'package:provider/provider.dart';
import '../utils/custom_colors.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = context.watch<SearchInputViewModel>().isSearchSelected;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: Colors.white,
        border: Border.all(
          color: isSelected ? CustomColors.dark : CustomColors.darkPlusOne,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        onTap: () => context.read<SearchInputViewModel>().changeSearchSelected(true),
        onEditingComplete: () {
          context.read<SearchInputViewModel>().changeSearchSelected(false);
          context.read<SearchInputViewModel>().searchElements();
        },
        onSaved: (v) {
          context.read<SearchInputViewModel>().changeSearchSelected(false);
          context.read<SearchInputViewModel>().searchElements();
        },
        controller: context.read<SearchInputViewModel>().searchTextController,
        focusNode: context.read<SearchInputViewModel>().focusNodeSearch,
        decoration: InputDecoration(
          hintText: 'Agregar productos',
          hintStyle: const TextStyle(color: CustomColors.darkPlusOne),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            size: 24,
            color: isSelected ? CustomColors.dark : CustomColors.darkMinusOne,
          ),
          suffixIcon: isSelected
              ? IconButton(
            onPressed: () => context.read<SearchInputViewModel>().cancelSearch(),
            icon: const Icon(
              Icons.close,
              size: 24,
              color: CustomColors.dark,
            ),
          )
              : null,
          alignLabelWithHint: true,
          focusColor: CustomColors.dark,
        ),
      ),
    );
  }
}