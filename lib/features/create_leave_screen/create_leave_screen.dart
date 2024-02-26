import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/features/create_update_screen/widgets/customdropdownsearch.dart';
import 'package:uct_chat/helper/utils/constant.dart';
import 'package:uct_chat/models/users_name.dart';

class CreateLeaveScreen extends StatefulWidget {
  const CreateLeaveScreen({super.key});

  @override
  State<CreateLeaveScreen> createState() => _CreateLeaveScreenState();
}

class _CreateLeaveScreenState extends State<CreateLeaveScreen> {
  late List<Map<String, String>> typeList;
  late String selectedLeaveType;
  late DateTime currentDate;
  late DateTime firstDayOfMonth;
  late DateTime lastDayOfYear;
  late DateTime selectedFromDate;
  late DateTime selectedToDate;
  late TimeOfDay selectedFromTime;
  late TimeOfDay selectedToTime;
  late TextEditingController controller;
  @override
  void initState() {
    initValues();
    adminPushToken = TextEditingController();
    adminName = TextEditingController();
    adminId = TextEditingController();
    getUsers();
    super.initState();
  }

  List<UserModel> usersData = [];
  List<DocumentSnapshot> snapUsersData = [];
  List<SelectedListItem> dropdownlist = [];
  late TextEditingController adminPushToken;
  late TextEditingController adminName;
  late TextEditingController adminId;
  Future<Null> getUsers() async {
    QuerySnapshot data = await APIs.firestore
        .collection("users")
        .where('role', isEqualTo: 1)
        .get();
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
  void dispose() {
    adminPushToken.dispose();
    adminName.dispose();
    adminId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Leave",
          style: TextStyle(fontFamily: 'Unna'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: typeList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedLeaveType = typeList[index]["type"]!;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: selectedLeaveType == typeList[index]["type"]!
                            ? primaryLightColor
                            : primaryLightColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        typeList[index]["title"]!,
                        style: TextStyle(
                            color: selectedLeaveType == typeList[index]["type"]!
                                ? Colors.white
                                : Colors.black,
                            fontFamily: 'Unna'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropdownSearch(
              dropdownSelectedPushToken: adminPushToken,
              dropdownSelectedName: adminName,
              dropdownSelectedId: adminId,
              listdata: dropdownlist,
              title: 'Admins',
            ),
            const SizedBox(
              height: 20,
            ),
            selectedLeaveType == "4"
                ? const SizedBox.shrink()
                : selectedLeaveType == "0"
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.7,
                            child: CalendarDatePicker(
                              initialDate: currentDate,
                              firstDate: firstDayOfMonth,
                              lastDate: lastDayOfYear,
                              onDateChanged: (value) {
                                setState(() {
                                  selectedFromDate = value;
                                  selectedToDate = value;
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    selectedFromTime = (await showTimePicker(
                                      context: context,
                                      initialTime: selectedFromTime,
                                    ))!;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: primaryLightColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'From',
                                      style: TextStyle(fontFamily: 'Unna'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    selectedToTime = (await showTimePicker(
                                      context: context,
                                      initialTime: selectedToTime,
                                    ))!;
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: primaryLightColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'To',
                                      style: TextStyle(fontFamily: 'Unna'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const Text("From Date"),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                            child: CalendarDatePicker(
                              initialDate: currentDate,
                              firstDate: firstDayOfMonth,
                              lastDate: lastDayOfYear,
                              onDateChanged: (value) {
                                setState(() {
                                  selectedFromDate = DateTime(
                                    value.year,
                                    value.month,
                                    value.day,
                                  );
                                });
                              },
                            ),
                          ),
                          const Text("To Date"),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                            child: CalendarDatePicker(
                              initialDate: currentDate,
                              firstDate: firstDayOfMonth,
                              lastDate: lastDayOfYear,
                              onDateChanged: (value) {
                                setState(() {
                                  selectedToDate = DateTime(
                                    value.year,
                                    value.month,
                                    value.day,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter Leave Cause",
                  hintStyle: TextStyle(fontFamily: 'Unna'),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _showDialog();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Leave Apply',
                  style: TextStyle(color: Colors.white, fontFamily: 'Unna'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Set to true if you want to allow dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Leave Details',
            style: TextStyle(fontFamily: 'Unna'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "From Date: ${selectedFromDate.toString().split(' ')[0]}",
                style: const TextStyle(fontFamily: 'Unna'),
              ),
              Text(
                "To Date: ${selectedToDate.toString().split(' ')[0]}",
                style: const TextStyle(fontFamily: 'Unna'),
              ),
              Text(
                "From Hour: ${selectedFromTime.format(context).toString()}",
                style: const TextStyle(fontFamily: 'Unna'),
              ),
              Text(
                "To Hour: ${selectedToTime.format(context).toString()}",
                style: const TextStyle(fontFamily: 'Unna'),
              ),
              Text(
                "Cause: ${controller.text}",
                style: const TextStyle(fontFamily: 'Unna'),
              ),
              Text(
                (() {
                  switch (selectedLeaveType) {
                    case "0":
                      return "Hourly";
                    case "1":
                      return "Sick";
                    case "2":
                      return "Annual";
                    case "3":
                      return "Unpaid";
                    default:
                      return "";
                  }
                })(),
                style: const TextStyle(fontFamily: 'Unna'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(fontFamily: 'Unna', color: primaryLightColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'Submit',
                style: TextStyle(fontFamily: 'Unna', color: primaryLightColor),
              ),
              onPressed: () {
                APIs.leaveApply(
                  selectedFromDate.toString().split(' ')[0],
                  selectedToDate.toString().split(' ')[0],
                  selectedFromTime.format(context).toString(),
                  selectedToTime.format(context).toString(),
                  controller.text,
                  selectedLeaveType,
                  adminPushToken.text,
                  adminId.text
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void initValues() {
    typeList = [
      {"type": "0", "title": "Hourly"},
      {"type": "1", "title": "Sick"},
      {"type": "2", "title": "Annual"},
      {"type": "3", "title": "Unpaid"},
    ];
    selectedLeaveType = typeList[0]["type"]!;
    currentDate = DateTime.now();
    firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    lastDayOfYear = DateTime(currentDate.year + 1, 0, 0);
    selectedFromDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    selectedToDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    selectedFromTime = const TimeOfDay(hour: 8, minute: 30);
    selectedToTime = const TimeOfDay(hour: 16, minute: 30);
    controller = TextEditingController();
  }
}
