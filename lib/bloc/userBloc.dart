import 'package:equatable/equatable.dart';
import 'package:eventify/models/User.dart';
import 'package:eventify/service/FirestoreService.dart';
import 'package:eventify/service/authService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserData extends UserEvent {


  FetchUserData();

  @override
  List<Object?> get props => [];
}
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User userData;

  UserLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

class UserError extends UserState {
  final String error;

  UserError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreService _firestoreService;

  UserBloc(this._firestoreService) : super(UserInitial()) {
    on<FetchUserData>(_onFetchUserData);
  }
  Future<void> _onFetchUserData(
      FetchUserData event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());
    try {
      AuthService authService = new AuthService();
      final userData = await _firestoreService.getUserData(authService.getCurrentUserId()!);
      emit(
          UserLoaded(userData!));
    } catch (e) {
      emit(UserError("Error fetching data: $e"));
    }
  }
}
