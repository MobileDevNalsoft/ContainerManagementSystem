import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_calls/src.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import 'package:warehouse_3d/models/areas_model.dart';
import 'package:warehouse_3d/models/area_model.dart';

part 'area_event.dart';
part 'area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  final NetworkCalls _networkCalls;

  AreaBloc({required NetworkCalls networkCalls})
      : _networkCalls = networkCalls,
        super(AreaState.initial()) {
    on<GetAreaData>(_onGetAreaData);
    on<SelectedCustomer>(_onSelectedCustomer);
    on<AreaTileHovered>(_onAreaTileHovered);
  }

  Future<void> _onGetAreaData(GetAreaData event, Emitter<AreaState> emit) async {
    emit(state.copyWith(getAreaStatus: AreaStatus.loading));
    print('area ${event.area}');
    await _networkCalls.get(AppConstants.GET_AREA_DATA, queryParameters: {"area": event.area}).then((apiResponse) {
      AreaResponse<Customer> response = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data!), (json) => Customer.fromJson(json));
      if (response.responseCode == 200) {
        emit(state.copyWith(getAreaStatus: AreaStatus.success, customers: response.data));
      } else {
        Error();
      }
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(getAreaStatus: AreaStatus.failure));
      },
    );
  }

  void _onSelectedCustomer(SelectedCustomer event, Emitter<AreaState> emit) {
    emit(state.copyWith(selectedCustomerIndex: event.index));
  }

  void _onAreaTileHovered(AreaTileHovered event, Emitter<AreaState> emit) {
    emit(state.copyWith(areaTileHoveredIndex: event.index));
  }
}
