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

class AddContainer extends ContainerInteractionEvent {
  final String area;
  final String containerNbr;
  final String lotNo;
  AddContainer({required this.area, required this.containerNbr, required this.lotNo});

  @override
  List<Object> get props => [area, containerNbr, lotNo];
}

class DeleteContainer extends ContainerInteractionEvent {
  final String area;
  final String containerNbr;
  DeleteContainer({required this.area, required this.containerNbr});

  @override
  List<Object> get props => [area, containerNbr];
}
