part of 'area_bloc.dart';

abstract class AreaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAreaData extends AreaEvent {
  final String area;

  GetAreaData({required this.area});

  @override
  // TODO: implement props
  List<Object> get props => [area];
}

class SearchContainer extends AreaEvent {
  final String containerNbr;

  SearchContainer({required this.containerNbr});

  @override
  List<Object> get props => [containerNbr];
}

class SelectedContainer extends AreaEvent {
  final int index;

  SelectedContainer({required this.index});

  @override
  List<Object> get props => [index];
}

class SelectedCustomer extends AreaEvent {
  final int index;

  SelectedCustomer({required this.index});

  @override
  List<Object> get props => [index];
}

class AreaTileHovered extends AreaEvent {
  final int? index;

  AreaTileHovered({required this.index});
}
