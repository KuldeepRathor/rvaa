import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String uid;
  late String name;
  late String email;
  late String phone;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });


  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }


  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
    );
  }
}
