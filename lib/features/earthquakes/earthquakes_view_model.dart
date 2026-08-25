import 'package:flutter/foundation.dart';
import '../../data/models/earthquake.dart';
import '../../data/models/sort_option.dart';
import '../../domain/usecases/get_earthquakes_usecase.dart';

/// Mirrors Quake/Features/Earthquakes/EarthquakesView/EarthquakesViewModel.swift.
class EarthquakesViewModel extends ChangeNotifier {
  final GetEarthquakesUseCase getEarthquakesUseCase;
  static const int _pageSize = 20;

  EarthquakesViewModel({required this.getEarthquakesUseCase});

  List<Earthquake> earthquakes = [];
  List<Earthquake> filteredEarthquakes = [];
  bool isFiltering = false;
  bool isSorted = false;
  bool isLoading = false;
  bool isLoadingPage = false;
  bool hasMoreData = true;
  Object? error;

  SortOption? _activeSortOption;
  bool _sortAscending = false;
  int _pageNumber = 0;

  DateTime? lastStartDate;
  DateTime? lastEndDate;
  String placeQuery = '';

  List<Earthquake> get visibleEarthquakes =>
      isFiltering ? filteredEarthquakes : earthquakes;

  // MARK: - Paginated earthquakes

  Future<void> getLatestEarthquakes({bool isPaginating = false}) async {
    if (isLoading || isLoadingPage || !hasMoreData) return;

    if (isPaginating) {
      isLoadingPage = true;
    } else {
      isLoading = true;
    }
    notifyListeners();

    try {
      final offset = _pageNumber * _pageSize + 1;
      final newQuakes = await getEarthquakesUseCase.getLatestEarthquakes(
        offset: offset,
        pageSize: _pageSize,
      );

      if (isPaginating) {
        earthquakes = [...earthquakes, ...newQuakes];
      } else {
        earthquakes = newQuakes;
      }

      hasMoreData = newQuakes.length == _pageSize;
      if (hasMoreData) {
        _pageNumber += 1;
      }
      error = null;
    } catch (e) {
      error = e;
    } finally {
      isLoading = false;
      isLoadingPage = false;
      notifyListeners();
    }
  }

  Future<void> refreshEarthquakes() async {
    _pageNumber = 0;
    hasMoreData = true;

    if (isFiltering) {
      filteredEarthquakes = [];
      await _getFilteredEarthquakes();
    } else {
      earthquakes = [];
      await getLatestEarthquakes();
    }
  }

  // MARK: - Filtering

  Future<void> filterEarthquakes({
    required DateTime startDate,
    required DateTime endDate,
    required String placeQuery,
  }) async {
    isFiltering = true;
    _pageNumber = 0;
    filteredEarthquakes = [];
    hasMoreData = true;

    lastStartDate = startDate;
    lastEndDate = endDate;
    this.placeQuery = placeQuery;

    await _getFilteredEarthquakes();
  }

  Future<void> _getFilteredEarthquakes() async {
    final offset = _pageNumber * _pageSize + 1;

    try {
      final results = await getEarthquakesUseCase.getEarthquakesBetweenDates(
        startDate: lastStartDate,
        endDate: lastEndDate,
        offset: offset,
        pageSize: _pageSize,
      );

      hasMoreData = results.length == _pageSize;

      var toAppend = results;
      if (placeQuery.trim().isNotEmpty) {
        final needle = placeQuery.trim().toLowerCase();
        toAppend = results
            .where((eq) => eq.place.toLowerCase().contains(needle))
            .toList();
      }

      if (_pageNumber == 0) {
        filteredEarthquakes = toAppend;
      } else {
        filteredEarthquakes = [...filteredEarthquakes, ...toAppend];
      }
      error = null;
    } catch (e) {
      error = e;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadMoreFilteredEarthquakes() async {
    if (!isFiltering || !hasMoreData) return;
    _pageNumber += 1;
    await _getFilteredEarthquakes();
  }

  Future<void> clearFiltersAndReload() async {
    isFiltering = false;
    isSorted = false;
    _activeSortOption = null;
    _pageNumber = 0;
    hasMoreData = true;
    placeQuery = '';
    filteredEarthquakes = [];
    notifyListeners();
    await getLatestEarthquakes();
  }

  // MARK: - Ordering

  SortOption? get activeSortOption => _activeSortOption;
  bool get sortAscending => _sortAscending;

  void applySort(SortOption option) {
    if (_activeSortOption == option) {
      _sortAscending = !_sortAscending;
    } else {
      _activeSortOption = option;
      _sortAscending = true;
    }

    final list = isFiltering ? filteredEarthquakes : earthquakes;
    switch (option) {
      case SortOption.magnitude:
        list.sort((a, b) => _sortAscending
            ? a.originalMagnitude.compareTo(b.originalMagnitude)
            : b.originalMagnitude.compareTo(a.originalMagnitude));
      case SortOption.date:
        list.sort((a, b) => _sortAscending
            ? a.originalDate.compareTo(b.originalDate)
            : b.originalDate.compareTo(a.originalDate));
      case SortOption.place:
        list.sort((a, b) => _sortAscending
            ? a.simplifiedTitle.toLowerCase().compareTo(b.simplifiedTitle.toLowerCase())
            : b.simplifiedTitle.toLowerCase().compareTo(a.simplifiedTitle.toLowerCase()));
    }

    isSorted = true;
    notifyListeners();
  }
}
