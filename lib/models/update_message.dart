import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMessages {
  UpdateMessages({
    required this.time,
    required this.mention,
    required this.subject,
    required this.body,
    required this.color,
  });
  late String time;
  late String mention;
  late String subject;
  late String body;
  late String color;

  UpdateMessages.fromJson(Map<String, dynamic> json) {
    time = json['message_time_added'] ?? '';
    mention = json['message_mention'] ?? '';
    subject = json['message_subject'] ?? '';
    body = json['message_body'] ?? '';
    color = json['message_color'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message_time_added'] = time;
    data['message_mention'] = mention;
    data['message_subject'] = subject;
    data['message_body'] = body;
    data['message_color'] = color;
    return data;
  }
}
