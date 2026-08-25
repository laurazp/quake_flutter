import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/design/dimens.dart';

/// Mirrors Quake/Widgets/FiltersSheet.swift — a modal sheet for picking a
/// start/end date range and an optional place-name search.
class FiltersSheetResult {
  final DateTime startDate;
  final DateTime endDate;
  final String searchText;

  const FiltersSheetResult({
    required this.startDate,
    required this.endDate,
    required this.searchText,
  });
}

Future<FiltersSheetResult?> showFiltersSheet({
  required BuildContext context,
  required DateTime initialStartDate,
  required DateTime initialEndDate,
  required String initialSearchText,
}) {
  return showModalBottomSheet<FiltersSheetResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _FiltersSheetContent(
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      initialSearchText: initialSearchText,
    ),
  );
}

class _FiltersSheetContent extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final String initialSearchText;

  const _FiltersSheetContent({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.initialSearchText,
  });

  @override
  State<_FiltersSheetContent> createState() => _FiltersSheetContentState();
}

class _FiltersSheetContentState extends State<_FiltersSheetContent> {
  late DateTime _startDate = widget.initialStartDate;
  late DateTime _endDate = widget.initialEndDate;
  late final TextEditingController _searchController =
      TextEditingController(text: widget.initialSearchText);
  static final _dateFormat = DateFormat.yMMMd();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.semiLargeMargin,
        right: Dimens.semiLargeMargin,
        top: Dimens.semiLargeMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + Dimens.semiLargeMargin,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: Dimens.largeMargin),
          Text('Select dates range', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: Dimens.smallMargin),
          Container(
            padding: const EdgeInsets.all(Dimens.smallMargin),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
            ),
            child: Column(
              children: [
                _DateRow(
                  label: 'Start date',
                  value: _dateFormat.format(_startDate),
                  onTap: () => _pickDate(isStart: true),
                ),
                const Divider(height: 1),
                _DateRow(
                  label: 'End date',
                  value: _dateFormat.format(_endDate),
                  onTap: () => _pickDate(isStart: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimens.largeMargin),
          Text('Search place', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: Dimens.smallMargin),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Enter place name'),
          ),
          const SizedBox(height: Dimens.largeMargin),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(
                  FiltersSheetResult(
                    startDate: _startDate,
                    endDate: _endDate,
                    searchText: _searchController.text,
                  ),
                );
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateRow({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.chipCornerRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.smallMargin,
          vertical: Dimens.mediumMargin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
