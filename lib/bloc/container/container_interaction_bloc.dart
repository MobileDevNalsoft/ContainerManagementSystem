import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:network_calls/src.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import 'package:warehouse_3d/logger/logger.dart';
import 'package:warehouse_3d/models/area_model.dart';
import 'package:warehouse_3d/models/areas_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'container_interaction_event.dart';
part 'container_interaction_state.dart';

const _kCacheKey = 'area_lots_data';

class ContainerInteractionBloc extends Bloc<ContainerInteractionEvent, ContainerInteractionState> {
  final NetworkCalls _networkCalls;
  final CacheManager _cacheManager;

  ContainerInteractionBloc({required NetworkCalls networkCalls, required CacheManager cacheManager})
      : _networkCalls = networkCalls,
        _cacheManager = cacheManager,
        super(ContainerInteractionState.initial()) {
    on<GetLotsData>(_onGetLotsData);
    on<WebLoaded>(_onWebLoaded);
    on<AddContainer>(_onAddContainer);
    on<Intercepting>(_onIntercepting);
    on<RelocateContainer>(_onRelocateContainer);
    on<DeleteContainer>(_onDeleteContainer);
    on<ModelLoaded>(_onModelLoaded);
    on<DataFromJS>(_onDataFromJS);
    on<SelectedArea>(_onSelectedArea);
    on<DropdownAreaChanged>(_onDropdownAreaChanged);
    on<DropdownLotChanged>(_onDropdownLotChanged);
  }

  Future<void> _cacheLotsData(Map<String, dynamic> data) async {
    try {
      final jsonData = jsonEncode(data);
      await state.webViewController!.webStorage.localStorage.setItem(key: _kCacheKey, value: jsonData);
      Log.d('Lots data cached successfully at local storage');
    } catch (e) {
      Log.e('Error caching lots data: $e');
    }
  }

  Future<void> _onGetLotsData(GetLotsData event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getLotsDataStatus: LotsDataStatus.loading));
    try {
      final apiResponse = await _networkCalls.get(AppConstants.GET_LOTS_DATA);
      final responseData = jsonDecode(apiResponse.response!.data)['data'];
      Log.d(responseData);
      emit(state.copyWith(
        lotsData: responseData,
        getLotsDataStatus: LotsDataStatus.success,
        sentDataToJS: true,
      ));
      _cacheLotsData(responseData);
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getLotsDataStatus: LotsDataStatus.failure));
    }
  }

  Future<void> _onAddContainer(AddContainer event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getAddContainerStatus: AddContainerStatus.loading));

    try {
      await _networkCalls.post(AppConstants.ADD_CONTAINER, data: {
        "area": event.area,
        "container_nbr": event.containerNbr,
        "lot_no": event.lotNo,
        "arrival_time": DateTime.now().toString(),
        "customer_name": "Sravan"
      }).then(
        (apiResponse) {
          Map<String, dynamic> data = jsonDecode(apiResponse.response!.data!);
          if (data['response_code'] == 200) {
            add(GetLotsData());
            state.webViewController!.evaluateJavascript(source: 'addContainer("${event.containerNbr}","${event.area}");');
            emit(state.copyWith(getAddContainerStatus: AddContainerStatus.success));
          } else if (data['response_code'] == 601) {
            print(data['response_message']);
            Error();
          }
        },
      );
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getAddContainerStatus: AddContainerStatus.failure));
    }
  }

  Future<void> _onRelocateContainer(RelocateContainer event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getAddContainerStatus: AddContainerStatus.loading));

    try {
      await _networkCalls.post(AppConstants.RELOCATE_CONTAINER, data: {
        "area": event.area,
        "lot_no": event.lotNo,
        "container_nbr": event.containerNbr,
      }).then(
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

  void _onModelLoaded(ModelLoaded event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(modelLoaded: event.loaded));
  }

  void _onDataFromJS(DataFromJS event, Emitter<ContainerInteractionState> emit) {
    if (event.dataFromJS.values.first == 'null') {
      add(SelectedArea(selectedArea: AreaName.Area));
    }
    emit(state.copyWith(dataFromJS: event.dataFromJS));
  }

  void _onIntercepting(Intercepting event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(intercepting: event.intercepting));
  }

  void _onSelectedArea(SelectedArea event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(
      selectedAreaName: event.selectedArea,
    ));
  }

  void _onDropdownAreaChanged(DropdownAreaChanged event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(selectedDropdownArea: event.area));
  }

  void _onDropdownLotChanged(DropdownLotChanged event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(selectedDropdownLot: event.lotNo));
  }
}
