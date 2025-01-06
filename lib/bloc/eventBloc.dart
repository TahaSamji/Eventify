import 'package:eventify/models/Event.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Event {}

class FetchEvents extends Event {}

class FetchSearchedEvents extends Event {
  final String searchedValue;
  FetchSearchedEvents(this.searchedValue);
}
// Bloc State
abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Events> events;
  EventLoaded(this.events);
}

class EventError extends EventState {
  final String error;
  EventError(this.error);
}

// Update Bloc
class EventBloc extends Bloc<Event, EventState> {
  final FirestoreService _firestoreService;

  EventBloc(this._firestoreService) : super(EventInitial()) {
    on<FetchEvents>(_onFetchEvents);
    on<FetchSearchedEvents>(_onFetchSearchedEvents);

  }

  Future<void> _onFetchEvents(
      FetchEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      final events = await _firestoreService.getEvents();
      print(events.length);
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching Events: $e"));
    }
  }
  Future<void> _onFetchSearchedEvents(
      FetchSearchedEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      final events = await _firestoreService.searchEvents(event.searchedValue);
      print(events.length);
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching searched Events: $e"));
    }
  }
}