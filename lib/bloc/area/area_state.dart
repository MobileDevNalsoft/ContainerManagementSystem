part of 'area_bloc.dart';

enum AreaStatus { initial, loading, success, failure }

enum AvailableLotsStatus { initial, loading, success, noDataFound, failure }

enum SearchContainerStatus { initial, loading, success, noDataFound, failure }

final class AreaState {
  AreaState(
      {this.getAreaStatus,
      this.getSearchContainerStatus,
      this.customers,
      this.selectedCustomerIndex,
      this.availableLots,
      this.getAvailableLotsStatus,
      this.selectedContainerIndex,
      this.areaTileHoveredIndex});

  AreaStatus? getAreaStatus;
  SearchContainerStatus? getSearchContainerStatus;
  List<Customer>? customers;
  List<String>? availableLots;
  int? selectedCustomerIndex;
  int? selectedContainerIndex;
  int? areaTileHoveredIndex;
  AvailableLotsStatus? getAvailableLotsStatus;

  factory AreaState.initial() {
    return AreaState(
        getAreaStatus: AreaStatus.initial,
        getSearchContainerStatus: SearchContainerStatus.initial,
        getAvailableLotsStatus: AvailableLotsStatus.initial,
        customers: [],
        selectedCustomerIndex: 0,
        availableLots: [],
        selectedContainerIndex: 0,
        areaTileHoveredIndex: null);
  }

  AreaState copyWith({
    AreaStatus? getAreaStatus,
    SearchContainerStatus? getSearchContainerStatus,
    AvailableLotsStatus? getAvailableLotsStatus,
    List<Customer>? customers,
    List<String>? availableLots,
    int? selectedCustomerIndex,
    int? selectedContainerIndex,
    int? areaTileHoveredIndex,
  }) {
    return AreaState(
        getAreaStatus: getAreaStatus ?? this.getAreaStatus,
        getSearchContainerStatus: getSearchContainerStatus ?? this.getSearchContainerStatus,
        getAvailableLotsStatus: getAvailableLotsStatus ?? this.getAvailableLotsStatus,
        availableLots: availableLots ?? this.availableLots,
        customers: customers ?? this.customers,
        areaTileHoveredIndex: areaTileHoveredIndex,
        selectedCustomerIndex: selectedCustomerIndex ?? this.selectedCustomerIndex,
        selectedContainerIndex: selectedContainerIndex ?? this.selectedContainerIndex);
  }
}
