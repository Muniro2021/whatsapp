import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;

  UserModel({
    this.name,
  });

  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return UserModel(
      name: d['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
