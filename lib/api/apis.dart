import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

import '../models/chat_user.dart';
import '../models/message.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
  // for storing self information
  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using UCT Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      pushToken: '',
      role: 0,
      salary: '0',
      position: 'Choose Position',
      rating: '0',
      callId: '');

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

    // for handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      log('Message title: ${message.notification!.title}');
      log('Message body: ${message.notification!.body}');
      if (message.notification != null) {
        // navigatorKey.currentState!
        //     .pushNamed(CreateUpdateScreen.route, arguments: message);
      }
    });
  }

  // for sending push notification
  static Future<void> sendPushNotification(
    ChatUser chatUser,
    String msg,
  ) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "some_data": "User ID: ${me.id}",
        },
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAALrmzHvg:APA91bGFl_jURWUPBXuMaoAYlCoPGgJovYKJjasoz8tNjSAhZ0xmvbOS2Gws2iP6dO1tdgsoyndEuvx8tolLk_ULaYoqVNmqDocjBJgbRtn6enxo2FzY36fr4PA5YazZfzxtC8YY89k3',
        },
        body: jsonEncode(body),
      );
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('$e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    log('data: ${data.docs}');
    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists
      log('user exists: ${data.docs.first.data()}');
      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      //user doesn't exists
      return false;
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo(int? role) async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser(role!).then((value) => getSelfInfo(role));
      }
    });
  }

  // for creating a new user
  static Future<void> createUser(int role) async {
    DateTime utcDateTime = DateTime.now().toUtc();
    String utcDateTimeString = utcDateTime.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using UCT Chat!",
      image: user.photoURL.toString(),
      createdAt: utcDateTimeString,
      isOnline: false,
      lastActive: utcDateTimeString,
      pushToken: '',
      role: role,
      salary: '0',
      position: 'Choose Position',
      rating: '0',
      callId: '',
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Future<void> deleteMyUser(String userId) {
    return firestore
        .collection('users')
        .doc(me.id)
        .collection('my_users')
        .doc(userId)
        .delete();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersForAdmin() {
    return firestore.collection('users').snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
    List<String> userIds,
  ) {
    log('\nUserIds: $userIds');
    return firestore
        .collection('users')
        .where(
          'id',
          whereIn: userIds.isEmpty ? [''] : userIds,
        ) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
    ChatUser chatUser,
    String msg,
    Type type,
  ) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo({
    required String newName,
    required String newAbout,
    required String newPosition,
    required String newSalary,
    required String userId,
  }) async {
    print("Updated Id: $userId");
    await firestore.collection('users').doc(userId).update({
      'name': newName,
      'about': newAbout,
      'position': newPosition,
      'salary': newSalary,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file, String userId) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/$userId.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    String image = await ref.getDownloadURL();
    await firestore.collection('users').doc(userId).update({'image': image});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().toUtc().toString(),
      'push_token': me.pushToken,
    });
  }

  static Future<void> updateRatingStatus(String rating, String userId) async {
    firestore.collection('users').doc(userId).update({
      'rating': rating,
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
    ChatUser chatUser,
    String msg,
    Type type,
  ) async {
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: DateTime.now().toUtc().toString(),
    );

    final ref = firestore.collection(
      'chats/${getConversationID(chatUser.id)}/messages/',
    );
    await ref.doc(DateTime.now().toUtc().toString()).set(message.toJson()).then(
          (value) => sendPushNotification(
            chatUser,
            type == Type.text
                ? msg
                : type == Type.image
                    ? 'image'
                    : type == Type.audio
                        ? 'audio'
                        : type == Type.video
                            ? 'video'
                            : 'document',
          ),
        );
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static Future<void> sendChatVideo(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'videos/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'video/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final videoUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, videoUrl, Type.video);
  }

  static Future<void> sendChatDoc(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'files/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'pdf/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final pdfUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, pdfUrl, Type.doc);
  }

  static Future<void> sendChatAudio(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
          'assets/audios/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext',
        );

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'audio/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final audioUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, audioUrl, Type.audio);
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image ||
        message.type == Type.audio ||
        message.type == Type.doc ||
        message.type == Type.video) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  static Future<String> getPushToken(String userId) async {
    final docSnapshot = await firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final pushToken = data!['push_token'] as String;
      return pushToken;
    } else {
      throw Exception('User document not found');
    }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  static Future<void> createUpdate(
    String mention,
    String subject,
    String body,
    String color,
    String idMention,
    String pushToken,
  ) async {
    await firestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection("year_updates")
        .doc((DateTime.now().month).toString())
        .collection("month_updates")
        .doc(DateTime.now().toUtc().toString())
        .set({
      'message_time_added': DateTime.now().toUtc().toString(),
      'message_idMention': idMention,
      'message_mention': mention,
      'message_subject': subject,
      'message_body': body,
      'message_color': color
    }).then((value) async {
      await firestore
          .collection('updates')
          .doc((DateTime.now().year).toString())
          .collection('year_updates')
          .doc((DateTime.now().month).toString())
          .collection('month_updates')
          .doc(idMention)
          .collection("my_updates")
          .doc(DateTime.now().toUtc().toString())
          .set({
        'message_time_added': DateTime.now().toUtc().toString(),
        'message_idMention': idMention,
        'message_mention': mention,
        'message_subject': subject,
        'message_body': body,
        'message_color': color
      }).then((value) {
        mention == "everyone"
            ? sendTopicNotification(subject, body)
            : sendUpdate(pushToken, subject, Type.text, idMention);
      });
    });
  }

  static Future<void> editUpdate(
    String mention,
    String subject,
    String body,
    String color,
    String time,
    String idMention,
  ) async {
    await firestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection("year_updates")
        .doc((DateTime.now().month).toString())
        .collection("month_updates")
        .doc(time)
        .set({
      'message_time_added': time,
      'message_idMention': idMention,
      'message_mention': mention,
      'message_subject': subject,
      'message_body': body,
      'message_color': color
    }).then((value) async {
      await firestore
          .collection('updates')
          .doc((DateTime.now().year).toString())
          .collection('year_updates')
          .doc((DateTime.now().month).toString())
          .collection('month_updates')
          .doc(idMention)
          .collection("my_updates")
          .doc(time)
          .set({
        'message_time_added': time,
        'message_idMention': idMention,
        'message_mention': mention,
        'message_subject': subject,
        'message_body': body,
        'message_color': color
      });
    });
  }

  static Future<void> deleteOneUpdate(
    String time,
    String idMention,
  ) async {
    await firestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection("year_updates")
        .doc((DateTime.now().month).toString())
        .collection("month_updates")
        .doc(time)
        .delete()
        .then((value) async {
      await firestore
          .collection('updates')
          .doc((DateTime.now().year).toString())
          .collection('year_updates')
          .doc((DateTime.now().month).toString())
          .collection('month_updates')
          .doc(idMention)
          .collection("my_updates")
          .doc(time)
          .delete();
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUpdateMessages() {
    return firestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc((DateTime.now().month).toString())
        .collection('month_updates')
        .orderBy("message_time_added", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUpdateMessages() {
    return firestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc((DateTime.now().month).toString())
        .collection('month_updates')
        .doc(me.id)
        .collection('my_updates')
        .snapshots();
  }

  static Future<void> updateAdminPassword(String value) {
    return firestore
        .collection('settings')
        .doc('2025_2026')
        .update({'admin_password': value});
  }

  static Future<String> getAdminPassword() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('2025_2026')
        .get();
    return snapshot.get('admin_password');
  }

  static Future<void> updateZegoCloudAppId(String value) {
    return firestore
        .collection('settings')
        .doc('2025_2026')
        .update({'zego_app_id': value});
  }

  static Future<String> getZegoCloudAppId() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('2025_2026')
        .get();
    return snapshot.get('zego_app_id');
  }

  static Future<void> updateZegoCloudAppSign(String value) {
    return firestore
        .collection('settings')
        .doc('2025_2026')
        .update({'zego_app_sign': value});
  }

  static Future<String> getZegoCloudAppSign() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('2025_2026')
        .get();
    return snapshot.get('zego_app_sign');
  }

  static Future<void> leaveApply(
      String fromDate,
      String toDate,
      String fromTime,
      String toTime,
      String cause,
      String type,
      String adminPushToken,
      String adminId) {
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .doc(DateTime.now().toUtc().toString())
        .set({
          'leave_time_added': DateTime.now().toUtc().toString(),
          'leave_from_date': fromDate,
          'leave_to_date': toDate,
          'leave_from_time': fromTime,
          'leave_to_time': toTime,
          'leave_cause': cause,
          'leave_type': type,
          'leave_id': me.id,
          'leave_status': "0",
          "leave_name": me.name
        })
        .then(
          (value) => firestore
              .collection('leaves')
              .doc((DateTime.now().year).toString())
              .collection('year_leaves')
              .doc((DateTime.now().month).toString())
              .collection('month_leaves')
              .doc(me.id)
              .collection("my_leaves")
              .doc(DateTime.now().toUtc().toString())
              .set({
            'leave_time_added': DateTime.now().toUtc().toString(),
            'leave_from_date': fromDate,
            'leave_to_date': toDate,
            'leave_from_time': fromTime,
            'leave_to_time': toTime,
            'leave_cause': cause,
            'leave_type': type,
            'leave_id': me.id,
            'leave_status': "0",
            "leave_name": me.name
          }),
        )
        .then(
          (value) => sendLeave(adminPushToken, me.name, Type.text, adminId),
        );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllLeaves() {
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .orderBy("leave_time_added", descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyLeaves() {
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .doc(me.id)
        .collection("my_leaves")
        .snapshots();
  }

  static Future<void> updateLeaveStatus(
    String status,
    String docId,
    String userId,
  ) {
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .doc(docId)
        .update({'leave_status': status}).then(
      (value) => firestore
          .collection('leaves')
          .doc((DateTime.now().year).toString())
          .collection('year_leaves')
          .doc((DateTime.now().month).toString())
          .collection('month_leaves')
          .doc(userId)
          .collection('my_leaves')
          .doc(docId)
          .update({'leave_status': status}),
    );
  }

  static Future<void> deleteLeave(String docId) {
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .doc(docId)
        .delete()
        .then(
          (value) => firestore
              .collection('leaves')
              .doc((DateTime.now().year).toString())
              .collection('year_leaves')
              .doc((DateTime.now().month).toString())
              .collection('month_leaves')
              .doc(me.id)
              .collection('my_leaves')
              .doc(docId)
              .delete(),
        );
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAdminPushToken() {
    return firestore
        .collection('users')
        .where('role', isEqualTo: 1)
        .snapshots();
  }

  static Future<int> getRole() async {
    final docSnapshot = await firestore.collection('users').doc(me.id).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final roleValue = int.parse(data!['role']);
      return roleValue;
    } else {
      throw Exception('User role not found');
    }
  }

  static Future<void> deleteUser(String id) {
    return firestore.collection('users').doc(id).delete().then(
          (value) => deleteLeaves(id)
              .then(
                (value) => deleteUpdates(id),
              )
              .then((value) =>
                  storage.ref().child('profile_pictures/$id.jpg').delete()),
        );
  }

  static Future<void> deleteLeaves(String userId) {
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .doc(userId)
        .delete()
        .then(
          (value) => firestore
              .collection('leaves')
              .doc((DateTime.now().year).toString())
              .collection('year_leaves')
              .doc((DateTime.now().month).toString())
              .collection('month_leaves')
              .doc(userId)
              .delete(),
        );
  }

  static Future<void> deleteUpdates(String userId) {
    return firestore
        .collection('updates')
        .doc((DateTime.now().year).toString())
        .collection('year_updates')
        .doc((DateTime.now().month).toString())
        .collection('month_updates')
        .doc(userId)
        .delete()
        .then(
          (value) => firestore
              .collection('updates')
              .doc((DateTime.now().year).toString())
              .collection('year_updates')
              .doc((DateTime.now().month).toString())
              .collection('month_updates')
              .doc(userId)
              .delete(),
        );
  }

  static Future<void> sendUpdate(
    String userPushToken,
    String msg,
    Type type,
    String userId,
  ) async {
    final Message message = Message(
      toId: userId,
      msg: "new update for $msg",
      read: '',
      type: type,
      fromId: me.id,
      sent: DateTime.now().toUtc().toString(),
    );

    final ref = firestore.collection(
      'updates/',
    );
    await ref.doc(DateTime.now().toUtc().toString()).set(message.toJson()).then(
          (value) => sendUpdateNotification(
            userPushToken,
            type == Type.text
                ? msg
                : type == Type.image
                    ? 'image'
                    : type == Type.audio
                        ? 'audio'
                        : type == Type.video
                            ? 'video'
                            : 'document',
          ),
        );
  }

  static Future<void> sendLeave(
    String userPushToken,
    String msg,
    Type type,
    String to,
  ) async {
    final Message message = Message(
      toId: to,
      msg: "$msg apply for leave",
      read: '',
      type: type,
      fromId: me.id,
      sent: DateTime.now().toUtc().toString(),
    );

    final ref = firestore.collection(
      'leaves/',
    );
    await ref.doc(DateTime.now().toUtc().toString()).set(message.toJson()).then(
          (value) => sendLeaveNotification(
            userPushToken,
            type == Type.text
                ? msg
                : type == Type.image
                    ? 'image'
                    : type == Type.audio
                        ? 'audio'
                        : type == Type.video
                            ? 'video'
                            : 'document',
          ),
        );
  }

  static Future<void> sendUpdateNotification(
    String pushID,
    String msg,
  ) async {
    try {
      final body = {
        "to": pushID,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "updates"
        },
        "data": {
          "some_data": "User ID: ${me.id}",
        },
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAALrmzHvg:APA91bGFl_jURWUPBXuMaoAYlCoPGgJovYKJjasoz8tNjSAhZ0xmvbOS2Gws2iP6dO1tdgsoyndEuvx8tolLk_ULaYoqVNmqDocjBJgbRtn6enxo2FzY36fr4PA5YazZfzxtC8YY89k3',
        },
        body: jsonEncode(body),
      );
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('$e');
    }
  }

  static Future<void> sendLeaveNotification(
    String pushID,
    String msg,
  ) async {
    try {
      final body = {
        "to": pushID,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "leaves"
        },
        "data": {
          "some_data": "User ID: ${me.id}",
        },
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAALrmzHvg:APA91bGFl_jURWUPBXuMaoAYlCoPGgJovYKJjasoz8tNjSAhZ0xmvbOS2Gws2iP6dO1tdgsoyndEuvx8tolLk_ULaYoqVNmqDocjBJgbRtn6enxo2FzY36fr4PA5YazZfzxtC8YY89k3',
        },
        body: jsonEncode(body),
      );
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('$e');
    }
  }

  // delete chatbox
  static Future<void> deleteChat(String chatId) async {
    try {
      final docRef = firestore
          .collection('chats')
          .doc(chatId);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.delete();
      } else {
        print("Not Exist");
      }

      final imagesRef = storage.ref().child('images/$chatId');
      final audiosRef = storage.ref().child('assets/audios/$chatId');
      final filesRef = storage.ref().child('files/$chatId');

      final imagesListResult = await imagesRef.listAll();
      final audiosListResult = await audiosRef.listAll();
      final filesListResult = await filesRef.listAll();

      imagesListResult.items.forEach((imageRef) async {
        await imageRef.delete();
      });

      audiosListResult.items.forEach((audioRef) async {
        await audioRef.delete();
      });

      filesListResult.items.forEach((fileRef) async {
        await fileRef.delete();
      });

      imagesRef.delete();
      audiosRef.delete();
      filesRef.delete();
      
    } catch (e) {
      print("Error occurred during deletion: $e");
    }
  }

  static Future<void> sendTopicNotification(
      String title, String subject) async {
    try {
      final data = {
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
        "id": '1',
        "status": 'done',
        "message": title,
      };

      var res = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAALrmzHvg:APA91bGFl_jURWUPBXuMaoAYlCoPGgJovYKJjasoz8tNjSAhZ0xmvbOS2Gws2iP6dO1tdgsoyndEuvx8tolLk_ULaYoqVNmqDocjBJgbRtn6enxo2FzY36fr4PA5YazZfzxtC8YY89k3',
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{'title': title, 'body': subject},
          'priority': 'high',
          'data': data,
          'to': '/topics/subscribtion',
        }),
      );
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('$e');
    }
  }

  static Future<void> newUserSalary({
    required String userId,
    int increase = 0,
    int decrease = 0,
    required int oldSalary,
  }) {
    String newSalary = "${oldSalary + increase - decrease}";
    return firestore
        .collection('users')
        .doc(userId)
        .update({'salary': newSalary});
  }

  static Future<void> newUserCallId({
    required String userId,
    required String newCallId,
  }) {
    return firestore
        .collection('users')
        .doc(userId)
        .update({'callId': newCallId});
  }
}
