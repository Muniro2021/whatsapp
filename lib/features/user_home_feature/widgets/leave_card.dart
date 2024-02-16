import 'package:flutter/material.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/models/leave_apply.dart';

class LeaveCard extends StatefulWidget {
  const LeaveCard({
    super.key,
    required this.leave,
  });

  final LeaveApply leave;

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  bool isContentVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: SizedBox(
          height: isContentVisible ? null : 70,

          // padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: CardName(),
                onTap: () {
                  setState(() {
                    isContentVisible = !isContentVisible;
                  });
                },
              ),
              if (isContentVisible) ...[
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      CardDate(),
                      CardTime(),
                      CardType(),
                      CardStatus(),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Container CardName() {
    return Container(
      width: double.infinity,
      height: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        color: (() {
          switch (widget.leave.status) {
            case "0":
              return Colors.blue.withOpacity(0.3);
            case "1":
              return Colors.green.withOpacity(0.3);
            default:
              return Colors.red.withOpacity(0.3);
          }
        })(),
      ),
      child: Text(
        "@${widget.leave.name}",
        style: const TextStyle(height: 1, fontFamily: 'Unna'),
      ),
    );
  }

  Column CardStatus() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (() {
                    switch (widget.leave.status) {
                      case "0":
                        return Colors.blue;
                      case "1":
                        return Colors.green;
                      default:
                        return Colors.red;
                    }
                  })(),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Text(
                  (() {
                    switch (widget.leave.status) {
                      case "0":
                        return "Pending";
                      case "1":
                        return "Accepted";
                      default:
                        return "Rejected";
                    }
                  })(),
                  style: const TextStyle(
                    height: 1,
                    fontFamily: 'Unna',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            widget.leave.status == "0" && APIs.me.id == widget.leave.id
                ? Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          APIs.deleteLeave(widget.leave.time);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                : const SizedBox.shrink()
          ],
        ),
      ],
    );
  }

  Column CardStatusAdminButton() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  APIs.updateLeaveStatus(
                    "1",
                    widget.leave.time,
                    widget.leave.id,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Unna',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  APIs.updateLeaveStatus(
                      "2", widget.leave.time, widget.leave.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Reject",
                    style: TextStyle(
                      height: 1,
                      fontFamily: 'Unna',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Row CardCause() {
    return Row(
      children: [
        Text(
          widget.leave.cause,
          style: const TextStyle(height: 2, fontFamily: 'Unna'),
        ),
      ],
    );
  }

  Row CardType() {
    return Row(
      children: [
        Text(
          (() {
            switch (widget.leave.type) {
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
          style: const TextStyle(
            height: 2,
            fontFamily: 'Unna',
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  Row CardTime() {
    return Row(
      children: [
        const Text(
          "Time: ",
          style: TextStyle(height: 2, fontFamily: 'Unna'),
        ),
        Text(
          "from ${widget.leave.fromTime}",
          style: const TextStyle(height: 2, fontFamily: 'Unna'),
        ),
        Text(
          " to ${widget.leave.toTime}",
          style: const TextStyle(height: 2, fontFamily: 'Unna'),
        ),
      ],
    );
  }

  Row CardDate() {
    return Row(
      children: [
        const Text(
          "Date: ",
          style: TextStyle(height: 2, fontFamily: 'Unna'),
        ),
        Text(
          "from ${widget.leave.fromDate}",
          style: const TextStyle(height: 2, fontFamily: 'Unna'),
        ),
        Text(
          " to ${widget.leave.toDate}",
          style: const TextStyle(height: 2, fontFamily: 'Unna'),
        ),
      ],
    );
  }
}
