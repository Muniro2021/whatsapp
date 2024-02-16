import 'dart:developer';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:uct_chat/features/chat_screen/widgets/pdf_viewer.dart';
import 'package:uct_chat/helper/image_viewer.dart';
import 'package:uct_chat/models/chat_user.dart';
import 'package:video_player/video_player.dart';

import '../../../api/apis.dart';
import '../../../helper/dialogs.dart';
import '../../../helper/my_date_util.dart';
import '../../../main.dart';
import '../../../models/message.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.chatUser,
  });

  final Message message;
  final ChatUser chatUser;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late VideoPlayerController videoController;
  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    videoController.dispose();
  }

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.message.msg),
    );
    videoController.addListener(() {
      setState(() {});
    });
    // _controller.setLooping(true);
    videoController.initialize().then((_) => setState(() {}));
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        ChatBubble(
          clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
          backGroundColor: const Color(0xffE7E7ED),
          margin: const EdgeInsets.only(top: 20),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : widget.message.type == Type.image
                    //show image
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              imagePath: widget.message.msg,
                            ),
                          ));
                        },
                        child: InteractiveViewer(
                          maxScale: 5,
                          minScale: 0.01,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            ),
                          ),
                        ),
                      )
                    : widget.message.type == Type.audio
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (isPlaying) {
                                        await audioPlayer.pause();
                                      } else {
                                        await audioPlayer.play(
                                          UrlSource(widget.message.msg),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                    iconSize: 40,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Slider(
                                          min: 0,
                                          max: duration.inSeconds.toDouble(),
                                          value: position.inSeconds.toDouble(),
                                          onChanged: (value) async {
                                            final position = Duration(
                                              seconds: value.toInt(),
                                            );
                                            await audioPlayer.seek(position);
                                            await audioPlayer.resume();
                                          },
                                          activeColor: Colors.black54,
                                          inactiveColor:
                                              Colors.grey.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatTime(position),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(
                                        width: mq.width * .1,
                                      ),
                                      Text(
                                        formatTime(duration - position),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: widget.chatUser.image,
                                            placeholder: (context, url) =>
                                                const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.image,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Icon(
                                          Icons.mic,
                                          color: Colors.grey.withOpacity(0.6),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )
                        : widget.message.type == Type.doc
                            ? SizedBox(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PDFScreen(
                                          pathPDF: (widget.message.msg)
                                              .split('?')[0],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Document/Pdf File",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                            : AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    VideoPlayer(videoController),
                                    _ControlsOverlay(
                                      controller: videoController,
                                    ),
                                    VideoProgressIndicator(
                                      videoController,
                                      allowScrubbing: true,
                                    ),
                                  ],
                                ),
                              ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * .04),

            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        //message content
        ChatBubble(
          clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 20),
          backGroundColor: Colors.orange.withOpacity(0.8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  )
                : widget.message.type == Type.image
                    //show image
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              imagePath: widget.message.msg,
                            ),
                          ));
                        },
                        child: InteractiveViewer(
                          maxScale: 5,
                          minScale: 0.01,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            ),
                          ),
                        ),
                      )
                    : widget.message.type == Type.audio
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: APIs.me.image,
                                            placeholder: (context, url) =>
                                                const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.image,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Icon(
                                          Icons.mic,
                                          color: Colors.grey.withOpacity(0.6),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (isPlaying) {
                                          await audioPlayer.pause();
                                        } else {
                                          await audioPlayer.play(
                                            UrlSource(widget.message.msg),
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                      iconSize: 40,
                                      color: Colors.white),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: Slider(
                                          min: 0,
                                          max: duration.inSeconds.toDouble(),
                                          value: position.inSeconds.toDouble(),
                                          onChanged: (value) async {
                                            final position = Duration(
                                              seconds: value.toInt(),
                                            );
                                            await audioPlayer.seek(position);
                                            await audioPlayer.resume();
                                          },
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              Colors.grey.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatTime(position),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: mq.width * .1,
                                      ),
                                      Text(
                                        formatTime(duration - position),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        : widget.message.type == Type.doc
                            ? SizedBox(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFScreen(
                                          pathPDF: (widget.message.msg)
                                              .split('?')[0],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Document/Pdf File',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                            : AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    VideoPlayer(videoController),
                                    _ControlsOverlay(
                                        controller: videoController),
                                    VideoProgressIndicator(
                                      videoController,
                                      allowScrubbing: true,
                                    ),
                                  ],
                                ),
                              ),
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  : widget.message.type == Type.image
                      //save option
                      ? _OptionItem(
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.blue,
                            size: 26,
                          ),
                          name: 'Save Image',
                          onTap: () async {
                            try {
                              log('Image Url: ${widget.message.msg}');
                              await GallerySaver.saveImage(
                                widget.message.msg,
                                albumName: 'Images Chat',
                              ).then((success) {
                                //for hiding bottom sheet
                                Navigator.pop(context);
                                if (success != null && success) {
                                  Dialogs.showSnackbar(
                                      context, 'Image Successfully Saved!');
                                }
                              });
                            } catch (e) {
                              log('ErrorWhileSavingImg: $e');
                            }
                          })
                      : widget.message.type == Type.audio
                          ? _OptionItem(
                              icon: const Icon(
                                Icons.download_rounded,
                                color: Colors.blue,
                                size: 26,
                              ),
                              name: 'Download Audio',
                              onTap: () async {
                                try {
                                  log('Audio Url: ${widget.message.msg}');
                                  await GallerySaver.downloadFile(
                                    widget.message.msg,
                                    // albumName: 'Audios Chat',
                                  ).then((success) {
                                    //for hiding bottom sheet
                                    Navigator.pop(context);
                                    Dialogs.showSnackbar(context,
                                        'Audio Successfully Downloaded!');
                                  });
                                } catch (e) {
                                  log('ErrorWhileSavingAudio: $e');
                                }
                              })
                          : widget.message.type == Type.doc
                              ? _OptionItem(
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    color: Colors.blue,
                                    size: 26,
                                  ),
                                  name: 'Download Document',
                                  onTap: () async {
                                    try {
                                      log('Document Url: ${widget.message.msg}');
                                      await GallerySaver.downloadFile(
                                        widget.message.msg,
                                        // albumName: 'Documents Chat',
                                      ).then((success) {
                                        //for hiding bottom sheet
                                        Navigator.pop(context);
                                        Dialogs.showSnackbar(
                                          context,
                                          'Doc Successfully Downloaded!',
                                        );
                                      });
                                    } catch (e) {
                                      log('ErrorWhileSavingDoc: $e');
                                    }
                                  })
                              : _OptionItem(
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    color: Colors.blue,
                                    size: 26,
                                  ),
                                  name: 'Download Video',
                                  onTap: () async {
                                    try {
                                      log('Video Url: ${widget.message.msg}');
                                      await GallerySaver.saveVideo(
                                        widget.message.msg,
                                        albumName: 'Videos Chat',
                                      ).then((success) {
                                        //for hiding bottom sheet
                                        Navigator.pop(context);
                                        if (success != null) {
                                          Dialogs.showSnackbar(
                                            context,
                                            'Video Successfully Downloaded!',
                                          );
                                        }
                                      });
                                    } catch (e) {
                                      log('ErrorWhileSavingVideo: $e');
                                    }
                                  }),
              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        //title
        title: const Row(
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 28,
            ),
            Text(' Update Message')
          ],
        ),

        //content
        content: TextFormField(
          initialValue: updatedMsg,
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),

        //actions
        actions: [
          //cancel button
          MaterialButton(
              onPressed: () {
                //hide alert dialog
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              )),

          //update button
          MaterialButton(
            onPressed: () {
              //hide alert dialog
              Navigator.pop(context);
              APIs.updateMessage(widget.message, updatedMsg);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            )
          ]),
        ));
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = true,
    bool isDiscrete = true,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Text('${controller.value.captionOffset.inMilliseconds}ms'),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${controller.value.playbackSpeed}x')),
            ),
          ),
        ),
      ],
    );
  }
}
