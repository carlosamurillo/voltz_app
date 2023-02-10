import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel;
import 'input_search_repository.dart';
import 'serarch_repository.dart';

class SearchInputViewModel extends ReactiveViewModel {
  final InputSearchRepository _inputSearchRepository = locator<InputSearchRepository>();
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();
  late FocusNode _focusNodeSearch;
  late TextEditingController _searchTextController;

  FocusNode get focusNodeSearch => _focusNodeSearch;
  TextEditingController get searchTextController => _searchTextController;
  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;

  void init() async {
    _focusNodeSearch = FocusNode();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() async => _productSearchRepository.query(_searchTextController.text));
  }

  Future<void> changeSearchSelected(bool selected) async {
    if (!selected) _focusNodeSearch.unfocus();
    _inputSearchRepository.changeSearchSelected(selected);
  }

  Future<void> cancelSearch() async {
    _focusNodeSearch.unfocus();
    _searchTextController.text = '';
    _inputSearchRepository.changeSearchSelected(false);
  }

  @override
  void dispose() {
    _focusNodeSearch.dispose();
    _searchTextController.dispose();
    super.dispose();
  }
}
