// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit() : super(LoginScreenInitial());
  bool isAnimate = false;
  changeIsAnimate() {
    isAnimate = !isAnimate;
    emit(LoginIsAnimated());
  }
}
