import 'package:equatable/equatable.dart';
import 'package:eventify/models/FeedBack.dart';
import 'package:eventify/models/User.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:eventify/service/authService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFeedBack extends FeedbackEvent {
  String eventId;

  FetchFeedBack(this.eventId);

  @override
  List<Object?> get props => [];
}
abstract class FeedbackState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackLoaded extends FeedbackState {
  final List<Feedback> feedbacks;

  FeedbackLoaded(this.feedbacks);

  @override
  List<Object?> get props => [feedbacks];
}

class FeedbackError extends FeedbackState {
  final String error;

  FeedbackError(this.error);

  @override
  List<Object?> get props => [error];
}

class Feedbackbloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FirestoreService _firestoreService;

  Feedbackbloc(this._firestoreService) : super(FeedbackInitial()) {
    on<FetchFeedBack>(_onFetchUserData);
  }
  Future<void> _onFetchUserData(
      FetchFeedBack event,
      Emitter<FeedbackState> emit,
      ) async {
    emit(FeedbackLoading());
    try {
      final feedbacks = await _firestoreService.getFeedbacksForEvent(event.eventId);
      emit(
          FeedbackLoaded(feedbacks));
    } catch (e) {
      emit(FeedbackError("Error fetching data: $e"));
    }
  }
}
