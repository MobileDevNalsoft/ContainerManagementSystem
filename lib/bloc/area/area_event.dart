part of 'area_bloc.dart';

abstract class AreaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAreaData extends AreaEvent {
  final String area;

  GetAreaData({required this.area});
  @override
  List<Object> get props => [area];
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
