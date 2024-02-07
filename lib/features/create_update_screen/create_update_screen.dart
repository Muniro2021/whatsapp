import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/create_update_screen/widgets/customdropdownsearch.dart';
import 'package:uct_chat/features/home_screen/widgets/updates_tab.dart';
import 'package:uct_chat/models/users_name.dart';

class CreateUpdateScreen extends StatefulWidget {
  const CreateUpdateScreen({super.key});

  @override
  State<CreateUpdateScreen> createState() => _CreateUpdateScreenState();
}

class _CreateUpdateScreenState extends State<CreateUpdateScreen> {
  GlobalKey<FormState> key = GlobalKey();
  late TextEditingController mention;
  late TextEditingController subject;
  late TextEditingController body;
  late TextEditingController color;
  List<UserModel> usersData = [];
  List<DocumentSnapshot> snapUsersData = [];
  List<SelectedListItem> dropdownlist = [];
  String? selectedColor;
  @override
  void initState() {
    super.initState();
    mention = TextEditingController();
    subject = TextEditingController();
    body = TextEditingController();
    color = TextEditingController();
    getUsers();
  }

  @override
  void dispose() {
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
            value: usersData[i].name,
          ),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create New Update"),
        ),
        body: Form(
          key: key,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                CustomDropdownSearch(
                  dropdownSelectedId: mention,
                  dropdownSelectedName: mention,
                  listdata: dropdownlist,
                  title: 'Users',
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            Radio(
                              // title: const Text('Danger'),
                              value: 'red',
                              groupValue: selectedColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedColor = value;
                                });
                              },
                            ),
                            const Text('Danger'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          children: [
                            Radio(
                              // title: const Text('Warrning'),
                              value: 'orange',
                              groupValue: selectedColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedColor = value;
                                });
                              },
                            ),
                            const Text('Warrning'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            Radio(
                              // title: const Text('Info'),
                              value: 'blue',
                              groupValue: selectedColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedColor = value;
                                });
                              },
                            ),
                            const Text('Info'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            Radio(
                              // title: const Text('Success'),
                              value: 'green',
                              groupValue: selectedColor,
                              onChanged: (value) {
                                setState(() {
                                  selectedColor = value;
                                });
                              },
                            ),
                            const Text('Success'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    await APIs.createUpdate(
                      mention.text,
                      subject.text,
                      body.text,
                      selectedColor!,
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueAccent.withOpacity(0.4),
                    ),
                    child: const Text(
                      "Add Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.maxLines,
  });
  final TextEditingController controller;
  final String label;
  final String hintText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      maxLines: maxLines ?? 1,
      validator: (val) =>
          val != null && val.isNotEmpty ? null : 'Required Field',
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        label: Text(label),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
