import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uct_chat/api/apis.dart';

class StatisticDataAPI {
  static FirebaseFirestore myFirestore = APIs.firestore;
  // leaves statistics ------------------------

  static Future<int> getAllMonthlyLeaves(
    String year,
    int month,
    String userId,
  ) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection("my_leaves")
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getSpecificMonthlyLeaves(
    String year,
    int month,
    String userId,
    String type,
  ) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('leaves')
        .doc(year)
        .collection('year_leaves')
        .doc(month.toString())
        .collection('month_leaves')
        .doc(userId)
        .collection("my_leaves")
        .where('leave_type', isEqualTo: type)
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getAllYearlyLeaves(
    String year,
    String userId,
  ) async {
    int totalLeaves = 0;
    for (int i = 1; i <= 12; i++) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
          .collection('leaves')
          .doc(year)
          .collection('year_leaves')
          .doc(i.toString())
          .collection('month_leaves')
          .doc(userId)
          .collection("my_leaves")
          .get();
      totalLeaves += snapshot.docs.length;
    }
    return totalLeaves;
  }

  static Future<int> getSpecificYearlyLeaves(
    String year,
    String userId,
    String type,
  ) async {
    int totalLeaves = 0;
    for (int i = 1; i <= 12; i++) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
          .collection('leaves')
          .doc(year)
          .collection('year_leaves')
          .doc(i.toString())
          .collection('month_leaves')
          .doc(userId)
          .collection("my_leaves")
          .where('leave_type', isEqualTo: type)
          .get();
      totalLeaves += snapshot.docs.length;
    }
    return totalLeaves;
  }
  // ------------------------------------------------------------------

  // updates statistics ------------------------

  static Future<int> getAllMonthlyUpdates(
    String year,
    int month,
    String userId,
  ) async {
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

  static Future<int> getSpecificMonthlyUpdates(
    String year,
    int month,
    String userId,
    String type,
  ) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
        .collection('updates')
        .doc(year)
        .collection('year_updates')
        .doc(month.toString())
        .collection('month_updates')
        .doc(userId)
        .collection("my_updates")
        .where('message_color', isEqualTo: type)
        .get();
    return snapshot.docs.length;
  }

  static Future<int> getAllYearlyUpdates(
    String year,
    String userId,
  ) async {
    int totalUpdates = 0;
    for (int i = 1; i <= 12; i++) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
          .collection('updates')
          .doc(year)
          .collection('year_updates')
          .doc(i.toString())
          .collection('month_updates')
          .doc(userId)
          .collection("my_leaves")
          .get();
      totalUpdates += snapshot.docs.length;
    }
    return totalUpdates;
  }

  static Future<int> getSpecificYearlyUpdates(
    String year,
    String userId,
    String type,
  ) async {
    int totalUpdates = 0;
    for (int i = 1; i <= 12; i++) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await myFirestore
          .collection('updates')
          .doc(year)
          .collection('year_updates')
          .doc(i.toString())
          .collection('month_updates')
          .doc(userId)
          .collection("my_leaves")
          .where('message_color', isEqualTo: type)
          .get();
      totalUpdates += snapshot.docs.length;
    }
    return totalUpdates;
  }

  // ------------------------------------------------------------------

  // others statistics ------------------------

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

      // Convert leave dates and times to DateTime objects
      final leaveFrom = DateTime.parse('$leaveFromDate $leaveFromTime');
      final leaveTo = DateTime.parse('$leaveToDate $leaveToTime');

      // Get the local time
      final localLeaveFrom = leaveFrom.toLocal();
      final localLeaveTo = leaveTo.toLocal();

      // Calculate leave duration
      final leaveDuration = localLeaveTo.difference(localLeaveFrom);
      totalHours += leaveDuration;
    }

    // Format the total leave duration
    final hours = (totalHours.inHours % 24).toString().padLeft(2, '0');
    final minutes = (totalHours.inMinutes % 60).toString().padLeft(2, '0');
    final totalFormatted = '$hours:$minutes';
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

    final totalFormatted = '$x';

    return totalFormatted;
  }
}
