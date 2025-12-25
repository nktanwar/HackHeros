class DoctorModel {
  final String id;
  final String name;
  final String speciality;
  final String image;
  final double distanceKm;
  final double fees;

  DoctorModel({
    required this.id,
    required this.name,
    required this.speciality,
    required this.image,
    required this.distanceKm,
    required this.fees,
  });
}