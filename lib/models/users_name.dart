import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? id;
  String? pushToken;

  UserModel({this.name, this.id, this.pushToken});

  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return UserModel(
      name: d['name'],
      id: d['id'],
      pushToken: d['push_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'push_token': pushToken
    };
  }
}
