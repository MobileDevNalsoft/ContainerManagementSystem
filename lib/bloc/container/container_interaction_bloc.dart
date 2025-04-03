import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:network_calls/src.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import 'package:warehouse_3d/logger/logger.dart';
import 'package:warehouse_3d/models/area_model.dart';
import 'package:warehouse_3d/models/areas_model.dart';

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
    on<Intercepting>(_onIntercepting);
    on<RelocateContainer>(_onRelocateContainer);
    on<DeleteContainer>(_onDeleteContainer);
    on<ModelLoaded>(_onModelLoaded);
    on<DataFromJS>(_onDataFromJS);
    on<SearchContainer>(_onSearchContainer);
    on<SelectedArea>(_onSelectedArea);
  }

  Future<void> _onGetLotsData(GetLotsData event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getLotsDataStatus: LotsDataStatus.loading));

    try {
      await _networkCalls.get(AppConstants.GET_AREA_LOTS).then(
        (apiResponse) {
          Log.d(jsonDecode(apiResponse.response!.data)['data']);
          emit(state.copyWith(
              lotsData: jsonDecode(apiResponse.response!.data)['data'],
              areas: Areas.fromJson(jsonDecode(apiResponse.response!.data)['data']),
              getLotsDataStatus: LotsDataStatus.success,
              sentDataToJS: true));
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

  Future<void> _onSearchContainer(SearchContainer event, Emitter<ContainerInteractionState> emit) async {
    emit(state.copyWith(getSearchStatus: SearchStatus.loading));
    await _networkCalls.get(AppConstants.SEARCH_CONTAINER, queryParameters: {"container_nbr": event.containerNbr}).then((apiResponse) {
      Map<String, dynamic> response = jsonDecode(apiResponse.response!.data!);
      SearchedContainer container = SearchedContainer.fromJson(response['data']);
      if (response['response_code'] == 200) {
        add(DataFromJS(dataFromJS: {"area": container.area!.toUpperCase()}));
        state.webViewController!.evaluateJavascript(source: 'switchCamera("${container.area!.toUpperCase()}_AREA")');
        emit(state.copyWith(getSearchStatus: SearchStatus.success, searchedContainer: container));
      } else {
        Error();
      }
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(getSearchStatus: SearchStatus.failure));
      },
    );
  }

  void _onWebLoaded(WebLoaded event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(webLoaded: event.loaded));
  }

  void _onModelLoaded(ModelLoaded event, Emitter<ContainerInteractionState> emit) {
    emit(state.copyWith(modelLoaded: event.loaded));
  }

  void _onDataFromJS(DataFromJS event, Emitter<ContainerInteractionState> emit) {
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
}
