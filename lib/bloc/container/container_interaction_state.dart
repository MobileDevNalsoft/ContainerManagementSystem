part of 'container_interaction_bloc.dart';

enum LotsDataStatus { initial, loading, success, failure }

enum AddContainerStatus { initial, loading, success, failure }

enum SearchStatus { initial, loading, success, failure }

enum AreaName { Area, Refrigerated, Dry, Damaged, Empty }

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
      this.getSearchStatus,
      this.searchText,
      this.selectedAreaIndex,
      this.selectedAreaName,
      this.searchTextController,
      this.searchedContainer});

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
  SearchStatus? getSearchStatus;
  SearchedContainer? searchedContainer;
  String? searchText;
  int? selectedAreaIndex;
  AreaName? selectedAreaName;
  TextEditingController? searchTextController;

  factory ContainerInteractionState.initial() {
    return ContainerInteractionState(
        getLotsDataStatus: LotsDataStatus.initial,
        webLoaded: false,
        getAddContainerStatus: AddContainerStatus.initial,
        dataFromJS: {"object": "null"},
        sentDataToJS: false,
        intercepting: false,
        getSearchStatus: SearchStatus.initial,
        selectedAreaName: AreaName.Area,
        modelLoaded: false);
  }

  ContainerInteractionState copyWith(
      {LotsDataStatus? getLotsDataStatus,
      Map<String, dynamic>? lotsData,
      bool? webLoaded,
      AddContainerStatus? getAddContainerStatus,
      Map<String, dynamic>? dataFromJS,
      bool? intercepting,
      Areas? areas,
      bool? sentDataToJS,
      SearchStatus? getSearchStatus,
      AreaName? selectedAreaName,
      SearchedContainer? searchedContainer,
      bool? modelLoaded}) {
    return ContainerInteractionState(
        webViewController: webViewController,
        getLotsDataStatus: getLotsDataStatus ?? this.getLotsDataStatus,
        lotsData: lotsData ?? this.lotsData,
        webLoaded: webLoaded ?? this.webLoaded,
        getAddContainerStatus: getAddContainerStatus ?? this.getAddContainerStatus,
        areas: areas ?? this.areas,
        searchedContainer: searchedContainer ?? this.searchedContainer,
        getSearchStatus: getSearchStatus ?? this.getSearchStatus,
        dataFromJS: dataFromJS ?? this.dataFromJS,
        intercepting: intercepting ?? this.intercepting,
        searchText: searchText,
        searchTextController: searchTextController,
        selectedAreaIndex: selectedAreaIndex,
        sentDataToJS: sentDataToJS ?? this.sentDataToJS,
        selectedAreaName: selectedAreaName ?? this.selectedAreaName,
        modelLoaded: modelLoaded ?? this.modelLoaded);
  }
}
