import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/create_update_screen/widgets/customdropdownsearch.dart';
import 'package:uct_chat/features/create_update_screen/widgets/custome_text_form_field.dart';
import 'package:uct_chat/features/create_update_screen/widgets/radio_item.dart';
import 'package:uct_chat/features/create_update_screen/widgets/radio_item_widget.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/users_name.dart';

class CreateUpdateScreen extends StatefulWidget {
  const CreateUpdateScreen({super.key});
  static const route = '/splash_screen';

  @override
  State<CreateUpdateScreen> createState() => _CreateUpdateScreenState();
}

class _CreateUpdateScreenState extends State<CreateUpdateScreen> {
  GlobalKey<FormState> key = GlobalKey();
  late TextEditingController idMention;
  late TextEditingController mention;
  late TextEditingController pushTokenMention;
  late TextEditingController subject;
  late TextEditingController body;
  late TextEditingController color;
  List<UserModel> usersData = [];
  List<DocumentSnapshot> snapUsersData = [];
  List<SelectedListItem> dropdownlist = [];
  String? selectedColor;
  String? selectedMention = "everyone";
  List<RadioModel> sampleData = [];
  @override
  void initState() {
    super.initState();
    idMention = TextEditingController();
    mention = TextEditingController();
    pushTokenMention = TextEditingController();
    subject = TextEditingController();
    body = TextEditingController();
    color = TextEditingController();
    getUsers();
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.circleInfo,
        'Info',
        Colors.blue,
        "blue",
      ),
    );
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.solidBell,
        'Warning',
        Colors.orange,
        "orange",
      ),
    );
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.triangleExclamation,
        'Urgent',
        Colors.red,
        "red",
      ),
    );
    sampleData.add(
      RadioModel(
        false,
        FontAwesomeIcons.handHoldingHeart,
        'Good',
        Colors.green,
        "green",
      ),
    );
  }

  @override
  void dispose() {
    idMention.dispose();
    pushTokenMention.dispose();
    mention.dispose();
    subject.dispose();
    body.dispose();
    color.dispose();
    super.dispose();
  }

  Future<Null> getUsers() async {
    QuerySnapshot data = await APIs.firestore.collection("users").get();
    if (data.docs.isNotEmpty) {
      snapUsersData.addAll(data.docs);
      usersData = snapUsersData.map((e) => UserModel.fromFirestore(e)).toList();
      for (int i = 0; i < usersData.length; i++) {
        dropdownlist.add(
          SelectedListItem(
              name: usersData[i].name!,
              value: usersData[i].pushToken,
              id: usersData[i].id),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: key,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Text(
                    "Create New Update",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Unna',
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: 'everyone',
                        groupValue: selectedMention,
                        onChanged: (value) {
                          setState(() {
                            selectedMention = value;
                          });
                        },
                      ),
                      const Text(
                        'All Users',
                        style: TextStyle(
                          fontFamily: 'Unna',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: 'certain',
                        groupValue: selectedMention,
                        onChanged: (value) {
                          setState(() {
                            selectedMention = value;
                          });
                        },
                      ),
                      const Text(
                        'Certain User',
                        style: TextStyle(fontFamily: 'Unna', fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            selectedMention == "everyone"
                ? const SizedBox.shrink()
                : CustomDropdownSearch(
                    dropdownSelectedId: idMention,
                    dropdownSelectedName: mention,
                    listdata: dropdownlist,
                    title: 'Users',
                    dropdownSelectedPushToken: pushTokenMention,
                  ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: subject,
              label: "subject",
              hintText: "Add Subject Here",
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: body,
              label: "body",
              hintText: "Add Body Here",
              maxLines: 7,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sampleData.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    //highlightColor: Colors.red,
                    splashColor: whiteColor,
                    onTap: () {
                      setState(() {
                        for (var element in sampleData) {
                          element.isSelected = false;
                        }
                        sampleData[index].isSelected = true;
                      });
                      selectedColor = sampleData[index].value;
                    },
                    child: RadioItem(item: sampleData[index]),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                if (key.currentState!.validate()) {
                  await APIs.createUpdate(
                    selectedMention == "everyone" ? "everyone" : mention.text,
                    subject.text,
                    body.text,
                    selectedColor!,
                    selectedMention == "everyone" ? "everyone" : idMention.text,
                    pushTokenMention.text
                  );
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryLightColor,
                ),
                child: const Text(
                  "Add Update",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Unna'),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
