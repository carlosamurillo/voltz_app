import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/search/input_view_model.dart';
import 'package:stacked/stacked.dart';
import '../utils/custom_colors.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchInputViewModel>.reactive(
        viewModelBuilder: () => SearchInputViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        fireOnViewModelReadyOnce: true,
        disposeViewModel: false,
        createNewViewModelOnInsert: false,
        builder: (context, viewModel, child) {
          if (kDebugMode) {
            print('SearchInputWidget ... Se actualiza la vista ');
          }
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Colors.white,
              border: Border.all(
                color: viewModel.isSearchSelected ? CustomColors.dark : CustomColors.darkPlusOne,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              onTap: () => viewModel.changeSearchSelected(true),
              onEditingComplete: () => viewModel.changeSearchSelected(false),
              onSaved: (v) => viewModel.changeSearchSelected(false),
              controller: viewModel.searchTextController,
              focusNode: viewModel.focusNodeSearch,
              decoration: InputDecoration(
                hintText: 'Agregar productos',
                hintStyle: const TextStyle(color: CustomColors.darkPlusOne),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  size: 24,
                  color: viewModel.isSearchSelected ? CustomColors.dark : CustomColors.darkMinusOne,
                ),
                suffixIcon: viewModel.isSearchSelected
                    ? IconButton(
                  onPressed: () => viewModel.cancelSearch(),
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
        });
  }
}