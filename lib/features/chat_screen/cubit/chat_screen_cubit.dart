import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit() : super(ChatScreenInitial());
}
