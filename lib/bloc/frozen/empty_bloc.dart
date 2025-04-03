import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_calls/src.dart';

part 'empty_event.dart';
part 'empty_state.dart';

class EmptyBloc extends Bloc<EmptyEvent, EmptyState> {
  final NetworkCalls _networkCalls;

  EmptyBloc({required NetworkCalls networkCalls})
      : _networkCalls = networkCalls,
        super(EmptyState.initial()) {}
}
