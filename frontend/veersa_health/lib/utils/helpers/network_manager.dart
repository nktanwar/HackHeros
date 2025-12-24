import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';

class NetworkManager extends GetxController {

  static NetworkManager get instance => Get.find();
  final Connectivity _connectivity = Connectivity();

  // Stream subscription to listen to network changes
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Observable network status (default: no connection)
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  /// Get current network status
  ConnectivityResult get status => _connectionStatus.value;

  /// Initialize network listener when controller starts
  @override
  void onInit() {
    super.onInit();

    // Start listening to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      for (var result in results) {
        _updateConnectionStatus(result);
      }
    });
  }

  /// Update network status when changed
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;

    // If no internet, show warning message
    if (_connectionStatus.value == ConnectivityResult.none) {
      CustomLoaders.customToast(message: 'Please check your network settings.');
    }
  }

  /// Manually check internet connectivity
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.none) ? false : true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Dispose the stream when the controller is destroyed
  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
