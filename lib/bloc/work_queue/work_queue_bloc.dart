import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:network_calls/src.dart';
import 'package:warehouse_3d/contants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/models/work_queue_model.dart';

part 'work_queue_event.dart';
part 'work_queue_state.dart';

class WorkQueueBloc extends Bloc<WorkQueueEvent, WorkQueueState> {
  WorkQueueBloc({required NetworkCalls networkCalls})
      : _networkCalls = networkCalls,
        super(WorkQueueState.initial()) {
    on<GetWorkQueueData>(_onGetWorkQueueData);
  }

  NetworkCalls _networkCalls;
  NetworkCalls _workQueueApi = NetworkCalls('https://paas.nalsoft.net:4443/ords/xxwms/wms/', getIt<Dio>(),
      connectTimeout: 30, receiveTimeout: 30, username: 'NALSOFT', password: 'Nalsoft@123');

  Future<void> _onGetWorkQueueData(WorkQueueEvent event, Emitter<WorkQueueState> emit) async {
    try {
      emit(state.copyWith(workQueueStatus: WorkQueueStatus.loading));
      await _workQueueApi.get(AppConstants.WORK_QUEUE, queryParameters: {'facility_id': '243'}).then((result) {
        if (result.response!.statusCode == 200) {
          WorkQueue data = WorkQueue.fromJson(jsonDecode(result.response!.data)["data"]);
          emit(state.copyWith(workQueueData: data, workQueueStatus: WorkQueueStatus.success));
        } else {
          emit(state.copyWith(workQueueStatus: WorkQueueStatus.failure));
        }
      });
    } catch (e) {
      emit(state.copyWith(workQueueStatus: WorkQueueStatus.failure));
    }
  }
}
