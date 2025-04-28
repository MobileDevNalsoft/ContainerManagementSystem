import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:network_calls/src.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import 'package:warehouse_3d/logger/logger.dart';
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
    on<SearchContainer>(_onSearchContainer);
    on<SelectedCustomer>(_onSelectedCustomer);
    on<SelectedContainer>(_onSelectedContainer);
    on<AreaTileHovered>(_onAreaTileHovered);
    on<GetAvailableLots>(_onGetAvailableLots);
  }

  Future<void> _onGetAreaData(GetAreaData event, Emitter<AreaState> emit) async {
    emit(state.copyWith(getAreaStatus: AreaStatus.loading, customers: []));
    await _networkCalls.get(AppConstants.GET_AREA_DATA, queryParameters: {"area": event.area}).then((apiResponse) {
      Log.d(jsonDecode(apiResponse.response!.data!));
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

  Future<void> _onSearchContainer(SearchContainer event, Emitter<AreaState> emit) async {
    emit(state.copyWith(getSearchContainerStatus: SearchContainerStatus.loading, customers: []));
    await _networkCalls.get(AppConstants.SEARCH_CONTAINER, queryParameters: {"container_nbr": event.containerNbr}).then((apiResponse) {
      Log.d(jsonDecode(apiResponse.response!.data!));
      AreaResponse<Customer> response = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data!), (json) => Customer.fromJson(json));
      if (response.responseCode == 200) {
        emit(state.copyWith(getSearchContainerStatus: SearchContainerStatus.success, customers: response.data));
      } else if (response.responseCode == 404) {
        emit(state.copyWith(getSearchContainerStatus: SearchContainerStatus.noDataFound));
      } else {
        Error();
      }
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(getSearchContainerStatus: SearchContainerStatus.failure));
      },
    );
  }

  Future<void> _onGetAvailableLots(GetAvailableLots event, Emitter<AreaState> emit) async {
    emit(state.copyWith(getAvailableLotsStatus: AvailableLotsStatus.loading));
    await _networkCalls.get(AppConstants.GET_AVAILABLE_LOTS, queryParameters: {"area": event.area, "container_nbr": event.containerNbr}).then((apiResponse) {
      Log.d(jsonDecode(apiResponse.response!.data!));
      Map<String, dynamic> response = jsonDecode(apiResponse.response!.data);
      List<String> lots = (response['data'] as List<dynamic>).map((e) => e.toString()).toList();
      if (response['response_code'] == 200) {
        emit(state.copyWith(getAvailableLotsStatus: AvailableLotsStatus.success, availableLots: lots));
      } else if (response['response_code'] == 404) {
        emit(state.copyWith(getAvailableLotsStatus: AvailableLotsStatus.noDataFound));
      } else {
        Error();
      }
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(getAvailableLotsStatus: AvailableLotsStatus.failure));
      },
    );
  }

  void _onSelectedCustomer(SelectedCustomer event, Emitter<AreaState> emit) {
    emit(state.copyWith(selectedCustomerIndex: event.index));
  }

  void _onSelectedContainer(SelectedContainer event, Emitter<AreaState> emit) {
    emit(state.copyWith(selectedContainerIndex: event.index));
  }

  void _onAreaTileHovered(AreaTileHovered event, Emitter<AreaState> emit) {
    emit(state.copyWith(areaTileHoveredIndex: event.index));
  }
}
