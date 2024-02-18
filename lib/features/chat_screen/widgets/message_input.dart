import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/chat_screen/cubit/chat_screen_cubit.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';
import 'package:uct_chat/models/message.dart';

class MessageInput extends StatelessWidget {
  const MessageInput(
      {super.key, required this.chatScreenCubit, required this.user});
  final ChatScreenCubit chatScreenCubit;
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: mq.height * .01,
            horizontal: mq.width * .025,
          ),
          child: Row(
            children: [
              //input field & buttons
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      //emoji button
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          chatScreenCubit.changeShowEmoji();
                        },
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: primaryLightColor,
                          size: 25,
                        ),
                      ),

                      Expanded(
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onTap: () {
                            if (chatScreenCubit.showEmoji) {
                              chatScreenCubit.changeShowEmoji();
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Type Something...',
                            hintStyle: TextStyle(
                              color: primaryLightColor,
                              fontFamily: 'Unna',
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          chooseFileToSend(context);
                        },
                        icon: const Icon(
                          Icons.attach_file,
                          color: primaryLightColor,
                        ),
                      ),
                      //pick image from gallery button
                      IconButton(
                        onPressed: () async {
                          if (chatScreenCubit.record.isRecording == true) {
                            chatScreenCubit.changeTimer();

                            if (!chatScreenCubit.isRecorderReady) return;
                            final path =
                                await chatScreenCubit.record.stopRecorder();
                            await APIs.sendChatAudio(
                              user,
                              File(path!),
                            );
                          } else {
                            chatScreenCubit.changeTimer();
                            if (!chatScreenCubit.isRecorderReady) return;
                            await chatScreenCubit.record.startRecorder(
                              toFile: 'audio',
                            );
                          }
                        },
                        icon: Icon(
                          chatScreenCubit.timer ? Icons.stop : Icons.mic,
                          color: primaryLightColor,
                        ),
                      ),
                      //adding some space
                      SizedBox(width: mq.width * .02),
                    ],
                  ),
                ),
              ),

              //send message button
              chatScreenCubit.timer
                  ? StreamBuilder<RecordingDisposition>(
                      stream: chatScreenCubit.record.onProgress,
                      builder: (context, snapshot) {
                        final duration = snapshot.hasData
                            ? snapshot.data!.duration
                            : Duration.zero;
                        String twoDigits(int n) => n.toString().padLeft(0);
                        final twoDigitMinutes = twoDigits(
                          duration.inMinutes.remainder(60),
                        );
                        final twoDigitSeconds = twoDigits(
                          duration.inSeconds.remainder(60),
                        );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "$twoDigitMinutes:$twoDigitSeconds s",
                          ),
                        );
                      })
                  : MaterialButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          if (chatScreenCubit.list.isEmpty) {
                            //on first message (add user to my_user collection of chat user)
                            APIs.sendFirstMessage(
                              user,
                              textController.text,
                              Type.text,
                            );
                          } else {
                            //simply send message
                            APIs.sendMessage(
                              user,
                              textController.text,
                              Type.text,
                            );
                          }
                        }
                        textController.text = '';
                      },
                      minWidth: 0,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 5, left: 10),
                      shape: const CircleBorder(),
                      color: primaryLightColor,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
            ],
          ),
        ),
        if (chatScreenCubit.showEmoji)
          SizedBox(
            height: mq.height * .35,
            child: EmojiPicker(
              textEditingController: textController,
              config: Config(
                bgColor: const Color.fromARGB(255, 234, 248, 255),
                columns: 8,
                emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              ),
            ),
          )
      ],
    );
  }

  Future<dynamic> chooseFileToSend(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Upload File',
          style: TextStyle(fontFamily: 'Unna'),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Picking multiple images
                final List<XFile> images = await picker.pickMultiImage(
                  imageQuality: 70,
                );
                Navigator.pop(context);
                // uploading & sending image one by one
                for (var i in images) {
                  log('Image Path: ${i.path}');
                  chatScreenCubit.changeIsUploading();
                  await APIs.sendChatImage(
                    user,
                    File(i.path),
                  );
                  chatScreenCubit.changeIsUploading();
                }
              },
              icon: const Icon(
                Icons.image,
                color: primaryLightColor,
                size: 26,
              ),
            ),

            //take image from camera button
            IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 70,
                );
                Navigator.pop(context);
                if (image != null) {
                  log('Image Path: ${image.path}');
                  chatScreenCubit.changeIsUploading();
                  await APIs.sendChatImage(
                    user,
                    File(image.path),
                  );
                  chatScreenCubit.changeIsUploading();
                }
              },
              icon: const Icon(
                Icons.camera_alt_rounded,
                color: primaryLightColor,
                size: 26,
              ),
            ),

            IconButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                  allowMultiple: true,
                );
                Navigator.pop(context);
                if (result != null) {
                  var file = result.files.single.path!;
                  chatScreenCubit.changeIsUploading();
                  await APIs.sendChatAudio(
                    user,
                    File(file),
                  );
                  chatScreenCubit.changeIsUploading();
                }
              },
              icon: const Icon(
                Icons.audiotrack,
                color: primaryLightColor,
                size: 26,
              ),
            ),
            IconButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                  allowMultiple: true,
                );
                Navigator.pop(context);
                if (result != null) {
                  var file = result.files.single.path!;
                  chatScreenCubit.changeIsUploading();
                  await APIs.sendChatVideo(
                    user,
                    File(file),
                  );
                  chatScreenCubit.changeIsUploading();
                }
              },
              icon: const Icon(
                Icons.ondemand_video,
                color: primaryLightColor,
                size: 26,
              ),
            ),
            IconButton(
              onPressed: () async {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.info,
                  animType: AnimType.rightSlide,
                  title: 'Comming Soon..',
                  desc: 'Under Maintain',
                  btnCancelOnPress: () {
                    // Navigator.pop(context);
                  },
                ).show();
                // FilePickerResult? result = await FilePicker.platform.pickFiles(
                //   type: FileType.custom,
                //   allowMultiple: true,
                //   allowedExtensions: ['pdf', 'doc', 'pptx'],
                // );
                // Navigator.pop(context);
                // if (result != null) {
                //   var file = result.files.single.path!;
                //   print("file: ----- $file");
                //   chatScreenCubit.changeIsUploading();
                //   print("file: $file");
                //   await APIs.sendChatDoc(
                //     user,
                //     File(file),
                //   );
                //   chatScreenCubit.changeIsUploading();
                // }
              },
              icon: const Icon(
                Icons.file_copy,
                color: primaryLightColor,
                size: 26,
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: primaryLightColor, fontSize: 16, fontFamily: 'Unna'),
            ),
          ),

          //update button
        ],
      ),
    );
  }
}
