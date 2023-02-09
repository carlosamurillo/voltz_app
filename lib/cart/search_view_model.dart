import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import '../search/serarch_repository.dart';

class SearchInputViewModel extends ChangeNotifier {
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();
  late FocusNode _focusNodeSearch;
  late TextEditingController _searchTextController;
  bool _searchSelected = false;

  FocusNode get focusNodeSearch => _focusNodeSearch;
  TextEditingController get searchTextController => _searchTextController;
  bool get isSearchSelected => _searchSelected;

  void init() {
    _focusNodeSearch = FocusNode();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() => _productSearchRepository.query(_searchTextController.text));
    notifyListeners();
  }

  Future<void> changeSearchSelected(bool selected) async {
    if (!selected) _focusNodeSearch.unfocus();
    _searchSelected = selected;
    notifyListeners();
  }

  Future<void> cancelSearch() async {
    _focusNodeSearch.unfocus();
    _searchSelected = false;
    _searchTextController.text = '';
    notifyListeners();
  }

  Future<void> searchElements() async {
    //TODO logic here
  }

  @override
  void dispose() {
    _focusNodeSearch.dispose();
    _searchTextController.dispose();
    super.dispose();
  }
}
