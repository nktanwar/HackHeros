import 'package:get/get.dart';
import 'package:veersa_health/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  // Function to save user data
  Future<void> saveUserRecord(UserModel user) async {
    try {} catch (e) {}
  }

  //Fucntion to fetch user details based on user id
  Future<UserModel> fetchUserDetails() async {
    try {
      return UserModel.empty();
    } catch (e) {
      return UserModel.empty();
    }
  }

  //Function to update user data in firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
    }catch(e){}
  }

  //Function to update user single field data in firestore
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      
    } catch(e){}
  }

  // Future<void> removeUserData(String userId) async {
  // }
}
