part of 'container_interaction_bloc.dart';

enum LotsDataStatus { initial, loading, success, failure }

enum AddContainerStatus { initial, loading, success, failure }

enum SummaryStatus { initial, loading, success, failure }

enum AreaName { Area, Refrigerated, Dry, Damaged, Empty, Unassigned }

final class ContainerInteractionState {
  ContainerInteractionState(
      {this.dataFromJS,
      this.webViewController,
      this.getLotsDataStatus,
      this.lotsData,
      this.webLoaded,
      this.getAddContainerStatus,
      this.getSummaryStatus,
      this.summary,
      this.sentDataToJS,
      this.areas,
      this.intercepting,
      this.modelLoaded,
      this.searchText,
      this.selectedAreaIndex,
      this.selectedDropdownArea,
      this.selectedDropdownLot,
      this.selectedAreaName,
      this.lotsToggled,
      this.searchTextController,
      this.lotOfSelectedShipment});

  InAppWebViewController? webViewController;
  LotsDataStatus? getLotsDataStatus;
  Map<String, dynamic>? lotsData;
  bool? webLoaded;
  AddContainerStatus? getAddContainerStatus;
  SummaryStatus? getSummaryStatus;
  Summary? summary;
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
  bool? lotsToggled;

  factory ContainerInteractionState.initial() {
    return ContainerInteractionState(
        getLotsDataStatus: LotsDataStatus.initial,
        webLoaded: false,
        getAddContainerStatus: AddContainerStatus.initial,
        getSummaryStatus: SummaryStatus.initial,
        dataFromJS: {"object": "null"},
        sentDataToJS: false,
        intercepting: false,
        selectedAreaName: AreaName.Area,
        selectedDropdownArea: 'Refrigerated',
        lotsToggled: true,
        modelLoaded: false,
        lotOfSelectedShipment: '');
  }

  ContainerInteractionState copyWith(
      {LotsDataStatus? getLotsDataStatus,
      Map<String, dynamic>? lotsData,
      bool? webLoaded,
      AddContainerStatus? getAddContainerStatus,
      SummaryStatus? getSummaryStatus,
      Summary? summary,
      Map<String, dynamic>? dataFromJS,
      String? selectedDropdownArea,
      String? selectedDropdownLot,
      bool? intercepting,
      Areas? areas,
      bool? lotsToggled,
      bool? sentDataToJS,
      AreaName? selectedAreaName,
      bool? modelLoaded,
      String? lotOfSelectedShipment}) {
    return ContainerInteractionState(
        webViewController: webViewController,
        getLotsDataStatus: getLotsDataStatus ?? this.getLotsDataStatus,
        getSummaryStatus: getSummaryStatus ?? this.getSummaryStatus,
        summary: summary ?? this.summary,
        lotsData: lotsData ?? this.lotsData,
        webLoaded: webLoaded ?? this.webLoaded,
        getAddContainerStatus: getAddContainerStatus ?? this.getAddContainerStatus,
        areas: areas ?? this.areas,
        dataFromJS: dataFromJS ?? this.dataFromJS,
        intercepting: intercepting ?? this.intercepting,
        lotsToggled: lotsToggled ?? this.lotsToggled,
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
