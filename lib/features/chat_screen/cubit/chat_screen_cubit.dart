// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uct_chat/models/message.dart';

part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit() : super(ChatScreenInitial());
  bool showEmoji = false;
  Future<bool> onWillPop() {
    if (showEmoji) {
      showEmoji = !showEmoji;
      emit(ChatShowEmoji());
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  changeShowEmoji() {
    showEmoji = !showEmoji;
    emit(ChatShowEmoji());
  }

  bool isUploading = false;
  changeIsUploading() {
    isUploading = !isUploading;
    emit(ChatIsUploading());
  }

  List<Message> list = [];
  bool timer = false;
    changeTimer() {
    timer = !timer;
    emit(ChatTimer());
  }
  bool isRecorderReady = false;
  final record = FlutterSoundRecorder();
  Future initialRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Mic Permission Not Granted';
    }
    await record.openRecorder();
    isRecorderReady = true;
    emit(ChatScreenInitial());
    record.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }
}
