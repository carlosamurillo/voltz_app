import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/search/input_view_model.dart';
import 'package:stacked/stacked.dart' show ViewModelBuilder;

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchInputViewModel>.reactive(
        viewModelBuilder: () => SearchInputViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        fireOnViewModelReadyOnce: false,
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
                color: viewModel.isSearchSelected ? AppKeys().customColors!.dark : AppKeys().customColors!.darkPlusOne,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              textInputAction: TextInputAction.none,
              onChanged: viewModel.onTexInputChanged,
              onTap: () async => viewModel.changeSearchSelected(true),
              //onEditingComplete: () async => viewModel.changeSearchSelected(false), // ESta activando el boton de cerrar al dar enter
              onSaved: (v) async => viewModel.changeSearchSelected(false),
              controller: viewModel.searchTextController,
              focusNode: viewModel.focusNodeSearch,
              decoration: InputDecoration(
                hintText: 'Agregar productos',
                hintStyle: TextStyle(color: AppKeys().customColors!.darkPlusOne),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  size: 24,
                  color: viewModel.isSearchSelected ? AppKeys().customColors!.dark : AppKeys().customColors!.dark1,
                ),
                suffixIcon: viewModel.isSearchSelected
                    ? IconButton(
                        onPressed: () async => viewModel.cancelSearch(),
                        icon: Icon(
                          Icons.close,
                          size: 24,
                          color: AppKeys().customColors!.dark,
                        ),
                      )
                    : null,
                alignLabelWithHint: true,
                focusColor: AppKeys().customColors!.dark,
              ),
            ),
          );
        });
  }
}
