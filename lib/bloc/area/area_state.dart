part of 'area_bloc.dart';

enum AreaStatus { initial, loading, success, failure }

final class AreaState {
  AreaState({this.getAreaStatus, this.customers, this.selectedCustomerIndex, this.areaTileHoveredIndex});

  AreaStatus? getAreaStatus;
  List<Customer>? customers;
  int? selectedCustomerIndex;
  int? areaTileHoveredIndex;

  factory AreaState.initial() {
    return AreaState(getAreaStatus: AreaStatus.initial, customers: [], selectedCustomerIndex: 0, areaTileHoveredIndex: null);
  }

  AreaState copyWith({
    AreaStatus? getAreaStatus,
    List<Customer>? customers,
    int? selectedCustomerIndex,
    int? areaTileHoveredIndex,
  }) {
    return AreaState(
        getAreaStatus: getAreaStatus ?? this.getAreaStatus,
        customers: customers ?? this.customers,
        areaTileHoveredIndex: areaTileHoveredIndex,
        selectedCustomerIndex: selectedCustomerIndex ?? this.selectedCustomerIndex);
  }
}
