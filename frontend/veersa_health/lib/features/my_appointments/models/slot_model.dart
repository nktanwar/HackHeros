class SlotModel {
  final DateTime startTime;
  final DateTime endTime;

  SlotModel({required this.startTime, required this.endTime});

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}