part of 'container_interaction_bloc.dart';

enum LotsDataStatus { initial, loading, success, failure }

enum AddContainerStatus { initial, loading, success, failure }

enum AreaName { Area, Refrigerated, Dry, Damaged, Empty, Unassigned }

final class ContainerInteractionState {
  ContainerInteractionState(
      {this.dataFromJS,
      this.webViewController,
      this.getLotsDataStatus,
      this.lotsData,
      this.webLoaded,
      this.getAddContainerStatus,
      this.sentDataToJS,
      this.areas,
      this.intercepting,
      this.modelLoaded,
      this.searchText,
      this.selectedAreaIndex,
      this.selectedDropdownArea,
      this.selectedAreaName,
      this.searchTextController});

  InAppWebViewController? webViewController;
  LotsDataStatus? getLotsDataStatus;
  Map<String, dynamic>? lotsData;
  bool? webLoaded;
  AddContainerStatus? getAddContainerStatus;
  bool? sentDataToJS;
  bool? modelLoaded;
  Map<String, dynamic>? dataFromJS;
  Areas? areas;
  bool? intercepting;
  String? searchText;
  int? selectedAreaIndex;
  AreaName? selectedAreaName;
  String? selectedDropdownArea;
  TextEditingController? searchTextController;

  factory ContainerInteractionState.initial() {
    return ContainerInteractionState(
        getLotsDataStatus: LotsDataStatus.initial,
        webLoaded: false,
        getAddContainerStatus: AddContainerStatus.initial,
        dataFromJS: {"object": "null"},
        sentDataToJS: false,
        intercepting: false,
        selectedAreaName: AreaName.Area,
        selectedDropdownArea: 'Refrigerated',
        modelLoaded: false);
  }

  ContainerInteractionState copyWith(
      {LotsDataStatus? getLotsDataStatus,
      Map<String, dynamic>? lotsData,
      bool? webLoaded,
      AddContainerStatus? getAddContainerStatus,
      Map<String, dynamic>? dataFromJS,
      String? selectedDropdownArea,
      bool? intercepting,
      Areas? areas,
      bool? sentDataToJS,
      AreaName? selectedAreaName,
      bool? modelLoaded}) {
    return ContainerInteractionState(
        webViewController: webViewController,
        getLotsDataStatus: getLotsDataStatus ?? this.getLotsDataStatus,
        lotsData: lotsData ?? this.lotsData,
        webLoaded: webLoaded ?? this.webLoaded,
        getAddContainerStatus: getAddContainerStatus ?? this.getAddContainerStatus,
        areas: areas ?? this.areas,
        dataFromJS: dataFromJS ?? this.dataFromJS,
        intercepting: intercepting ?? this.intercepting,
        searchText: searchText,
        searchTextController: searchTextController,
        selectedAreaIndex: selectedAreaIndex,
        sentDataToJS: sentDataToJS ?? this.sentDataToJS,
        selectedAreaName: selectedAreaName ?? this.selectedAreaName,
        selectedDropdownArea: selectedDropdownArea ?? this.selectedDropdownArea,
        modelLoaded: modelLoaded ?? this.modelLoaded);
  }
}
