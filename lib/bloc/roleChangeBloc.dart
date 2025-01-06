import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RoleSelectionEvent {}

class ToggleRole extends RoleSelectionEvent {
  final bool isOrganizer;
  ToggleRole(this.isOrganizer);
}

class RoleSelectionState {
  final bool isOrganizer;
  RoleSelectionState({required this.isOrganizer});
}

class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  RoleSelectionBloc() : super(RoleSelectionState(isOrganizer: false)) {
    on<ToggleRole>((event, emit) {
      emit(RoleSelectionState(isOrganizer: event.isOrganizer));
    });
  }
}