part of 'container_interaction_bloc.dart';

abstract class ContainerInteractionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLotsData extends ContainerInteractionEvent {}

class WebLoaded extends ContainerInteractionEvent {
  final bool loaded;
  WebLoaded({required this.loaded});

  @override
  List<Object> get props => [loaded];
}

class ModelLoaded extends ContainerInteractionEvent {
  final bool loaded;
  ModelLoaded({required this.loaded});

  @override
  List<Object> get props => [loaded];
}

class AddContainer extends ContainerInteractionEvent {
  final String area;
  final String containerNbr;
  final String lotNo;
  AddContainer({required this.area, required this.containerNbr, required this.lotNo});

  @override
  List<Object> get props => [area, containerNbr, lotNo];
}

class RelocateContainer extends ContainerInteractionEvent {
  final String area;
  final String containerNbr;
  final String lotNo;

  RelocateContainer({required this.containerNbr, required this.lotNo, required this.area});

  @override
  List<Object> get props => [containerNbr, lotNo, area];
}

class DeleteContainer extends ContainerInteractionEvent {
  final String area;
  final String containerNbr;
  DeleteContainer({required this.area, required this.containerNbr});

  @override
  List<Object> get props => [area, containerNbr];
}

class DataFromJS extends ContainerInteractionEvent {
  final Map<String, dynamic> dataFromJS;

  DataFromJS({required this.dataFromJS});

  @override
  List<Object> get props => [dataFromJS];
}

class Intercepting extends ContainerInteractionEvent {
  final bool intercepting;

  Intercepting({required this.intercepting});

  @override
  List<Object> get props => [intercepting];
}

class SelectedArea extends ContainerInteractionEvent {
  final AreaName selectedArea;

  SelectedArea({required this.selectedArea});

  @override
  List<Object> get props => [selectedArea];
}

class DropdownAreaChanged extends ContainerInteractionEvent {
  final String area;

  DropdownAreaChanged({required this.area});

  @override
  List<Object> get props => [area];
}
