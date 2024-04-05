import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/model/userviewmodel.dart';



class UserViewModel {
  Future<UserModel> fetchUsers() async {
    try {
      final documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (documentSnapshot.exists){
        return UserModel.fromSnapshot(documentSnapshot);
      }
      else{
        return UserModel(uid: "uid", name: "", email: "email", phone: "phone");
      }
    } catch (e) {
      throw Exception('Failed to fetch user records: $e');
    }
  }
}
