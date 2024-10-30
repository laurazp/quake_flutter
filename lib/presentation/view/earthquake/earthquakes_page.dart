
import 'package:flutter/material.dart';
import 'package:quake_flutter/di/app_modules.dart';
import 'package:quake_flutter/model/earthquake_list.dart';
import 'package:quake_flutter/model/earthquake.dart';
import 'package:quake_flutter/presentation/model/resource_state.dart';
import 'package:quake_flutter/presentation/view/earthquake/viewmodel/earthquakes_view_model.dart';
import 'package:quake_flutter/presentation/widget/earthquake_list_row.dart';
import 'package:quake_flutter/presentation/widget/error/error_view.dart';
import 'package:quake_flutter/presentation/widget/loading/loading_view.dart';

class EarthquakesPage extends StatefulWidget {
  const EarthquakesPage({super.key});

  @override
  State<EarthquakesPage> createState() => _EarthquakesPageState();
}

class _EarthquakesPageState extends State<EarthquakesPage> {
  final EarthquakesViewModel _earthquakesViewModel = inject<EarthquakesViewModel>();
  final List<Earthquake> _earthquakes = List.empty(growable: true);
  // List<Earthquake> _filteredEarthquakes = List.empty(growable: true);

  // final TextEditingController _searchController = TextEditingController();
  // bool _isAscendingOrder = false;

  final ScrollController _scrollController = ScrollController();
  bool _hasMoreItems = true;
  String startTime = "2024-10-27"; 
  String endTime = "2024-10-28";
  final int _limit = 50; //TODO: añadirlo en constantes y asignarlo sólo en la última llamada?
  int _offset = 1;

  @override
  void initState() {
    super.initState();

    _earthquakesViewModel.getEarthquakeListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          _addEarthquakes(state.data!);
          // _filterMonuments();
          break;
        case Status.ERROR:
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception!.toString(), () {
              _offset = 1;
              _earthquakesViewModel.fetchPagingEarthquakeList(startTime, endTime, _limit, _offset);
            });
          });
          break;
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreItems) {
        _earthquakesViewModel.fetchPagingEarthquakeList(startTime, endTime, _limit, _offset);
      }
    });

    _earthquakesViewModel.fetchPagingEarthquakeList(startTime, endTime, _limit, _offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Earthquakes"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // _showSearchBar();
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            // icon: Icon(_isAscendingOrder
            //     ? Icons.sort_by_alpha
            //     : Icons.sort_by_alpha_outlined),
            onPressed: () {
              // _toggleSortOrder();
            },
          ),
        ],
      ),
      body: SafeArea(child: _getContentView()),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1050),
          curve: Curves.decelerate,
        ),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  @override
  void dispose() {
    _earthquakesViewModel.dispose();
    super.dispose();
  }

  Widget _getContentView() {
    return RefreshIndicator(
      onRefresh: () async {
        _offset = 1;
        _earthquakesViewModel.fetchPagingEarthquakeList(startTime, endTime, _limit, _offset);
      },
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _earthquakes.length, //_filteredEarthquakes.length,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemBuilder: (context, index) {
            // final item = _filteredEarthquakes[index];
            final item = _earthquakes[index];
            return EarthquakeListRow(earthquake: item);
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 6,
          )
        ),
      ),
    );
  }

  // _filterEarthquakes() {
  //   String searchTerm = _searchController.text.toLowerCase();

  //   if (searchTerm.isEmpty) {
  //     _filteredEarthquakes = _earthquakes;
  //   } else {
  //     _filteredEarthquakes = _earthquakes
  //         .where(
  //             (feature) => feature.title.toLowerCase().contains(searchTerm))
  //         .toList();
  //   }

  //   setState(() {});
  // }

  // _showSearchBar() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Search Monuments"),
  //         content: TextField(
  //           controller: _searchController,
  //           onChanged: (value) {
  //             _filterMonuments();
  //           },
  //           decoration: const InputDecoration(
  //             hintText: "Enter Monument Title",
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               _searchController.text = "";
  //               _monumentsViewModel.fetchPagingMonumentList(_nextPage);
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Clear filters"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Accept"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // _sortEarthquakes() {
  //   _filteredEarthquakes.sort((a, b) {
  //     return _isAscendingOrder
  //         ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
  //         : b.title.toLowerCase().compareTo(a.title.toLowerCase());
  //   });
  // }

  // _toggleSortOrder() {
  //   _isAscendingOrder = !_isAscendingOrder;
  //   _sortEarthquakes();
  //   setState(() {});
  // }

  _addEarthquakes(EarthquakeList response) async {
    if (_offset == 1) {
      _earthquakes.clear();
    }

    _earthquakes.addAll(response.earthquakes);
    // _hasMoreItems = response.totalCount > _earthquakes.length;
    _offset += 50;

    setState(() {});
  }
}