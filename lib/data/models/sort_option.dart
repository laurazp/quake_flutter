/// Mirrors Quake/Entities/SortOption.swift.
enum SortOption { magnitude, date, place }

enum SortDirection {
  ascending,
  descending;

  SortDirection get toggled =>
      this == SortDirection.ascending ? SortDirection.descending : SortDirection.ascending;
}
