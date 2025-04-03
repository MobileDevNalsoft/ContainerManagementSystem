part of 'work_queue_bloc.dart';

sealed class WorkQueueEvent extends Equatable {
  const WorkQueueEvent();

  @override
  List<Object> get props => [];
}


class GetWorkQueueData extends WorkQueueEvent{
  const GetWorkQueueData();
}
