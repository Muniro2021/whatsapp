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
    rating: '0'
  );

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
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

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
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
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using UCT Chat!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      role: role,
      salary: '0',
      position: 'Choose Position',
      rating: '0'
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsersForAdmin() {
    return firestore.collection('users').snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');
    return firestore
        .collection('users')
        .where('id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
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
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
      'position': me.position,
      'salary': me.salary,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
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
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
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
      ChatUser user) {
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
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
    );

    final ref = firestore.collection(
      'chats/${getConversationID(chatUser.id)}/messages/',
    );
    await ref.doc(time).set(message.toJson()).then(
          (value) => sendPushNotification(
            chatUser,
            type == Type.text ? msg : 'image',
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

    if (message.type == Type.image || message.type == Type.audio) {
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
    String pushToken, // Add the push token parameter
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
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
    // .then((value) async {
    //   final ref = firestore.collection(
    //     'updates/$idMention/my_updates/$time/',
    //   );
    //   await ref.doc(time).set({}).then(
    //     (value) => sendUpdateNotification(pushToken.toString(), mention, body),
    //   );
    // });
  }

  static Future<void> sendUpdateNotification(
    String pushToken,
    String mention,
    String subject,
    // String time,
  ) async {
    try {
      final body = {
        "to": pushToken.toString(),
        "notification": {
          "title": mention,
          "body": subject,
          "android_channel_id": "updates"
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
      log('sendUpdateNotification $e');
    }
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
        .collection('admin_password')
        .doc('admin_2024_password')
        .update({'password': value});
  }

  static Future<String> getAdminPassword() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('admin_password')
        .doc('admin_2024_password')
        .get();
    return snapshot.get('password');
  }

  static Future<void> leaveApply(
    String fromDate,
    String toDate,
    String fromTime,
    String toTime,
    String cause,
    String type,
  ) {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    return firestore
        .collection('leaves')
        .doc((DateTime.now().year).toString())
        .collection('year_leaves')
        .doc((DateTime.now().month).toString())
        .collection('month_leaves')
        .doc(time)
        .set({
      'leave_time_added': time,
      'leave_from_date': fromDate,
      'leave_to_date': toDate,
      'leave_from_time': fromTime,
      'leave_to_time': toTime,
      'leave_cause': cause,
      'leave_type': type,
      'leave_id': me.id,
      'leave_status': "0",
      "leave_name": me.name
    }).then(
      (value) => firestore
          .collection('leaves')
          .doc((DateTime.now().year).toString())
          .collection('year_leaves')
          .doc((DateTime.now().month).toString())
          .collection('month_leaves')
          .doc(me.id)
          .collection("my_leaves")
          .doc(time)
          .set({
        'leave_time_added': time,
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

  static Future<void> sendLeaveNotification(
    String pushToken,
    String user,
    String cause,
  ) async {
    try {
      final body = {
        "to": pushToken.toString(),
        "notification": {
          "title": user,
          "body": cause,
          "android_channel_id": "leaves"
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
      log('sendUpdateNotification $e');
    }
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

  static Future<void> deleteUser(String userId) {
    return firestore.collection('users').doc(userId).delete().then(
          (value) => deleteLeaves(userId).then(
            (value) => deleteUpdates(userId),
          ),
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
}
