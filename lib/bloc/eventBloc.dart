import 'package:eventify/models/Event.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:eventify/service/authService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class Event {}

class FetchEvents extends Event {}

class FetchSearchedEvents extends Event {
  final String searchedValue;
  FetchSearchedEvents(this.searchedValue);
}
class FetchMyEvents extends Event {
  final String? organizerId;
  FetchMyEvents(this.organizerId);
}
class FetchInterestedEvents extends Event {

  FetchInterestedEvents();
}
class FetchTrendingEvents extends Event {

  FetchTrendingEvents();
}
class FetchUpcomingEvents extends Event {

  FetchUpcomingEvents();
}

class FetchBoughtEvents extends Event {

  FetchBoughtEvents();

}

class FetchPastEvents extends Event {

  FetchPastEvents();
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
    on<FetchMyEvents>(_onFetchMyEvents);
    on<FetchTrendingEvents>(_onFetchTrendingEvents);
    on<FetchUpcomingEvents>(_onFetchUpcomingEvents);
    on<FetchInterestedEvents>(_onFetchInterestedEvents);
    on<FetchBoughtEvents>(_onFetchBoughtEvents);
    on<FetchPastEvents>(_onFetchPastEvents);





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
  Future<void> _onFetchInterestedEvents(
      FetchInterestedEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      AuthService authService = new AuthService();
      final events = await _firestoreService.getInterestEvents(authService.getCurrentUserId()!);
      print(events.length);
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching Events: $e"));
    }
  }
  Future<void> _onFetchBoughtEvents(
      FetchBoughtEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      AuthService authService = new AuthService();
      final events = await _firestoreService.getBoughtEvents(authService.getCurrentUserId()!);
      print(events.length);
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching Events: $e"));
    }
  }

  Future<void> _onFetchPastEvents(
      FetchPastEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      AuthService authService = new AuthService();
      final events = await _firestoreService.getPastEvents(authService.getCurrentUserId()!);

      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching Events: $e"));
    }
  }

  Future<void> _onFetchTrendingEvents(
      FetchTrendingEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      final events = await _firestoreService.getTrendingEvents();
      print(events.length);
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching Events: $e"));
    }
  }
  
  Future<void> _onFetchUpcomingEvents(
      FetchUpcomingEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      final events = await _firestoreService.getUpcomingEvents();
      print(events.length);
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError("Error fetching Events: $e"));
    }
  }
  
  Future<void> _onFetchMyEvents(
      FetchMyEvents event,
      Emitter<EventState> emit,
      ) async {
    emit(EventLoading());
    try {
      final events = await _firestoreService.getMyEvents(event.organizerId);
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