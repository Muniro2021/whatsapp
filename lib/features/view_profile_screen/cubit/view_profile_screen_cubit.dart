// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'view_profile_screen_state.dart';

class ViewProfileScreenCubit extends Cubit<ViewProfileScreenState> {
  ViewProfileScreenCubit() : super(ViewProfileScreenInitial());
}
