// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/done_features/edit_profile_feature/customdropdownsearch.dart';
import 'package:uct_chat/features/login_feature/login_screen.dart';
import 'package:uct_chat/helper/dialogs.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/main.dart';
import 'package:uct_chat/models/chat_user.dart';

//profile screen -- to show signed in user info
class EditProfile extends StatefulWidget {
  final ChatUser user;

  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String newName;
  late String newAbout;
  late String newPosition;
  late String newSalary;
  late String newImage;
  late String userId;
  final _formKey = GlobalKey<FormState>();
  String? _image;
  List<SelectedListItem> dropdownlist = [];
  TextEditingController? catname;
  TextEditingController? catid;
  void getPositions() {
    List<Map<String, String>> data = [
      {'0': 'Human Resources'},
      {'1': 'Flutter Developer'},
      {'2': 'Backend Developer'},
      {'3': 'Content Writer'},
      {'4': 'Graphic Designer'},
      {'5': 'Social Media Manager'},
      {'6': 'Data Entry'},
      {'7': 'Website Management'},
      {'8': 'Quality Assurance'},
      {'9': 'Wordpress Developer'},
      {'10': 'Chief Executive Officer'},
      {'11': 'Chief Operating Officer'},
    ];

    for (int i = 0; i < data.length; i++) {
      String key = i.toString();
      String value = data[i][key]!;
      dropdownlist.add(SelectedListItem(name: value, value: key));
    }
  }

  @override
  void initState() {
    catname = TextEditingController();
    catid = TextEditingController();
    getPositions();
    newName = widget.user.name;
    newAbout = widget.user.about;
    newPosition = widget.user.position;
    newSalary = widget.user.salary;
    newImage = widget.user.image;
    userId = widget.user.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Edited Profile: $userId");
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: editProfileAppBar(context),

          //floating button to log out
          floatingActionButton: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: primaryLightColor,
              minimumSize: Size(mq.width * .5, mq.height * .06),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                APIs.updateUserInfo(
                  newName: newName,
                  newAbout: newAbout,
                  newPosition: catname!.text,
                  newSalary: newSalary,
                  userId: userId,
                ).then((value) {
                  Dialogs.showSnackbar(
                    context,
                    'Profile Updated Successfully!',
                  );
                });
                if (widget.user.id == APIs.me.id) {
                  APIs.me.name = newName;
                  APIs.me.about = newAbout;
                  APIs.me.position = catname!.text;
                  APIs.me.salary = newSalary;
                }
              }
            },
            icon: const Icon(Icons.edit, size: 28),
            label: const Text(
              'UPDATE',
              style: TextStyle(fontSize: 16, fontFamily: 'Unna'),
            ),
          ),

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: mq.width, height: mq.height * .03),
                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?
                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            :
                            //image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: newImage,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(
                                      CupertinoIcons.person,
                                    ),
                                  ),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit,
                              color: primaryLightColor,
                            ),
                          ),
                        )
                      ],
                    ),

                    // for adding some space

                    SizedBox(height: mq.height * .03),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              widget.user.role == 0 ? "User" : "Admin",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Unna',
                                  color: primaryLightColor),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                    // user email label
                    SizedBox(height: mq.height * .03),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        color: seconderyDarkColor,
                        fontSize: 16,
                        fontFamily: 'Unna',
                      ),
                    ),
                    // for adding some space
                    SizedBox(height: mq.height * .04),

                    // name input field
                    TextFormField(
                      initialValue: newName,
                      style: const TextStyle(fontFamily: 'Unna'),
                      onSaved: (val) => newName = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person,
                              color: primaryLightColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Happy Singh',
                          label: const Text('Name'),
                          labelStyle:
                              const TextStyle(color: seconderyDarkColor)),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: newAbout,
                      style: const TextStyle(fontFamily: 'Unna'),
                      onSaved: (val) => newAbout = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.info_outline,
                              color: primaryLightColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. Feeling Happy',
                          label: const Text('About'),
                          labelStyle:
                              const TextStyle(color: seconderyDarkColor)),
                    ),

                    SizedBox(height: mq.height * .02),

                    CustomDropdownSearch(
                      dropdownSelectedId: catid!,
                      dropdownSelectedName: catname!,
                      listdata: dropdownlist,
                      title: 'Positions',
                      position: newPosition,
                    ),

                    SizedBox(height: mq.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: newSalary,
                      enabled: widget.user.role == 1 || APIs.me.role == 1
                          ? true
                          : false,
                      style: const TextStyle(fontFamily: 'Unna'),
                      onSaved: (val) => newSalary = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.money,
                            color: primaryLightColor,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: '0',
                          label: const Text('Salary'),
                          labelStyle:
                              const TextStyle(color: seconderyDarkColor)),
                    ),
                    // for adding some space
                    SizedBox(height: mq.height * .04),

                    // update profile button
                  ],
                ),
              ),
            ),
          )),
    );
  }

  AppBar editProfileAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Edit Profile',
        style: TextStyle(fontFamily: 'Unna'),
      ),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: widget.user.role == 0
          ? null
          : [
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                ), // Three vertical dots icon
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'password',
                      child: const Text(
                        'Change Admin Password',
                        style: TextStyle(fontFamily: 'Unna'),
                      ),
                      onTap: () async {
                        String adminPassword = await APIs.getAdminPassword();
                        _showDialog(adminPassword, 0);
                      },
                    ),
                    PopupMenuItem(
                      value: 'Zego App Id',
                      child: const Text(
                        'Change Zego App Id',
                        style: TextStyle(fontFamily: 'Unna'),
                      ),
                      onTap: () async {
                        String zegoCloudAppId = await APIs.getZegoCloudAppId();
                        _showDialog(zegoCloudAppId, 1);
                      },
                    ),
                    PopupMenuItem(
                      value: 'Zego App Sign',
                      child: const Text(
                        'Change Zego App Sign',
                        style: TextStyle(fontFamily: 'Unna'),
                      ),
                      onTap: () async {
                        String zegoCloudAppSign =
                            await APIs.getZegoCloudAppSign();
                        _showDialog(zegoCloudAppSign, 2);
                      },
                    ),
                  ];
                },
              ),
            ],
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!), userId);
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                        });

                        APIs.updateProfilePicture(File(_image!), userId);
                        // for hiding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset('images/camera.png'),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future<void> _showDialog(String newValue, int i) async {
    GlobalKey<FormState> key = GlobalKey();
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            i == 0
                ? 'Change Admin Password'
                : i == 1
                    ? 'Change Zego App Id'
                    : 'Change Zego App Sign',
            style: const TextStyle(fontFamily: 'Unna'),
          ),
          content: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value != newValue) {
                      return i == 0
                          ? 'Wrong Admin Password'
                          : i == 1
                              ? 'Wrong Zego App Id'
                              : 'Wrong Zego App Sign';
                    } else if (value!.isEmpty) {
                      return i == 0
                          ? 'Enter Admin Password'
                          : i == 1
                              ? 'Enter Zego App Id'
                              : 'Enter Zego App Sign';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: i == 0
                        ? 'Current Admin Password'
                        : i == 1
                            ? 'Current Zego App Id'
                            : 'Current Zego App Sign',
                    hintStyle: const TextStyle(fontFamily: 'Unna'),
                  ),
                ),
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return i == 0
                          ? 'Enter Admin Password'
                          : i == 1
                              ? 'Enter Zego App Id'
                              : 'Enter Zego App Sign';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: i == 0
                        ? 'New Admin Password'
                        : i == 1
                            ? 'New Zego App Id'
                            : 'New Zego App Sign',
                    hintStyle: const TextStyle(fontFamily: 'Unna'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: primaryLightColor, fontFamily: 'Unna'),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Submit',
                style: TextStyle(color: primaryLightColor, fontFamily: 'Unna'),
              ),
              onPressed: () {
                if (key.currentState!.validate()) {
                  i == 0
                      ? APIs.updateAdminPassword(controller.text).then((value) {
                          Dialogs.showSnackbar(
                              context, 'Admin Password Updated Successfully');
                          logoutFunc(context);
                        })
                      : i == 1
                          ? APIs.updateZegoCloudAppId(controller.text).then(
                              (value) => Dialogs.showSnackbar(context,
                                  'Zego Cloud App Id Updated Successfully'),
                            )
                          : APIs.updateZegoCloudAppSign(controller.text).then(
                              (value) => Dialogs.showSnackbar(context,
                                  'Zego Cloud App Sign Updated Successfully'),
                            );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logoutFunc(BuildContext context) async {
    Dialogs.showProgressBar(context);
    await APIs.updateActiveStatus(false);
    APIs.fMessaging.unsubscribeFromTopic('subscribtion');
    await APIs.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        APIs.auth = FirebaseAuth.instance;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      });
    });
  }
}
