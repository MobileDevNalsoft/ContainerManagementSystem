import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:network_calls/src.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import 'package:warehouse_3d/logger/logger.dart';

part 'container_interaction_event.dart';
part 'container_interaction_state.dart';

class ContainerInteractionBloc extends Bloc<ContainerInteractionEvent, ContainerInteractionState> {
  final NetworkCalls _networkCalls;

  ContainerInteractionBloc({required NetworkCalls networkCalls})
      : _networkCalls = networkCalls,
        super(ContainerInteractionState.initial()) {
    on<GetLotsData>(_onGetLotsData);
    on<WebLoaded>(_onWebLoaded);
    on<AddContainer>(_onAddContainer);
    on<DeleteContainer>(_onDeleteContainer);
  }

  Future<void> _onGetLotsData(GetLotsData event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getLotsDataStatus: LotsDataStatus.loading));

    try {
      await _networkCalls.get(AppConstants.GET_AREA_LOTS).then(
        (apiResponse) {
          Log.d(jsonDecode(apiResponse.response!.data)['data']);
          emit(state.copyWith(lotsData: jsonDecode(apiResponse.response!.data)['data'], getLotsDataStatus: LotsDataStatus.success, sentDataToJS: true));
        },
      );
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getLotsDataStatus: LotsDataStatus.failure));
    }
  }

  Future<void> _onAddContainer(AddContainer event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getAddContainerStatus: AddContainerStatus.loading));

    try {
      await _networkCalls.post(AppConstants.ADD_CONTAINER, data: {"area": event.area, "container_nbr": event.containerNbr, "lot_no": event.lotNo}).then(
        (apiResponse) {
          add(GetLotsData());
          emit(state.copyWith(getAddContainerStatus: AddContainerStatus.success));
        },
      );
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getAddContainerStatus: AddContainerStatus.failure));
    }
  }

  Future<void> _onDeleteContainer(DeleteContainer event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getAddContainerStatus: AddContainerStatus.loading));

    try {
      await _networkCalls.post(AppConstants.DELETE_CONTAINER, data: {"area": event.area, "container_nbr": event.containerNbr}).then(
        (apiResponse) {
          add(GetLotsData());
          emit(state.copyWith(getAddContainerStatus: AddContainerStatus.success));
        },
      );
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getAddContainerStatus: AddContainerStatus.failure));
    }
  }

  void _onWebLoaded(WebLoaded event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(webLoaded: event.loaded));
  }
}
