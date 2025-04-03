part of 'work_queue_bloc.dart';

enum WorkQueueStatus { initial, loading, success, failure }

class WorkQueueState {
  WorkQueue? workQueueData;
  WorkQueueStatus? workQueueStatus;
  bool? workQueueShownInitially;

  factory WorkQueueState.initial() {
    return WorkQueueState(workQueueStatus: WorkQueueStatus.initial, workQueueData: WorkQueue(),workQueueShownInitially: false);
  }

  WorkQueueState({this.workQueueData, this.workQueueStatus,this.workQueueShownInitially});

  WorkQueueState copyWith({WorkQueue? workQueueData, WorkQueueStatus? workQueueStatus}) {
    return WorkQueueState(workQueueData: workQueueData ?? this.workQueueData, workQueueStatus: workQueueStatus ?? this.workQueueStatus);
  }
}
