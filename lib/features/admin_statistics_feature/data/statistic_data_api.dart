import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uct_chat/api/apis.dart';

class StatisticDataAPI {
  static FirebaseFirestore myFirestore = APIs.firestore;
  // leaves statistics ------------------------
  static Future<int> getUserHourlyLeaves(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "0")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserSickLeaves(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "1")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserAnnualLeaves(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "2")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserUnpaidLeaves(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: "3")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserUpdatesCount(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(year)
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userId)
        .collection("my_updates")
        .get();
    return snapshot.docs.length;
  }

  // updates statistics ------------------------
  static Future<int> getUserInfoUpdates(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(year)
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userId)
        .collection("my_updates")
        .where('message_color', isEqualTo: "blue")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserWarninigUpdates(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(year)
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userId)
        .collection("my_updates")
        .where('message_color', isEqualTo: "orange")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserUrgentUpdates(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(year)
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userId)
        .collection("my_updates")
        .where('message_color', isEqualTo: "red")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getUserGoodUpdates(
      String year, int month, String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(year)
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userId)
        .collection("my_updates")
        .where('message_color', isEqualTo: "green")
        .get();
    return snapshot.docs.length;
  }

  static Future<String> getLeaveHours(
    String year,
    int month,
    String userId,
  ) async {
    // Create a reference to the Firestore collection
    final collectionReference = myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection('my_leaves')
        .where('leave_type', isEqualTo: "0");
    final querySnapshot = await collectionReference.get();
    Duration totalHours = Duration.zero;
    for (var documentSnapshot in querySnapshot.docs) {
      final leaveFromDate = documentSnapshot.data()['leave_from_date'];
      final leaveFromTime = documentSnapshot.data()['leave_from_time'];
      final leaveToDate = documentSnapshot.data()['leave_to_date'];
      final leaveToTime = documentSnapshot.data()['leave_to_time'];
      final leaveFrom = DateTime.parse('$leaveFromDate $leaveFromTime');
      final leaveTo = DateTime.parse('$leaveToDate $leaveToTime');
      final leaveDuration = leaveTo.difference(leaveFrom);
      totalHours += leaveDuration;
    }
    final hours = (totalHours.inHours % 24).toString().padLeft(2, '0');
    final minutes = (totalHours.inMinutes % 60).toString().padLeft(2, '0');
    final totalFormatted = '$hours:$minutes hours';
    return totalFormatted;
  }

  static Future<String> getLeaveDays(
    String year,
    int month,
    String userId,
  ) async {
    // Create a reference to the Firestore collection
    final collectionReferenceSick = myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection('my_leaves')
        .where('leave_type', isEqualTo: "1");
    final querySnapshotSick = await collectionReferenceSick.get();
    Duration sickTotalDuration = Duration.zero;
    for (var documentSnapshot in querySnapshotSick.docs) {
      final leaveFromDate = documentSnapshot.data()['leave_from_date'];
      final leaveFromTime = documentSnapshot.data()['leave_from_time'];
      final leaveToDate = documentSnapshot.data()['leave_to_date'];
      final leaveToTime = documentSnapshot.data()['leave_to_time'];
      final leaveFrom = DateTime.parse('$leaveFromDate $leaveFromTime');
      final leaveTo = DateTime.parse('$leaveToDate $leaveToTime');
      final leaveDuration = leaveTo.difference(leaveFrom);
      sickTotalDuration += leaveDuration;
    }
    final sickDays = sickTotalDuration.inDays;

    final collectionReferenceAnnual = myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection('my_leaves')
        .where('leave_type', isEqualTo: "2");
    final querySnapshotAnnual = await collectionReferenceAnnual.get();
    Duration annualTotalDuration = Duration.zero;
    for (var documentSnapshot in querySnapshotAnnual.docs) {
      final leaveFromDate = documentSnapshot.data()['leave_from_date'];
      final leaveFromTime = documentSnapshot.data()['leave_from_time'];
      final leaveToDate = documentSnapshot.data()['leave_to_date'];
      final leaveToTime = documentSnapshot.data()['leave_to_time'];
      final leaveFrom = DateTime.parse('$leaveFromDate $leaveFromTime');
      final leaveTo = DateTime.parse('$leaveToDate $leaveToTime');
      final leaveDuration = leaveTo.difference(leaveFrom);
      annualTotalDuration += leaveDuration;
    }
    final annualDays = annualTotalDuration.inDays;

    final collectionReferenceUnpaid = myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection('my_leaves')
        .where('leave_type', isEqualTo: "3");
    final querySnapshotUnpaid = await collectionReferenceUnpaid.get();
    Duration unpaidTotalDuration = Duration.zero;
    for (var documentSnapshot in querySnapshotUnpaid.docs) {
      final leaveFromDate = documentSnapshot.data()['leave_from_date'];
      final leaveFromTime = documentSnapshot.data()['leave_from_time'];
      final leaveToDate = documentSnapshot.data()['leave_to_date'];
      final leaveToTime = documentSnapshot.data()['leave_to_time'];
      final leaveFrom = DateTime.parse('$leaveFromDate $leaveFromTime');
      final leaveTo = DateTime.parse('$leaveToDate $leaveToTime');
      final leaveDuration = leaveTo.difference(leaveFrom);
      unpaidTotalDuration += leaveDuration;
    }
    final unpaidDays = unpaidTotalDuration.inDays;

    var x = sickDays + annualDays + unpaidDays;

    final TotalFormatted = '$x days';

    return TotalFormatted;
  }
  
}
