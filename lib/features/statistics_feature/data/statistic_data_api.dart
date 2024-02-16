import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uct_chat/api/apis.dart';
import 'package:uct_chat/models/chat_user.dart';

class StatisticDataAPI {
  static ChatUser userdata = APIs.me;
  static FirebaseFirestore myFirestore = APIs.firestore;
  // leaves statistics ------------------------
  static Future<int> getMyHourlyLeaves(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(DateTime.now().year.toString())
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userdata.id)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "0")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMySickLeaves(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(DateTime.now().year.toString())
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userdata.id)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "1")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMyAnnualLeaves(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(DateTime.now().year.toString())
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userdata.id)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "2")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMyUnpaidLeaves(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(DateTime.now().year.toString())
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userdata.id)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "3")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMyUpdatesCount(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(DateTime.now().year.toString())
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userdata.id)
        .collection("my_updates")
        .get();
    return snapshot.docs.length;
  }

  // updates statistics ------------------------
  static Future<int> getMyInfoUpdates(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userdata.id)
        .collection("my_updates")
        .where('message_color', isEqualTo: "blue")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMyWarninigUpdates(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userdata.id)
        .collection("my_updates")
        .where('message_color', isEqualTo: "orange")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMyUrgentUpdates(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userdata.id)
        .collection("my_updates")
        .where('message_color', isEqualTo: "red")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getMyGoodUpdates(int month) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userdata.id)
        .collection("my_updates")
        .where('message_color', isEqualTo: "green")
        .get();
    return snapshot.docs.length;
  }
}
