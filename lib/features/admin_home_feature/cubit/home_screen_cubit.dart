// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uct_chat/models/chat_user.dart';

part 'home_screen_state.dart';

class AdminHomeScreenCubit extends Cubit<AdminHomeScreenState> {
  AdminHomeScreenCubit() : super(HomeScreenInitial());
  // for storing all users
  List<ChatUser> list = [];
  // for storing searched items
  final List<ChatUser> searchList = [];
  // for storing search status
  bool isSearching = false;
  changeIsSearching() {
    isSearching = !isSearching;
    emit(HomeIsSearching());
  }

  onChanged(String newVal) {
    searchList.clear();
    for (var i in list) {
      if (i.name.toLowerCase().contains(
                newVal.toLowerCase(),
              ) ||
          i.email.toLowerCase().contains(
                newVal.toLowerCase(),
              )) {
        searchList.add(i);
        searchList;
      }
    }
    emit(HomeScreenInitial());
  }
}
