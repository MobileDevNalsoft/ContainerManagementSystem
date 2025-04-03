import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_calls/src.dart';

part 'damaged_event.dart';
part 'damaged_state.dart';

class DamagedBloc extends Bloc<DamagedEvent, DamagedState> {
  final NetworkCalls _networkCalls;

  DamagedBloc({required NetworkCalls networkCalls})
      : _networkCalls = networkCalls,
        super(DamagedState.initial()) {}
}
