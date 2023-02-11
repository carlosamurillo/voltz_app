import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel;
import 'input_search_repository.dart';
import 'search_repository.dart';

class SearchInputViewModel extends ReactiveViewModel {
  final InputSearchRepository _inputSearchRepository = locator<InputSearchRepository>();
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();
  late FocusNode _focusNodeSearch;
  final TextEditingController _searchTextController = TextEditingController();

  FocusNode get focusNodeSearch => _focusNodeSearch;
  TextEditingController get searchTextController => _searchTextController;
  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;

  init() async {
    _focusNodeSearch = FocusNode();
    _searchTextController.addListener(() async => _productSearchRepository.query(_searchTextController.text));
    _productSearchRepository.setupLastQuery();
    return notifyListeners();
  }

  changeSearchSelected(bool selected) async {
    if (!selected) _focusNodeSearch.unfocus();
    _inputSearchRepository.changeSearchSelected(selected);
    return notifyListeners();
  }

  cancelSearch() async {
    _focusNodeSearch.unfocus();
    _searchTextController.text = '';
    _inputSearchRepository.changeSearchSelected(false);
    return notifyListeners();
  }

  @override
  void dispose() async {
    _focusNodeSearch.dispose();
    _searchTextController.dispose();
    super.dispose();
  }
}
