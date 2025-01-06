import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DateTimeEvent extends Equatable {
  const DateTimeEvent();

  @override
  List<Object> get props => [];
}

class DateTimeChanged extends DateTimeEvent {
  final DateTime dateTime;

  const DateTimeChanged(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
class DateTimeState extends Equatable {
  final DateTime dateTime;

  const DateTimeState({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class DateTimeBloc extends Bloc<DateTimeEvent, DateTimeState> {
  DateTimeBloc() : super(DateTimeState(dateTime: DateTime.now())) {
    on<DateTimeChanged>((event, emit) {
      emit(DateTimeState(dateTime: event.dateTime));
    });
  }
}