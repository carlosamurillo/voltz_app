import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  late FocusNode _focusNodeSearch;
  late TextEditingController _searchTextController;
  late bool _searchSelected;

  FocusNode get focusNodeSearch => _focusNodeSearch;
  TextEditingController get searchTextController => _searchTextController;
  bool get isSearchSelected => _searchSelected;

  void init() {
    _focusNodeSearch = FocusNode();
    _searchTextController = TextEditingController();
    _searchSelected = false;
    notifyListeners();
  }

  Future<void> changeSearchSelected(bool selected) async {
    if (!selected) _focusNodeSearch.unfocus();
    _searchSelected = selected;
    notifyListeners();
  }

  Future<void> cancelSsarch() async {
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
