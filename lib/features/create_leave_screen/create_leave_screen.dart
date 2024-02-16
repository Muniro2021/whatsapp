import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Leave"),
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
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        typeList[index]["title"]!,
                        style: TextStyle(
                          color: selectedLeaveType == typeList[index]["type"]!
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('From'),
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
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('To'),
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
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter Leave Cause",
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
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Leave Apply',
                  style: TextStyle(color: Colors.white),
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
          title: const Text('Leave Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("From Date: ${selectedFromDate.toString().split(' ')[0]}"),
              Text("To Date: ${selectedToDate.toString().split(' ')[0]}"),
              Text(
                  "From Hour: ${selectedFromTime.format(context).toString()}"),
              Text("To Hour: ${selectedToTime.format(context).toString()}"),
              Text("Cause: ${controller.text}"),
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
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                APIs.leaveApply(
                  selectedFromDate.toString().split(' ')[0],
                  selectedToDate.toString().split(' ')[0],
                  selectedFromTime.format(context).toString(),
                  selectedToTime.format(context).toString(),
                  controller.text,
                  selectedLeaveType,
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
