import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? id;

  UserModel({
    this.name,
    this.id
  });

  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return UserModel(
      name: d['name'],
      id: d['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
