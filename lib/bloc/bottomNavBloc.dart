import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BottomNavEvent {}

class ChangePage extends BottomNavEvent {
  final int index;

  ChangePage(this.index);
}

abstract class BottomNavState {}

class PageChanged extends BottomNavState {
  final int currentIndex;

  PageChanged(this.currentIndex);
}

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(PageChanged(0)) {
    on<ChangePage>((event, emit) {
      emit(PageChanged(event.index));
    });
  }
}