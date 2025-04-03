import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_calls/src.dart';

part 'dry_event.dart';
part 'dry_state.dart';

class DryBloc extends Bloc<DryEvent, DryState> {
  final NetworkCalls _networkCalls;

  DryBloc({required NetworkCalls networkCalls})
      : _networkCalls = networkCalls,
        super(DryState.initial()) {}
}
