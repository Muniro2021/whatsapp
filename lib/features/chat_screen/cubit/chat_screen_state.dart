part of 'chat_screen_cubit.dart';

@immutable
abstract class ChatScreenState {}

class ChatScreenInitial extends ChatScreenState {}
class ChatShowEmoji extends ChatScreenState {}
class ChatIsUploading extends ChatScreenState {}
class ChatTimer extends ChatScreenState {}
