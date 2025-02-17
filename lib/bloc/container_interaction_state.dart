part of 'container_interaction_bloc.dart';

enum LotsDataStatus { initial, loading, success, failure }

enum AddContainerStatus { initial, loading, success, failure }

final class ContainerInteractionState {
  ContainerInteractionState({this.webViewController, this.getLotsDataStatus, this.lotsData, this.webLoaded, this.getAddContainerStatus, this.sentDataToJS});

  InAppWebViewController? webViewController;
  LotsDataStatus? getLotsDataStatus;
  Map<String, dynamic>? lotsData;
  bool? webLoaded;
  AddContainerStatus? getAddContainerStatus;
  bool? sentDataToJS;

  factory ContainerInteractionState.initial() {
    return ContainerInteractionState(
        getLotsDataStatus: LotsDataStatus.initial, webLoaded: false, getAddContainerStatus: AddContainerStatus.initial, sentDataToJS: false);
  }

  ContainerInteractionState copyWith(
      {LotsDataStatus? getLotsDataStatus, Map<String, dynamic>? lotsData, bool? webLoaded, AddContainerStatus? getAddContainerStatus, bool? sentDataToJS}) {
    return ContainerInteractionState(
        webViewController: webViewController,
        getLotsDataStatus: getLotsDataStatus ?? this.getLotsDataStatus,
        lotsData: lotsData ?? this.lotsData,
        webLoaded: webLoaded ?? this.webLoaded,
        getAddContainerStatus: getAddContainerStatus ?? this.getAddContainerStatus,
        sentDataToJS: sentDataToJS ?? this.sentDataToJS);
  }
}
