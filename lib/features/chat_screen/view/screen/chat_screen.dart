import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_chat/features/call_screen/call_screen.dart';

import '../../../../api/apis.dart';
import '../../../../helper/my_date_util.dart';
import '../../../../main.dart';
import '../../../../models/chat_user.dart';
import '../../../../models/message.dart';
import '../widgets/message_card.dart';
import '../../../view_profile_screen/view_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // record audio
  final record = FlutterSoundRecorder();
  bool isRecorderReady = false;
  // Future recordFun() async {
  //   if (!isRecorderReady) return;
  //   await record.startRecorder(toFile: 'audio');
  // }

  // Future stopFun() async {
  //   if (!isRecorderReady) return;
  //   final path = await record.stopRecorder();
  //   final audioFile = File(path!);
  //   print("audio: $audioFile");
  // }

  Future initialRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Mic Permission Not Granted';
    }
    await record.openRecorder();
    isRecorderReady = true;
    // setState(() {

    // });
    record.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  void initState() {
    super.initState();
    initialRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    record.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    print(_textController.text);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            //app bar
            appBar: AppBar(
              backgroundColor: const Color(0xff008069),
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              toolbarHeight: 80,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CallInvitationPage(
                          chatUser: widget.user,
                          callID: '',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.white,
                  ),
                ),

                //search user button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),

                //more features button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            backgroundColor: const Color.fromARGB(255, 234, 248, 255),

            //body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                    chatUser: widget.user,
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hii! 👋',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),

                //chat input filed
                _chatInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewProfileScreen(user: widget.user),
          ),
        );
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              //back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),

              //user profile picture
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .03),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.height * .06,
                  height: mq.height * .06,
                  imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),

              //for adding some space
              const SizedBox(width: 10),

              //user name & last seen time
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //user name
                  Text(
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  //for adding some space
                  const SizedBox(height: 5),

                  //last seen time of user
                  SizedBox(
                    width: mq.width * .4,
                    child: Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive,
                                )
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive,
                            ),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
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
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) {
                          setState(() => _showEmoji = !_showEmoji);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //pick image from gallery button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Picking multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 100);

                      // uploading & sending image one by one
                      for (var i in images) {
                        log('Image Path: ${i.path}');
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                      size: 26,
                    ),
                  ),

                  //take image from camera button
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() => _isUploading = true);

                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.grey,
                      size: 26,
                    ),
                  ),

                  //adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),
          _textController.text != ""
              //send message button
              ? MaterialButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      if (_list.isEmpty) {
                        //on first message (add user to my_user collection of chat user)
                        APIs.sendFirstMessage(
                          widget.user,
                          _textController.text,
                          Type.text,
                        );
                      } else {
                        //simply send message
                        APIs.sendMessage(
                          widget.user,
                          _textController.text,
                          Type.text,
                        );
                      }
                      _textController.text = '';
                    }
                  },
                  minWidth: 0,
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 10,
                    left: _textController.text != "" ? 15 : 10,
                  ),
                  shape: const CircleBorder(),
                  color: const Color(0xff008069),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 28,
                  ),
                )
              : MaterialButton(
                  onPressed: () async {
                    if (record.isRecording) {
                      if (!isRecorderReady) return;
                      final path = await record.stopRecorder();
                      // final audioFile = File(path!);

                      await APIs.sendChatAudio(widget.user, File(path!));
                    } else {
                      if (!isRecorderReady) return;
                      await record.startRecorder(toFile: 'audio');
                    }
                    setState(() {});
                  },
                  minWidth: 0,
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 10,
                    left: _textController.text != "" ? 15 : 10,
                  ),
                  shape: const CircleBorder(),
                  color: const Color(0xff008069),
                  child: Icon(
                    record.isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
        ],
      ),
    );
  }
}
