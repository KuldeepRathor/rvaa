import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../auth/model/userviewmodel.dart';
import '../viewmodel/userviewmodel.dart';


class UserController extends GetxController {
  Rx<UserModel?> userData = Rx<UserModel?>(null);
  final userdata=Get.put(UserViewModel());

  @override
  void onInit() {
    super.onInit();
    // Initialize the user data when the controller is created
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user =await userdata.fetchUsers();
      this.userData(user);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

}
