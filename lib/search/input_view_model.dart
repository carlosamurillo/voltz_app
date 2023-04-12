import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maketplace/app/app.locator.dart';
import 'package:maketplace/common/open_search_service.dart';
import 'package:maketplace/search/input_search_repository.dart';
import 'package:maketplace/search/search_repository.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel;

class SearchInputViewModel extends ReactiveViewModel {
  final InputSearchRepository _inputSearchRepository = locator<InputSearchRepository>();
  final ProductSearchRepository _productSearchRepository = locator<ProductSearchRepository>();
  final OpenSearchService _openSearchService = locator<OpenSearchService>();

  TextEditingController get searchTextController => _inputSearchRepository.searchTextController;
  bool get isSearchSelected => _inputSearchRepository.isSearchSelected;

  FocusNode get focusNodeSearch => _inputSearchRepository.focusNodeSearch;

  init() async {
    isSearchSelected ? _inputSearchRepository.focusNodeSearch.requestFocus() : _inputSearchRepository.focusNodeSearch.unfocus();
    _productSearchRepository.setupLastQuery();

    return notifyListeners();
  }

  @override
  void dispose() {
    _inputSearchRepository.onDispose();
    super.dispose();
  }

  final Debouncer _debouncer = Debouncer(milliseconds: 400);
  onTexInputChanged(String value) {
    _debouncer.run(() {
      _executeQueryListener(value);
    });
  }

  _executeQueryListener(String query) {
    _productSearchRepository.query(query);
  }

  changeSearchSelected(bool selected) async {
    if (!selected) _inputSearchRepository.focusNodeSearch.unfocus();
    _inputSearchRepository.changeSearchSelected(selected);
    return notifyListeners();
  }

  cancelSearch() async {
    // _inputSearchRepository.focusNodeSearch.unfocus();
    _inputSearchRepository.cancelSearch();
    _openSearchService.changeSearchOpened(false);
    return notifyListeners();
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  cancel() {
    if (null != _timer) {
      _timer!.cancel();
    }
  }

  run(VoidCallback action) {
    cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
