import 'package:get/get.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/notifications/models/notificaton_model.dart';

class NotificationRepository extends GetxService {
  static NotificationRepository get instance => Get.find();
  final ApiService _apiService = ApiService();

  Future<List<NotificationModel>> getMyNotifications() async {
    try {
      final response = await _apiService.get('/api/notifications/my');
      List<dynamic> data = response.data;
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      throw 'Error fetching notifications: $e';
    }
  }
}