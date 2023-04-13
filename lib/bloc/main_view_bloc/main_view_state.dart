part of 'main_view_bloc.dart';

abstract class MainViewState extends Equatable {
  const MainViewState();
}

class NormalMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}

class ErrorMainViewState extends MainViewState {
  @override
  List<Object?> get props => [];
}