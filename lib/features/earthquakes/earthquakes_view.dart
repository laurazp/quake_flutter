import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_dependencies.dart';
import '../../core/constants.dart';
import '../../core/design/dimens.dart';
import '../../core/units_controller.dart';
import '../../data/models/earthquake.dart';
import '../../data/models/sort_option.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_alert_dialog.dart';
import '../../widgets/quake_loader.dart';
import '../earthquake_detail/earthquake_detail_view.dart';
import 'earthquakes_view_model.dart';
import 'widgets/earthquake_item.dart';
import 'widgets/filters_sheet.dart';

/// Mirrors Quake/Features/Earthquakes/EarthquakesView/EarthquakesView.swift.
class EarthquakesView extends StatefulWidget {
  const EarthquakesView({super.key});

  @override
  State<EarthquakesView> createState() => _EarthquakesViewState();
}

class _EarthquakesViewState extends State<EarthquakesView> {
  late final EarthquakesViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  Object? _lastHandledError;

  @override
  void initState() {
    super.initState();
    final deps = context.read<AppDependencies>();
    _viewModel = EarthquakesViewModel(getEarthquakesUseCase: deps.getEarthquakesUseCase);
    _viewModel.addListener(_onViewModelChanged);
    _scrollController.addListener(_onScroll);
    _viewModel.getLatestEarthquakes();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});

    if (_viewModel.error != null && _viewModel.error != _lastHandledError) {
      _lastHandledError = _viewModel.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showErrorLoadingListAlert(
          context: context,
          message: _viewModel.error.toString(),
          onRetry: () => _viewModel.getLatestEarthquakes(),
        );
      });
    } else if (_viewModel.error == null) {
      _lastHandledError = null;
    }
  }

  void _onScroll() {
    final atBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400;
    if (atBottom && !_viewModel.isLoadingPage && _viewModel.hasMoreData) {
      if (_viewModel.isFiltering) {
        _viewModel.loadMoreFilteredEarthquakes();
      } else {
        _viewModel.getLatestEarthquakes(isPaginating: true);
      }
    }

    final shouldShow = _scrollController.hasClients && _scrollController.offset > 400;
    if (shouldShow != _showScrollToTop) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  Future<void> _openFilters() async {
    final now = DateTime.now();
    final result = await showFiltersSheet(
      context: context,
      initialStartDate: _viewModel.lastStartDate ?? now,
      initialEndDate: _viewModel.lastEndDate ?? now,
      initialSearchText: _viewModel.placeQuery,
    );
    if (result == null) return;
    await _viewModel.filterEarthquakes(
      startDate: result.startDate,
      endDate: result.endDate,
      placeQuery: result.searchText,
    );
  }

  void _openDetail(Earthquake earthquake) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EarthquakeDetailView(earthquake: earthquake)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unit = context.watch<UnitsController>().unit;
    final list = _viewModel.visibleEarthquakes;

    return Scaffold(
      appBar: AppBar(title: const Text('Earthquakes')),
      body: _viewModel.isLoading
          ? const QuakeLoader(label: 'Reading the ground…')
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _viewModel.refreshEarthquakes,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(child: _buildToolbar(context)),
                      if (list.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyState(),
                        )
                      else
                        SliverList.builder(
                          itemCount: list.length + (_viewModel.isLoadingPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= list.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: Dimens.largeMargin),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                  ),
                                ),
                              );
                            }
                            final earthquake = list[index];
                            return EarthquakeItem(
                              key: ValueKey(earthquake.id),
                              earthquake: earthquake,
                              unit: unit,
                              onSeeDetails: () => _openDetail(earthquake),
                            );
                          },
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 96)),
                    ],
                  ),
                ),
                if (_showScrollToTop)
                  Positioned(
                    right: Dimens.semiLargeMargin,
                    bottom: Dimens.semiLargeMargin,
                    child: FloatingActionButton(
                      heroTag: 'scrollToTop',
                      onPressed: () => _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      ),
                      child: Icon(AppConstants.arrowUpIcon),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.semiLargeMargin,
        Dimens.smallMargin,
        Dimens.semiLargeMargin,
        Dimens.smallMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: 'Filter',
                icon: AppConstants.filterEarthquakesIcon,
                onPressed: _openFilters,
              ),
              const SizedBox(width: Dimens.smallMargin),
              PopupMenuButton<SortOption>(
                tooltip: 'Sort',
                onSelected: _viewModel.applySort,
                itemBuilder: (context) => [
                  _sortMenuItem(SortOption.magnitude, 'Magnitude'),
                  _sortMenuItem(SortOption.date, 'Date'),
                  _sortMenuItem(SortOption.place, 'Place'),
                ],
                child: IgnorePointer(
                  child: CustomButton(
                    text: 'Sort',
                    icon: AppConstants.sortEarthquakesIcon,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          if (_viewModel.isFiltering || _viewModel.isSorted) ...[
            const SizedBox(height: Dimens.smallMargin),
            CustomButton(
              text: 'Clear filters',
              icon: AppConstants.clearFiltersIcon,
              isSmall: true,
              isDestructive: true,
              onPressed: _viewModel.clearFiltersAndReload,
            ),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<SortOption> _sortMenuItem(SortOption option, String label) {
    final isActive = _viewModel.activeSortOption == option;
    return PopupMenuItem(
      value: option,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (isActive)
            Icon(
              _viewModel.sortAscending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              size: 16,
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.hugeMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppConstants.earthquakeMapPinIcon,
                size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: Dimens.mediumMargin),
            Text(
              'No earthquakes found for these filters.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
