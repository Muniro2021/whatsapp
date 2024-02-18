// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/done_features/edit_profile_feature/customdropdownsearch.dart';
import 'package:uct_chat/features/done_features/edit_profile_feature/widgets/update_btn.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _image;
  List<SelectedListItem> dropdownlist = [];
  TextEditingController? catname;
  TextEditingController? catid;
  void getPositions() {
    List<Map<String, String>> data = [
      {'0': 'HR'},
      {'1': 'Flutter Developer'},
      {'2': 'Backend Developer'},
      {'3': 'Content Writer'},
      {'4': 'Designer'},
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: editProfileAppBar(context),

          //floating button to log out
          floatingActionButton: UpdateBtn(formKey: _formKey),

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
                                  imageUrl: widget.user.image,
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
                      initialValue: widget.user.name,
                      style: const TextStyle(fontFamily: 'Unna'),
                      onSaved: (val) => APIs.me.name = val ?? '',
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
                      initialValue: widget.user.about,
                      style: const TextStyle(fontFamily: 'Unna'),
                      onSaved: (val) => APIs.me.about = val ?? '',
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
                      position: widget.user.position,
                    ),

                    SizedBox(height: mq.height * .02),

                    // about input field
                    TextFormField(
                      initialValue: widget.user.salary,
                      enabled: widget.user.id == APIs.me.id ? false : true,
                      style: const TextStyle(fontFamily: 'Unna'),
                      onSaved: (val) => APIs.me.salary = val ?? '',
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
                      child: const Text('Change Admin Password'),
                      onTap: () async {
                        String adminPassword = await APIs.getAdminPassword();

                        _showDialog(adminPassword);
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

                          APIs.updateProfilePicture(File(_image!));
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

                        APIs.updateProfilePicture(File(_image!));
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

  Future<void> _showDialog(String password) async {
    GlobalKey<FormState> key = GlobalKey();
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Admin Password'),
          content: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value != password) {
                      return "Wrong Password";
                    } else if (value!.isEmpty) {
                      return "Enter Password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Current Password",
                  ),
                ),
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Password";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "New Password",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (key.currentState!.validate()) {
                  APIs.updateAdminPassword(controller.text).then(
                    (value) => Navigator.pop(context),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}