import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:we_chat/models/chat_user.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());
  // for storing all users
  List<ChatUser> list = [];
  // for storing searched items
  final List<ChatUser> searchList = [];
  // for storing search status
  bool isSearching = false;
  isSearchingChange() {
    isSearching = !isSearching;
    emit(ChatsInitial());
  }
}
