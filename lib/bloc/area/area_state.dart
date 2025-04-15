part of 'area_bloc.dart';

enum AreaStatus { initial, loading, success, failure }

enum SearchContainerStatus { initial, loading, success, noDataFound, failure }

final class AreaState {
  AreaState(
      {this.getAreaStatus, this.getSearchContainerStatus, this.customers, this.selectedCustomerIndex, this.selectedContainerIndex, this.areaTileHoveredIndex});

  AreaStatus? getAreaStatus;
  SearchContainerStatus? getSearchContainerStatus;
  List<Customer>? customers;
  int? selectedCustomerIndex;
  int? selectedContainerIndex;
  int? areaTileHoveredIndex;

  factory AreaState.initial() {
    return AreaState(
        getAreaStatus: AreaStatus.initial,
        getSearchContainerStatus: SearchContainerStatus.initial,
        customers: [],
        selectedCustomerIndex: 0,
        selectedContainerIndex: 0,
        areaTileHoveredIndex: null);
  }

  AreaState copyWith({
    AreaStatus? getAreaStatus,
    SearchContainerStatus? getSearchContainerStatus,
    List<Customer>? customers,
    int? selectedCustomerIndex,
    int? selectedContainerIndex,
    int? areaTileHoveredIndex,
  }) {
    return AreaState(
        getAreaStatus: getAreaStatus ?? this.getAreaStatus,
        getSearchContainerStatus: getSearchContainerStatus ?? this.getSearchContainerStatus,
        customers: customers ?? this.customers,
        areaTileHoveredIndex: areaTileHoveredIndex,
        selectedCustomerIndex: selectedCustomerIndex ?? this.selectedCustomerIndex,
        selectedContainerIndex: selectedContainerIndex ?? this.selectedContainerIndex);
  }
}
