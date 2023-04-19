part of 'main_view_bloc.dart';

abstract class MainViewState{// extends Equatable {
  const MainViewState();
}

class NormalMainViewState extends MainViewState {
  final Activity? activity;
  final int? index;

  NormalMainViewState([this.activity, this.index]) {print('NEW NormalMainViewState');}

  //@override
  //List<Object?> get props => [activity, index];

  @override
  bool operator ==(Object other) {
    bool res = identical(this, other) ||
        other is NormalMainViewState &&
            activity == other.activity &&
            index == other.index;

    print('MainViewState == is $res');
/*    print('identical(this, other) is ${identical(this, other)}');
    print('other is NormalMainViewState is ${other is NormalMainViewState}');
    print('activity == other.activity is ${other is NormalMainViewState && activity == other.activity}');
    print('index == other.index is ${other is NormalMainViewState && index == other.index}');*/
    return res;
  }

  @override
  int get hashCode {
    return activity.hashCode ^
    index.hashCode;
  }
}

class ErrorMainViewState extends MainViewState {
  //@override
  //List<Object?> get props => [];
}