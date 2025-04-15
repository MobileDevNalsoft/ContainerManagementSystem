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
      this.selectedDropdownLot,
      this.selectedAreaName,
      this.searchTextController,
      this.lotOfSelectedShipment});

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
  String? selectedDropdownLot;
  TextEditingController? searchTextController;
  String? lotOfSelectedShipment;

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
        modelLoaded: false,
        lotOfSelectedShipment: '');
  }

  ContainerInteractionState copyWith(
      {LotsDataStatus? getLotsDataStatus,
      Map<String, dynamic>? lotsData,
      bool? webLoaded,
      AddContainerStatus? getAddContainerStatus,
      Map<String, dynamic>? dataFromJS,
      String? selectedDropdownArea,
      String? selectedDropdownLot,
      bool? intercepting,
      Areas? areas,
      bool? sentDataToJS,
      AreaName? selectedAreaName,
      bool? modelLoaded,
      String? lotOfSelectedShipment}) {
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
        selectedDropdownLot: selectedDropdownLot ?? this.selectedDropdownLot,
        modelLoaded: modelLoaded ?? this.modelLoaded,
        lotOfSelectedShipment: lotOfSelectedShipment ?? this.lotOfSelectedShipment);
  }
}
