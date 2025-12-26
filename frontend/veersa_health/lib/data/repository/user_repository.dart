import 'package:get/get.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/personalisation/models/user_model.dart';

class UserRepository extends GetxService {
  static UserRepository get instance => Get.find();
  final ApiService _apiService = ApiService();

  /// Fetch User Details from backend
  Future<UserModel> getUserDetails() async {
    try {
      final response = await _apiService.get('/api/users/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw 'Failed to fetch profile: ${response.statusMessage}';
      }
    } catch (e) {
      throw 'Something went wrong: $e';
    }
  }
}
