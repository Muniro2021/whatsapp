class LeaveApply {
  LeaveApply({
    required this.time,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
    required this.cause,
    required this.type,
    required this.id,
    required this.status,
    required this.name,
  });
  late String time;
  late String fromDate;
  late String toDate;
  late String fromTime;
  late String toTime;
  late String cause;
  late String type;
  late String id;
  late String status;
  late String name;

  LeaveApply.fromJson(Map<String, dynamic> json) {
    time = json['leave_time_added'] ?? '';
    fromDate = json['leave_from_date'] ?? '';
    toDate = json['leave_to_date'] ?? '';
    fromTime = json['leave_from_time'] ?? '';
    toTime = json['leave_to_time'] ?? '';
    cause = json['leave_cause'] ?? '';
    type = json['leave_type'] ?? '';
    id = json['leave_id'] ?? '';
    status = json['leave_status'] ?? '';
    name = json['leave_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['leave_date'] = time;
    data['leave_time'] = fromDate;
    data['leave_cause'] = toDate;
    data['leave_type'] = fromTime;
    data['leave_date'] = toTime;
    data['leave_time'] = cause;
    data['leave_cause'] = type;
    data['leave_type'] = id;
    data['leave_type'] = status;
    data['leave_name'] = name;
    return data;
  }
}
